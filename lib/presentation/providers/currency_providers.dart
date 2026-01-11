import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/network/network_info.dart';
import '../../data/datasources/currency_local_datasource.dart';
import '../../data/datasources/currency_remote_datasource.dart';
import '../../data/repositories/currency_repository_impl.dart';
import '../../domain/repositories/currency_repository.dart';
import '../../domain/usecases/convert_currency.dart';
import '../../domain/usecases/get_conversion_history.dart';
import '../../domain/usecases/get_exchange_rates.dart';

/// Provider pour le client HTTP
final httpClientProvider = Provider<http.Client>((ref) {
  return http.Client();
});

/// Provider pour SharedPreferences
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError();
});

/// Provider pour NetworkInfo
final networkInfoProvider = Provider<NetworkInfo>((ref) {
  return NetworkInfoImpl(InternetConnectionChecker());
});

/// Provider pour la source de données distante
final remoteDataSourceProvider = Provider<CurrencyRemoteDataSource>((ref) {
  return CurrencyRemoteDataSourceImpl(
    client: ref.watch(httpClientProvider),
  );
});

/// Provider pour la source de données locale
final localDataSourceProvider = Provider<CurrencyLocalDataSource>((ref) {
  return CurrencyLocalDataSourceImpl(
    sharedPreferences: ref.watch(sharedPreferencesProvider),
  );
});

/// Provider pour le repository
final currencyRepositoryProvider = Provider<CurrencyRepository>((ref) {
  return CurrencyRepositoryImpl(
    remoteDataSource: ref.watch(remoteDataSourceProvider),
    localDataSource: ref.watch(localDataSourceProvider),
    networkInfo: ref.watch(networkInfoProvider),
  );
});

/// Provider pour le use case GetExchangeRates
final getExchangeRatesProvider = Provider<GetExchangeRates>((ref) {
  return GetExchangeRates(ref.watch(currencyRepositoryProvider));
});

/// Provider pour le use case ConvertCurrency
final convertCurrencyProvider = Provider<ConvertCurrency>((ref) {
  return ConvertCurrency(ref.watch(currencyRepositoryProvider));
});

/// Provider pour le use case GetConversionHistory
final getConversionHistoryProvider = Provider<GetConversionHistory>((ref) {
  return GetConversionHistory(ref.watch(currencyRepositoryProvider));
});