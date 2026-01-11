import '../../domain/entities/exchange_rate.dart';

/// Modèle de données pour les taux de change
class ExchangeRateModel extends ExchangeRate {
  const ExchangeRateModel({
    required super.baseCurrency,
    required super.rates,
    required super.lastUpdated,
  });

  /// Crée un modèle depuis JSON
  factory ExchangeRateModel.fromJson(Map<String, dynamic> json) {
    final ratesMap = <String, double>{};
    final rates = json['rates'] as Map<String, dynamic>;
    
    rates.forEach((key, value) {
      ratesMap[key] = (value as num).toDouble();
    });

    return ExchangeRateModel(
      baseCurrency: json['base'] as String,
      rates: ratesMap,
      lastUpdated: DateTime.now(),
    );
  }

  /// Convertit le modèle en JSON
  Map<String, dynamic> toJson() {
    return {
      'base': baseCurrency,
      'rates': rates,
      'lastUpdated': lastUpdated.toIso8601String(),
    };
  }

  /// Crée un modèle depuis une entité
  factory ExchangeRateModel.fromEntity(ExchangeRate entity) {
    return ExchangeRateModel(
      baseCurrency: entity.baseCurrency,
      rates: entity.rates,
      lastUpdated: entity.lastUpdated,
    );
  }
}