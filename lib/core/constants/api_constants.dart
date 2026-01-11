/// Constantes liées à l'API et à la configuration
class ApiConstants {
  ApiConstants._();

  /// URL de base de l'API ExchangeRate-API (gratuite et fiable)
  static const String baseUrl = 'https://api.exchangerate-api.com/v4';
  
  /// Endpoint pour récupérer les taux de change les plus récents
  static const String latestEndpoint = '/latest';
  
  /// Timeout pour les requêtes réseau
  static const Duration timeout = Duration(seconds: 10);
  
  /// Clé pour le stockage local des taux de change
  static const String ratesStorageKey = 'exchange_rates';
  
  /// Clé pour le stockage de la date de dernière mise à jour
  static const String lastUpdateKey = 'last_update';
  
  /// Clé pour l'historique des conversions
  static const String historyStorageKey = 'conversion_history';
  
  /// Nombre maximum d'éléments dans l'historique
  static const int maxHistoryItems = 50;
}

/// Liste des devises supportées
class SupportedCurrencies {
  SupportedCurrencies._();
  
  static const List<String> currencies = [
    'EUR',
    'USD',
    'XAF',
    'XOF',
    'GBP',
    'JPY',
    'CHF',
    'CAD',
    'AUD',
    'CNY',
  ];
  
  static const Map<String, String> currencyNames = {
    'EUR': 'Euro',
    'USD': 'Dollar américain',
    'XAF': 'Franc CFA (BEAC)',
    'XOF': 'Franc CFA (BCEAO)',
    'GBP': 'Livre sterling',
    'JPY': 'Yen japonais',
    'CHF': 'Franc suisse',
    'CAD': 'Dollar canadien',
    'AUD': 'Dollar australien',
    'CNY': 'Yuan chinois',
  };
}