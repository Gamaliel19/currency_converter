import 'package:dartz/dartz.dart';
import '../entities/exchange_rate.dart';
import '../repositories/currency_repository.dart';
import '../../core/errors/failures.dart';

/// Use case pour récupérer les taux de change
class GetExchangeRates {
  final CurrencyRepository repository;

  GetExchangeRates(this.repository);

  Future<Either<Failure, ExchangeRate>> call() async {
    return await repository.getExchangeRates();
  }
}