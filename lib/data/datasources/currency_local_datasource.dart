import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/exchange_rate_model.dart';
import '../models/conversion_model.dart';
import '../../core/constants/api_constants.dart';
import '../../core/errors/exceptions.dart';

/// Interface pour la source de données locale
abstract class CurrencyLocalDataSource {
  Future<ExchangeRateModel> getCachedExchangeRates();
  Future<void> cacheExchangeRates(ExchangeRateModel rates);
  Future<List<ConversionModel>> getConversionHistory();
  Future<void> saveConversion(ConversionModel conversion);
  Future<void> clearHistory();
}

/// Implémentation de la source de données locale
class CurrencyLocalDataSourceImpl implements CurrencyLocalDataSource {
  final SharedPreferences sharedPreferences;

  CurrencyLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<ExchangeRateModel> getCachedExchangeRates() async {
    final jsonString = sharedPreferences.getString(ApiConstants.ratesStorageKey);
    
    if (jsonString != null) {
      try {
        final json = jsonDecode(jsonString) as Map<String, dynamic>;
        return ExchangeRateModel.fromJson(json);
      } catch (e) {
        throw CacheException('Erreur lors de la lecture du cache: $e');
      }
    } else {
      throw CacheException('Aucun taux de change en cache');
    }
  }

  @override
  Future<void> cacheExchangeRates(ExchangeRateModel rates) async {
    try {
      final jsonString = jsonEncode(rates.toJson());
      await sharedPreferences.setString(
        ApiConstants.ratesStorageKey,
        jsonString,
      );
      await sharedPreferences.setString(
        ApiConstants.lastUpdateKey,
        DateTime.now().toIso8601String(),
      );
    } catch (e) {
      throw CacheException('Erreur lors de la sauvegarde du cache: $e');
    }
  }

  @override
  Future<List<ConversionModel>> getConversionHistory() async {
    final jsonString = sharedPreferences.getString(
      ApiConstants.historyStorageKey,
    );
    
    if (jsonString != null) {
      try {
        final jsonList = jsonDecode(jsonString) as List;
        return jsonList
            .map((json) => ConversionModel.fromJson(json as Map<String, dynamic>))
            .toList();
      } catch (e) {
        throw CacheException('Erreur lors de la lecture de l\'historique: $e');
      }
    }
    
    return [];
  }

  @override
  Future<void> saveConversion(ConversionModel conversion) async {
    try {
      final history = await getConversionHistory();
      history.insert(0, conversion);
      
      // Limiter la taille de l'historique
      if (history.length > ApiConstants.maxHistoryItems) {
        history.removeRange(
          ApiConstants.maxHistoryItems,
          history.length,
        );
      }
      
      final jsonList = history.map((c) => c.toJson()).toList();
      final jsonString = jsonEncode(jsonList);
      
      await sharedPreferences.setString(
        ApiConstants.historyStorageKey,
        jsonString,
      );
    } catch (e) {
      throw CacheException('Erreur lors de la sauvegarde de la conversion: $e');
    }
  }

  @override
  Future<void> clearHistory() async {
    try {
      await sharedPreferences.remove(ApiConstants.historyStorageKey);
    } catch (e) {
      throw CacheException('Erreur lors de la suppression de l\'historique: $e');
    }
  }
}