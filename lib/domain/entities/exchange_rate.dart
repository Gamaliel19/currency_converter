import 'package:equatable/equatable.dart';

/// Entité représentant les taux de change
class ExchangeRate extends Equatable {
  final String baseCurrency;
  final Map<String, double> rates;
  final DateTime lastUpdated;

  const ExchangeRate({
    required this.baseCurrency,
    required this.rates,
    required this.lastUpdated,
  });

  /// Obtient le taux de change pour une devise donnée
  double? getRate(String currency) {
    return rates[currency];
  }

  /// Convertit un montant d'une devise à une autre
  double? convert(double amount, String from, String to) {
    if (from == to) return amount;
    
    final fromRate = rates[from];
    final toRate = rates[to];
    
    if (fromRate == null || toRate == null) return null;
    
    // Conversion via la devise de base
    final amountInBase = amount / fromRate;
    return amountInBase * toRate;
  }

  @override
  List<Object?> get props => [baseCurrency, rates, lastUpdated];
}