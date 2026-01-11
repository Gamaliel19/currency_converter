/// Exception levée lors d'erreurs serveur
class ServerException implements Exception {
  final String message;
  
  ServerException([this.message = 'Erreur serveur']);
  
  @override
  String toString() => 'ServerException: $message';
}

/// Exception levée lors d'erreurs de cache/stockage local
class CacheException implements Exception {
  final String message;
  
  CacheException([this.message = 'Erreur de cache']);
  
  @override
  String toString() => 'CacheException: $message';
}

/// Exception levée lors d'erreurs réseau
class NetworkException implements Exception {
  final String message;
  
  NetworkException([this.message = 'Pas de connexion internet']);
  
  @override
  String toString() => 'NetworkException: $message';
}