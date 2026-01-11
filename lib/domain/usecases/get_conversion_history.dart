import 'package:dartz/dartz.dart';
import '../entities/conversion.dart';
import '../repositories/currency_repository.dart';
import '../../core/errors/failures.dart';

/// Use case pour récupérer l'historique des conversions
class GetConversionHistory {
  final CurrencyRepository repository;

  GetConversionHistory(this.repository);

  Future<Either<Failure, List<Conversion>>> call() async {
    return await repository.getConversionHistory();
  }
}