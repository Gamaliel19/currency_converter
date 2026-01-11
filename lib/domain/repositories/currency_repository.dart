import 'package:dartz/dartz.dart';
import '../entities/conversion.dart';
import '../entities/exchange_rate.dart';
import '../../core/errors/failures.dart';

/// Contrat du repository pour les opérations de devises
abstract class CurrencyRepository {
  /// Récupère les taux de change (en ligne ou hors ligne)
  Future<Either<Failure, ExchangeRate>> getExchangeRates();
  
  /// Convertit un montant d'une devise à une autre
  Future<Either<Failure, Conversion>> convertCurrency({
    required double amount,
    required String from,
    required String to,
  });
  
  /// Récupère l'historique des conversions
  Future<Either<Failure, List<Conversion>>> getConversionHistory();
  
  /// Sauvegarde une conversion dans l'historique
  Future<Either<Failure, void>> saveConversion(Conversion conversion);
  
  /// Efface l'historique des conversions
  Future<Either<Failure, void>> clearHistory();
}