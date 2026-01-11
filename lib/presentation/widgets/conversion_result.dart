import 'package:flutter/material.dart';
import '../../domain/entities/conversion.dart';
import '../../core/utils/currency_formatter.dart';

/// Widget pour afficher le résultat d'une conversion
class ConversionResult extends StatelessWidget {
  final Conversion conversion;

  const ConversionResult({
    super.key,
    required this.conversion,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Card(
      color: theme.colorScheme.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Text(
              'Résultat',
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.onPrimaryContainer,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  CurrencyFormatter.formatAmount(conversion.result),
                  style: theme.textTheme.displaySmall?.copyWith(
                    color: theme.colorScheme.onPrimaryContainer,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  conversion.toCurrency,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    color: theme.colorScheme.onPrimaryContainer,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              '1 ${conversion.fromCurrency} = ${CurrencyFormatter.formatAmount(conversion.rate, decimals: 4)} ${conversion.toCurrency}',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Colors.blue.withValues(alpha: 0.8),
              ),
            ),
          ],
        ),
      ),
    );
  }
}