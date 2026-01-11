import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/conversion.dart';
import '../../domain/entities/exchange_rate.dart';
import '../../domain/usecases/convert_currency.dart';
import '../../domain/usecases/get_conversion_history.dart';
import '../../domain/usecases/get_exchange_rates.dart';
import 'currency_providers.dart';

/// État de la conversion
class ConversionState {
  final ExchangeRate? exchangeRate;
  final Conversion? currentConversion;
  final List<Conversion> history;
  final bool isLoading;
  final String? error;
  final bool isOffline;

  const ConversionState({
    this.exchangeRate,
    this.currentConversion,
    this.history = const [],
    this.isLoading = false,
    this.error,
    this.isOffline = false,
  });

  ConversionState copyWith({
    ExchangeRate? exchangeRate,
    Conversion? currentConversion,
    List<Conversion>? history,
    bool? isLoading,
    String? error,
    bool? isOffline,
    bool clearConversion = false,
    bool clearError = false,
  }) {
    return ConversionState(
      exchangeRate: exchangeRate ?? this.exchangeRate,
      currentConversion: clearConversion ? null : (currentConversion ?? this.currentConversion),
      history: history ?? this.history,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
      isOffline: isOffline ?? this.isOffline,
    );
  }
}

/// Notifier pour gérer l'état de la conversion
class ConversionNotifier extends StateNotifier<ConversionState> {
  final GetExchangeRates getExchangeRates;
  final ConvertCurrency convertCurrency;
  final GetConversionHistory getConversionHistory;

  ConversionNotifier({
    required this.getExchangeRates,
    required this.convertCurrency,
    required this.getConversionHistory,
  }) : super(const ConversionState()) {
    loadExchangeRates();
    loadHistory();
  }

  /// Charge les taux de change
  Future<void> loadExchangeRates() async {
    state = state.copyWith(isLoading: true, clearError: true);

    final result = await getExchangeRates();

    result.fold(
      (failure) {
        state = state.copyWith(
          isLoading: false,
          error: failure.message,
          isOffline: failure.message.contains('connexion'),
        );
      },
      (rates) {
        state = state.copyWith(
          isLoading: false,
          exchangeRate: rates,
          isOffline: false,
          clearError: true,
        );
      },
    );
  }

  /// Effectue une conversion
  Future<void> performConversion({
    required double amount,
    required String from,
    required String to,
  }) async {
    state = state.copyWith(isLoading: true, clearError: true);

    final params = ConvertCurrencyParams(
      amount: amount,
      from: from,
      to: to,
    );

    final result = await convertCurrency(params);

    result.fold(
      (failure) {
        state = state.copyWith(
          isLoading: false,
          error: failure.message,
        );
      },
      (conversion) {
        state = state.copyWith(
          isLoading: false,
          currentConversion: conversion,
          clearError: true,
        );
        loadHistory();
      },
    );
  }

  /// Charge l'historique
  Future<void> loadHistory() async {
    final result = await getConversionHistory();

    result.fold(
      (failure) {
        // Ne pas afficher d'erreur si l'historique est vide
      },
      (history) {
        state = state.copyWith(history: history);
      },
    );
  }

  /// Efface la conversion actuelle
  void clearConversion() {
    state = state.copyWith(clearConversion: true, clearError: true);
  }

  /// Efface l'erreur
  void clearError() {
    state = state.copyWith(clearError: true);
  }
}

/// Provider pour le notifier de conversion
final conversionNotifierProvider =
    StateNotifierProvider<ConversionNotifier, ConversionState>((ref) {
  return ConversionNotifier(
    getExchangeRates: ref.watch(getExchangeRatesProvider),
    convertCurrency: ref.watch(convertCurrencyProvider),
    getConversionHistory: ref.watch(getConversionHistoryProvider),
  );
});