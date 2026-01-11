import 'package:dartz/dartz.dart';
import '../../domain/entities/conversion.dart';
import '../../domain/entities/exchange_rate.dart';
import '../../domain/repositories/currency_repository.dart';
import '../../core/errors/failures.dart';
import '../../core/errors/exceptions.dart';
import '../../core/network/network_info.dart';
import '../datasources/currency_local_datasource.dart';
import '../datasources/currency_remote_datasource.dart';
import '../models/conversion_model.dart';

/// Implémentation du repository de devises
class CurrencyRepositoryImpl implements CurrencyRepository {
  final CurrencyRemoteDataSource remoteDataSource;
  final CurrencyLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  CurrencyRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, ExchangeRate>> getExchangeRates() async {
    final isConnected = await networkInfo.isConnected;

    try {
      if (isConnected) {
        // Récupérer depuis l'API
        final remoteRates = await remoteDataSource.getExchangeRates('USD');
        
        // Mettre en cache
        await localDataSource.cacheExchangeRates(remoteRates);
        
        return Right(remoteRates);
      } else {
        // Mode hors ligne : utiliser le cache
        final cachedRates = await localDataSource.getCachedExchangeRates();
        return Right(cachedRates);
      }
    } on ServerException catch (e) {
      // En cas d'erreur serveur, essayer le cache
      try {
        final cachedRates = await localDataSource.getCachedExchangeRates();
        return Right(cachedRates);
      } on CacheException {
        return Left(ServerFailure(e.message));
      }
    } on NetworkException catch (e) {
      try {
        final cachedRates = await localDataSource.getCachedExchangeRates();
        return Right(cachedRates);
      } on CacheException {
        return Left(NetworkFailure(e.message));
      }
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Erreur inattendue: $e'));
    }
  }

  @override
  Future<Either<Failure, Conversion>> convertCurrency({
    required double amount,
    required String from,
    required String to,
  }) async {
    try {
      final ratesResult = await getExchangeRates();
      
      return ratesResult.fold(
        (failure) => Left(failure),
        (rates) {
          final result = rates.convert(amount, from, to);
          
          if (result == null) {
            return const Left(
              InvalidConversionFailure('Impossible de convertir ces devises'),
            );
          }
          
          final fromRate = rates.getRate(from);
          final toRate = rates.getRate(to);
          
          if (fromRate == null || toRate == null) {
            return const Left(
              InvalidConversionFailure('Taux de change introuvable'),
            );
          }
          
          final rate = toRate / fromRate;
          
          final conversion = Conversion(
            amount: amount,
            fromCurrency: from,
            toCurrency: to,
            result: result,
            rate: rate,
            timestamp: DateTime.now(),
          );
          
          // Sauvegarder dans l'historique (fire and forget)
          localDataSource.saveConversion(
            ConversionModel.fromEntity(conversion),
          );
          
          return Right(conversion);
        },
      );
    } catch (e) {
      return Left(ServerFailure('Erreur lors de la conversion: $e'));
    }
  }

  @override
  Future<Either<Failure, List<Conversion>>> getConversionHistory() async {
    try {
      final history = await localDataSource.getConversionHistory();
      return Right(history);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(CacheFailure('Erreur lors de la récupération de l\'historique: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> saveConversion(Conversion conversion) async {
    try {
      await localDataSource.saveConversion(
        ConversionModel.fromEntity(conversion),
      );
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(CacheFailure('Erreur lors de la sauvegarde: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> clearHistory() async {
    try {
      await localDataSource.clearHistory();
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(CacheFailure('Erreur lors de la suppression: $e'));
    }
  }
}