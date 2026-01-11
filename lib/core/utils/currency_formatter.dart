import 'package:intl/intl.dart';

/// Utilitaire pour formater les montants de devises
class CurrencyFormatter {
  CurrencyFormatter._();

  /// Formate un montant avec séparateurs de milliers
  static String formatAmount(double amount, {int decimals = 2}) {
    final formatter = NumberFormat.currency(
      symbol: '',
      decimalDigits: decimals,
    );
    return formatter.format(amount).trim();
  }

  /// Parse une chaîne en double, retourne null si invalide
  static double? parseAmount(String text) {
    if (text.isEmpty) return null;
    
    // Remplace les virgules par des points
    final normalized = text.replaceAll(',', '.');
    
    try {
      return double.parse(normalized);
    } catch (e) {
      return null;
    }
  }

  /// Formate une date pour l'affichage
  static String formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy HH:mm').format(date);
  }
}