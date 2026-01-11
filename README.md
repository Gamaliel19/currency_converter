# Convertisseur de Devises - Flutter Clean Architecture

Application mobile Flutter professionnelle de conversion de devises avec architecture Clean Architecture, gestion d'état Riverpod, et support hors ligne.

## 📋 Fonctionnalités

- ✅ Conversion de devises en temps réel (EUR, USD, XAF, XOF, GBP, JPY, CHF, CAD, AUD, CNY)
- ✅ Récupération automatique des taux de change via API publique
- ✅ Mode hors ligne avec cache local
- ✅ Historique des conversions (max 50 entrées)
- ✅ Interface Material Design 3
- ✅ Pull-to-refresh
- ✅ Gestion d'erreurs complète
- ✅ Architecture Clean Architecture
- ✅ Gestion d'état avec Riverpod

## 🏗️ Architecture

Le projet suit strictement les principes de **Clean Architecture** avec trois couches distinctes :

```
lib/
├── core/              # Éléments partagés (constantes, utilitaires, erreurs)
├── data/              # Couche de données (sources, modèles, repositories)
├── domain/            # Couche métier (entités, use cases, contrats)
└── presentation/      # Couche présentation (UI, providers, widgets)
```

### Couches

**Domain Layer** (indépendante)
- Entités métier pures
- Contrats de repositories
- Use cases contenant la logique métier

**Data Layer**
- Implémentation des repositories
- Sources de données (remote & local)
- Modèles de données avec sérialisation

**Presentation Layer**
- Widgets Flutter
- Providers Riverpod
- State management

## 🚀 Installation

### Prérequis

- Flutter SDK 3.0.0 ou supérieur
- Dart 3.0.0 ou supérieur

### Étapes d'installation

1. **Cloner le projet**
```bash
git clone https://github.com/Gamaliel19/currency_converter
cd currency_converter
```

2. **Installer les dépendances**
```bash
flutter pub get
```

3. **Vérifier l'installation**
```bash
flutter doctor
```

4. **Lancer l'application**

Pour Android :
```bash
flutter run
```

Pour iOS :
```bash
flutter run -d ios
```

Pour web :
```bash
flutter run -d chrome
```

## 📦 Dépendances principales

| Package | Version | Usage |
|---------|---------|-------|
| flutter_riverpod | ^2.4.9 | Gestion d'état |
| http | ^1.1.2 | Requêtes HTTP |
| shared_preferences | ^2.2.2 | Stockage local |
| dartz | ^0.10.1 | Programmation fonctionnelle |
| equatable | ^2.0.5 | Comparaison d'objets |
| intl | ^0.19.0 | Formatage de dates/nombres |
| internet_connection_checker | ^1.0.0+1 | Vérification connectivité |

## 🔌 API utilisée

L'application utilise **ExchangeRate-API** (gratuite, sans clé API requise) :
- URL : `https://api.exchangerate-api.com/v4/latest/{currency}`
- Limitations : Aucune pour usage normal
- Documentation : https://www.exchangerate-api.com/docs/overview

## 🎯 Points clés de l'implémentation

### Gestion d'état avec Riverpod

```dart
// Provider pour le state notifier
final conversionNotifierProvider = 
    StateNotifierProvider<ConversionNotifier, ConversionState>((ref) {
  return ConversionNotifier(
    getExchangeRates: ref.watch(getExchangeRatesProvider),
    convertCurrency: ref.watch(convertCurrencyProvider),
    getConversionHistory: ref.watch(getConversionHistoryProvider),
  );
});
```

### Gestion des erreurs

Utilisation du pattern `Either<Failure, Success>` de Dartz :

```dart
Future<Either<Failure, ExchangeRate>> getExchangeRates();
```

### Mode hors ligne

- Cache automatique des taux après chaque récupération réussie
- Fallback sur le cache en cas d'erreur réseau
- Indicateur visuel du mode hors ligne

### Stockage local

- Taux de change : `SharedPreferences` (JSON)
- Historique : `SharedPreferences` (liste JSON, max 50 entrées)
- Horodatage de dernière mise à jour

## 🧪 Tests

Pour exécuter les tests unitaires :

```bash
flutter test
```

Pour les tests d'intégration :

```bash
flutter test integration_test
```

## 📱 Captures d'écran

L'application comprend deux écrans principaux :

1. **Écran principal** : Saisie, conversion, affichage du résultat
2. **Écran d'historique** : Liste des conversions précédentes

## 🔧 Configuration

### Modifier les devises supportées

Éditer `lib/core/constants/api_constants.dart` :

```dart
static const List<String> currencies = [
  'EUR', 'USD', 'XAF', 'XOF', // Ajouter/retirer ici
];
```

### Modifier la taille de l'historique

```dart
static const int maxHistoryItems = 50; // Modifier cette valeur
```

## 📝 Bonnes pratiques appliquées

✅ Séparation stricte des responsabilités (Clean Architecture)
✅ Injection de dépendances via Riverpod
✅ Null safety activée
✅ Gestion d'erreurs exhaustive
✅ Code commenté et documenté
✅ Nommage cohérent et expressif
✅ Widgets réutilisables
✅ Formatage uniforme (dart format)
✅ Validation des entrées utilisateur
✅ Gestion du cycle de vie des controllers

## 🐛 Dépannage

### L'application ne compile pas

```bash
flutter clean
flutter pub get
flutter run
```

### Erreur de connectivité

Vérifier les permissions réseau dans :
- Android : `android/app/src/main/AndroidManifest.xml`
- iOS : `ios/Runner/Info.plist`

### Cache corrompu

Supprimer les données de l'application depuis les paramètres du téléphone.

## 🚀 Évolutions futures possibles

- [ ] Support de plus de devises
- [ ] Graphiques d'évolution des taux
- [ ] Notifications de seuils de taux
- [ ] Export de l'historique (CSV, PDF)
- [ ] Thème sombre/clair
- [ ] Multi-langue (i18n)
- [ ] Tests unitaires complets
- [ ] CI/CD

## 📄 Licence

Ce projet est à usage éducatif et professionnel.

## 👨‍💻 Auteur

Ing. YAGALI NAFOU GAMALIEL

---

**Note** : Ce projet est conçu pour être audité, maintenu et utilisé comme référence pédagogique. Chaque fichier respecte les standards professionnels du développement Flutter.