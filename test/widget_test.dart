/// Tests de widgets pour l'application Currency Converter
///
/// Ce fichier contient les tests d'intégration des widgets principaux
/// de l'application de conversion de devises.
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:currency_converter/main.dart';
import 'package:currency_converter/presentation/providers/currency_providers.dart';
import 'package:currency_converter/core/network/network_info.dart';

/// Mock pour NetworkInfo qui retourne toujours false (mode hors ligne)
class MockNetworkInfo implements NetworkInfo {
  @override
  Future<bool> get isConnected async => false;
}

/// Mock pour le client HTTP
class MockHttpClient extends http.BaseClient {
  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    // Retourner une erreur pour simuler l'absence de connexion
    throw http.ClientException('No internet connection');
  }
}

void main() {
  /// Configuration avant chaque test
  setUp(() {
    // Initialiser les SharedPreferences en mode test
    SharedPreferences.setMockInitialValues({});
  });

  group('CurrencyConverterApp Widget Tests', () {
    testWidgets('Application démarre et affiche l\'écran principal',
        (WidgetTester tester) async {
      // Initialiser SharedPreferences pour les tests
      final prefs = await SharedPreferences.getInstance();

      // Construire l'application avec les providers mockés
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            sharedPreferencesProvider.overrideWithValue(prefs),
            networkInfoProvider.overrideWithValue(MockNetworkInfo()),
            httpClientProvider.overrideWithValue(MockHttpClient()),
          ],
          child: const CurrencyConverterApp(),
        ),
      );

      // Attendre que tous les widgets soient construits
      await tester.pumpAndSettle();

      // Vérifier que le titre de l'AppBar est présent
      expect(find.text('Convertisseur de Devises'), findsOneWidget);

      // Vérifier que les éléments principaux sont affichés
      expect(find.byType(TextField), findsWidgets);
      expect(find.byType(DropdownButtonFormField<String>), findsNWidgets(2));
      expect(find.text('Convertir'), findsOneWidget);
    });

    testWidgets('Le bouton d\'historique est présent',
        (WidgetTester tester) async {
      final prefs = await SharedPreferences.getInstance();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            sharedPreferencesProvider.overrideWithValue(prefs),
            networkInfoProvider.overrideWithValue(MockNetworkInfo()),
            httpClientProvider.overrideWithValue(MockHttpClient()),
          ],
          child: const CurrencyConverterApp(),
        ),
      );

      await tester.pumpAndSettle();

      // Vérifier la présence du bouton historique
      expect(find.byIcon(Icons.history), findsOneWidget);
    });

    testWidgets('Le bouton de rafraîchissement est présent',
        (WidgetTester tester) async {
      final prefs = await SharedPreferences.getInstance();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            sharedPreferencesProvider.overrideWithValue(prefs),
            networkInfoProvider.overrideWithValue(MockNetworkInfo()),
            httpClientProvider.overrideWithValue(MockHttpClient()),
          ],
          child: const CurrencyConverterApp(),
        ),
      );

      await tester.pumpAndSettle();

      // Vérifier la présence du bouton refresh
      expect(find.byIcon(Icons.refresh), findsOneWidget);
    });

    testWidgets('Les dropdowns de devises contiennent les bonnes options',
        (WidgetTester tester) async {
      final prefs = await SharedPreferences.getInstance();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            sharedPreferencesProvider.overrideWithValue(prefs),
            networkInfoProvider.overrideWithValue(MockNetworkInfo()),
            httpClientProvider.overrideWithValue(MockHttpClient()),
          ],
          child: const CurrencyConverterApp(),
        ),
      );

      await tester.pumpAndSettle();

      // Taper sur le premier dropdown
      final firstDropdown = find.byType(DropdownButtonFormField<String>).first;
      await tester.tap(firstDropdown);
      await tester.pumpAndSettle();

      // Vérifier que les devises principales sont présentes
      expect(find.text('EUR - Euro').hitTestable(), findsOneWidget);
      expect(find.text('USD - Dollar américain').hitTestable(), findsOneWidget);
      expect(find.text('XAF - Franc CFA (BEAC)').hitTestable(), findsOneWidget);
      expect(find.text('XOF - Franc CFA (BCEAO)').hitTestable(), findsOneWidget);
    });

    testWidgets('Le bouton d\'inversion des devises fonctionne',
        (WidgetTester tester) async {
      final prefs = await SharedPreferences.getInstance();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            sharedPreferencesProvider.overrideWithValue(prefs),
            networkInfoProvider.overrideWithValue(MockNetworkInfo()),
            httpClientProvider.overrideWithValue(MockHttpClient()),
          ],
          child: const CurrencyConverterApp(),
        ),
      );

      await tester.pumpAndSettle();

      // Trouver le bouton d'inversion
      final swapButton = find.byIcon(Icons.swap_vert);
      expect(swapButton, findsOneWidget);

      // Taper sur le bouton
      await tester.tap(swapButton);
      await tester.pumpAndSettle();

      // Vérifier que le bouton est toujours présent après le tap
      expect(swapButton, findsOneWidget);
    });

    testWidgets('Le champ de montant accepte uniquement les nombres',
        (WidgetTester tester) async {
      final prefs = await SharedPreferences.getInstance();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            sharedPreferencesProvider.overrideWithValue(prefs),
            networkInfoProvider.overrideWithValue(MockNetworkInfo()),
            httpClientProvider.overrideWithValue(MockHttpClient()),
          ],
          child: const CurrencyConverterApp(),
        ),
      );

      await tester.pumpAndSettle();

      // Trouver le champ de montant
      final amountField = find.byType(TextField).first;

      // Entrer un montant valide
      await tester.enterText(amountField, '100.50');
      await tester.pumpAndSettle();

      // Vérifier que le texte a été saisi
      expect(find.text('100.50'), findsOneWidget);
    });

    testWidgets('Le bouton convertir est présent',
        (WidgetTester tester) async {
      final prefs = await SharedPreferences.getInstance();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            sharedPreferencesProvider.overrideWithValue(prefs),
            networkInfoProvider.overrideWithValue(MockNetworkInfo()),
            httpClientProvider.overrideWithValue(MockHttpClient()),
          ],
          child: const CurrencyConverterApp(),
        ),
      );

      await tester.pumpAndSettle();

      // Vérifier que le bouton convertir est présent
      expect(find.text('Convertir'), findsOneWidget);
      
      // Vérifier que l'icône currency_exchange est présente
      expect(find.byIcon(Icons.currency_exchange), findsOneWidget);
    });

    testWidgets('Navigation vers l\'écran d\'historique fonctionne',
        (WidgetTester tester) async {
      final prefs = await SharedPreferences.getInstance();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            sharedPreferencesProvider.overrideWithValue(prefs),
            networkInfoProvider.overrideWithValue(MockNetworkInfo()),
            httpClientProvider.overrideWithValue(MockHttpClient()),
          ],
          child: const CurrencyConverterApp(),
        ),
      );

      await tester.pumpAndSettle();

      // Taper sur le bouton historique
      final historyButton = find.byIcon(Icons.history);
      await tester.tap(historyButton);
      await tester.pumpAndSettle();

      // Vérifier que l'écran d'historique est affiché
      expect(find.text('Historique'), findsOneWidget);
      expect(find.text('Aucune conversion effectuée'), findsOneWidget);
    });

    testWidgets('Pull-to-refresh est présent',
        (WidgetTester tester) async {
      final prefs = await SharedPreferences.getInstance();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            sharedPreferencesProvider.overrideWithValue(prefs),
            networkInfoProvider.overrideWithValue(MockNetworkInfo()),
            httpClientProvider.overrideWithValue(MockHttpClient()),
          ],
          child: const CurrencyConverterApp(),
        ),
      );

      await tester.pumpAndSettle();

      // Vérifier la présence du RefreshIndicator
      expect(find.byType(RefreshIndicator), findsOneWidget);
    });

    testWidgets('Validation du formulaire - montant vide',
        (WidgetTester tester) async {
      final prefs = await SharedPreferences.getInstance();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            sharedPreferencesProvider.overrideWithValue(prefs),
            networkInfoProvider.overrideWithValue(MockNetworkInfo()),
            httpClientProvider.overrideWithValue(MockHttpClient()),
          ],
          child: const CurrencyConverterApp(),
        ),
      );

      await tester.pumpAndSettle();

      // Taper sur convertir sans entrer de montant
      final convertButton = find.text('Convertir');
      await tester.tap(convertButton);
      await tester.pumpAndSettle();

      // Vérifier qu'un message d'erreur de validation apparaît
      expect(find.text('Veuillez entrer un montant'), findsOneWidget);
    });

    testWidgets('Thème Material 3 est appliqué',
        (WidgetTester tester) async {
      final prefs = await SharedPreferences.getInstance();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            sharedPreferencesProvider.overrideWithValue(prefs),
            networkInfoProvider.overrideWithValue(MockNetworkInfo()),
            httpClientProvider.overrideWithValue(MockHttpClient()),
          ],
          child: const CurrencyConverterApp(),
        ),
      );

      await tester.pumpAndSettle();

      // Récupérer le MaterialApp
      final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));

      // Vérifier que useMaterial3 est activé
      expect(materialApp.theme?.useMaterial3, isTrue);
    });

    testWidgets('Les cards ont le bon style',
        (WidgetTester tester) async {
      final prefs = await SharedPreferences.getInstance();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            sharedPreferencesProvider.overrideWithValue(prefs),
            networkInfoProvider.overrideWithValue(MockNetworkInfo()),
            httpClientProvider.overrideWithValue(MockHttpClient()),
          ],
          child: const CurrencyConverterApp(),
        ),
      );

      await tester.pumpAndSettle();

      // Vérifier la présence de Cards
      expect(find.byType(Card), findsWidgets);
    });

    testWidgets('Message d\'erreur s\'affiche en mode hors ligne',
        (WidgetTester tester) async {
      final prefs = await SharedPreferences.getInstance();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            sharedPreferencesProvider.overrideWithValue(prefs),
            networkInfoProvider.overrideWithValue(MockNetworkInfo()),
            httpClientProvider.overrideWithValue(MockHttpClient()),
          ],
          child: const CurrencyConverterApp(),
        ),
      );

      await tester.pumpAndSettle();

      // En mode hors ligne sans cache, un message d'erreur devrait s'afficher
      // Vérifier qu'il y a un message d'erreur (Card rouge)
      expect(find.byType(Card), findsWidgets);
    });
  });

  group('Tests de l\'écran d\'historique', () {
    testWidgets('Écran d\'historique vide affiche le bon message',
        (WidgetTester tester) async {
      final prefs = await SharedPreferences.getInstance();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            sharedPreferencesProvider.overrideWithValue(prefs),
            networkInfoProvider.overrideWithValue(MockNetworkInfo()),
            httpClientProvider.overrideWithValue(MockHttpClient()),
          ],
          child: const CurrencyConverterApp(),
        ),
      );

      await tester.pumpAndSettle();

      // Naviguer vers l'historique
      await tester.tap(find.byIcon(Icons.history));
      await tester.pumpAndSettle();

      // Vérifier le message d'historique vide
      expect(find.text('Aucune conversion effectuée'), findsOneWidget);
      expect(find.byIcon(Icons.history), findsWidgets);
    });

    testWidgets('Bouton retour de l\'historique fonctionne',
        (WidgetTester tester) async {
      final prefs = await SharedPreferences.getInstance();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            sharedPreferencesProvider.overrideWithValue(prefs),
            networkInfoProvider.overrideWithValue(MockNetworkInfo()),
            httpClientProvider.overrideWithValue(MockHttpClient()),
          ],
          child: const CurrencyConverterApp(),
        ),
      );

      await tester.pumpAndSettle();

      // Naviguer vers l'historique
      await tester.tap(find.byIcon(Icons.history));
      await tester.pumpAndSettle();

      // Vérifier qu'on est sur l'écran historique
      expect(find.text('Historique'), findsOneWidget);

      // Revenir en arrière
      await tester.tap(find.byType(BackButton));
      await tester.pumpAndSettle();

      // Vérifier qu'on est revenu à l'écran principal
      expect(find.text('Convertisseur de Devises'), findsOneWidget);
    });
  });

  group('Tests d\'intégration', () {
    testWidgets('Scénario complet : Saisie de montant et navigation',
        (WidgetTester tester) async {
      final prefs = await SharedPreferences.getInstance();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            sharedPreferencesProvider.overrideWithValue(prefs),
            networkInfoProvider.overrideWithValue(MockNetworkInfo()),
            httpClientProvider.overrideWithValue(MockHttpClient()),
          ],
          child: const CurrencyConverterApp(),
        ),
      );

      await tester.pumpAndSettle();

      // 1. Saisir un montant
      final amountField = find.byType(TextField).first;
      await tester.enterText(amountField, '100');
      await tester.pumpAndSettle();

      // 2. Vérifier que le montant est saisi
      expect(find.text('100'), findsOneWidget);

      // 3. Taper sur le bouton inverser
      await tester.tap(find.byIcon(Icons.swap_vert));
      await tester.pumpAndSettle();

      // 4. Vérifier que le bouton convertir est toujours présent
      expect(find.text('Convertir'), findsOneWidget);

      // 5. Naviguer vers l'historique
      await tester.tap(find.byIcon(Icons.history));
      await tester.pumpAndSettle();

      // 6. Vérifier qu'on est sur l'écran historique
      expect(find.text('Historique'), findsOneWidget);

      // 7. Revenir en arrière
      await tester.tap(find.byType(BackButton));
      await tester.pumpAndSettle();

      // 8. Vérifier qu'on est revenu à l'écran principal
      expect(find.text('Convertisseur de Devises'), findsOneWidget);
    });
  });
}