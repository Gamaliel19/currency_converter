import 'package:equatable/equatable.dart';

/// Classe abstraite pour les échecs dans la couche domain
abstract class Failure extends Equatable {
  final String message;
  
  const Failure(this.message);
  
  @override
  List<Object> get props => [message];
}

/// Échec lié au serveur
class ServerFailure extends Failure {
  const ServerFailure([super.message = 'Erreur serveur']);
}

/// Échec lié au cache
class CacheFailure extends Failure {
  const CacheFailure([super.message = 'Erreur de cache']);
}

/// Échec lié au réseau
class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'Pas de connexion internet']);
}

/// Échec pour une conversion invalide
class InvalidConversionFailure extends Failure {
  const InvalidConversionFailure([super.message = 'Conversion invalide']);
}