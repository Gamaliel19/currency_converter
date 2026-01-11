import 'package:equatable/equatable.dart';

/// Entité représentant une conversion de devise
class Conversion extends Equatable {
  final double amount;
  final String fromCurrency;
  final String toCurrency;
  final double result;
  final double rate;
  final DateTime timestamp;

  const Conversion({
    required this.amount,
    required this.fromCurrency,
    required this.toCurrency,
    required this.result,
    required this.rate,
    required this.timestamp,
  });

  @override
  List<Object?> get props => [
        amount,
        fromCurrency,
        toCurrency,
        result,
        rate,
        timestamp,
      ];
}