import '../../domain/entities/conversion.dart';

/// Modèle de données pour une conversion
class ConversionModel extends Conversion {
  const ConversionModel({
    required super.amount,
    required super.fromCurrency,
    required super.toCurrency,
    required super.result,
    required super.rate,
    required super.timestamp,
  });

  /// Crée un modèle depuis JSON
  factory ConversionModel.fromJson(Map<String, dynamic> json) {
    return ConversionModel(
      amount: (json['amount'] as num).toDouble(),
      fromCurrency: json['fromCurrency'] as String,
      toCurrency: json['toCurrency'] as String,
      result: (json['result'] as num).toDouble(),
      rate: (json['rate'] as num).toDouble(),
      timestamp: DateTime.parse(json['timestamp'] as String),
    );
  }

  /// Convertit le modèle en JSON
  Map<String, dynamic> toJson() {
    return {
      'amount': amount,
      'fromCurrency': fromCurrency,
      'toCurrency': toCurrency,
      'result': result,
      'rate': rate,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  /// Crée un modèle depuis une entité
  factory ConversionModel.fromEntity(Conversion entity) {
    return ConversionModel(
      amount: entity.amount,
      fromCurrency: entity.fromCurrency,
      toCurrency: entity.toCurrency,
      result: entity.result,
      rate: entity.rate,
      timestamp: entity.timestamp,
    );
  }
}