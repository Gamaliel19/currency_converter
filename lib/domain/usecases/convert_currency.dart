import 'package:dartz/dartz.dart';
import '../entities/conversion.dart';
import '../repositories/currency_repository.dart';
import '../../core/errors/failures.dart';

/// Paramètres pour la conversion de devise
class ConvertCurrencyParams {
  final double amount;
  final String from;
  final String to;

  ConvertCurrencyParams({
    required this.amount,
    required this.from,
    required this.to,
  });
}

/// Use case pour convertir une devise
class ConvertCurrency {
  final CurrencyRepository repository;

  ConvertCurrency(this.repository);

  Future<Either<Failure, Conversion>> call(ConvertCurrencyParams params) async {
    if (params.amount <= 0) {
      return const Left(InvalidConversionFailure('Le montant doit être positif'));
    }

    return await repository.convertCurrency(
      amount: params.amount,
      from: params.from,
      to: params.to,
    );
  }
}