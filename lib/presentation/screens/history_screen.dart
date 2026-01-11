import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/utils/currency_formatter.dart';
import '../providers/conversion_notifier.dart';
import '../providers/currency_providers.dart';

/// Écran d'historique des conversions
class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  Future<void> _clearHistory(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmer'),
        content: const Text(
          'Voulez-vous vraiment effacer tout l\'historique ?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Annuler'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Effacer'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final repository = ref.read(currencyRepositoryProvider);
      await repository.clearHistory();
      ref.read(conversionNotifierProvider.notifier).loadHistory();
      
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Historique effacé')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(conversionNotifierProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Historique'),
        actions: [
          if (state.history.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: () => _clearHistory(context, ref),
              tooltip: 'Effacer l\'historique',
            ),
        ],
      ),
      body: state.history.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.history,
                    size: 64,
                    color: Colors.blue.withValues(alpha: 0.3),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Aucune conversion effectuée',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: Colors.blue.withValues(alpha: 0.5),
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: state.history.length,
              itemBuilder: (context, index) {
                final conversion = state.history[index];
                
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 8.0,
                    vertical: 4.0,
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: theme.colorScheme.primaryContainer,
                      child: Icon(
                        Icons.currency_exchange,
                        color: theme.colorScheme.onPrimaryContainer,
                      ),
                    ),
                    title: Row(
                      children: [
                        Text(
                          '${CurrencyFormatter.formatAmount(conversion.amount)} ${conversion.fromCurrency}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: 8),
                        const Icon(Icons.arrow_forward, size: 16),
                        const SizedBox(width: 8),
                        Text(
                          '${CurrencyFormatter.formatAmount(conversion.result)} ${conversion.toCurrency}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text(
                          'Taux: ${CurrencyFormatter.formatAmount(conversion.rate, decimals: 4)}',
                          style: theme.textTheme.bodySmall,
                        ),
                        Text(
                          CurrencyFormatter.formatDate(conversion.timestamp),
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: Colors.blue.withValues(alpha: 0.6),
                          ),
                        ),
                      ],
                    ),
                    isThreeLine: true,
                  ),
                );
              },
            ),
    );
  }
}