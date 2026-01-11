import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/utils/currency_formatter.dart';
import '../providers/conversion_notifier.dart';
import '../widgets/amount_input.dart';
import '../widgets/conversion_result.dart';
import '../widgets/currency_dropdown.dart';
import 'history_screen.dart';

/// Écran principal de conversion
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  String _fromCurrency = 'EUR';
  String _toCurrency = 'USD';

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  void _swapCurrencies() {
    setState(() {
      final temp = _fromCurrency;
      _fromCurrency = _toCurrency;
      _toCurrency = temp;
    });
    ref.read(conversionNotifierProvider.notifier).clearConversion();
  }

  Future<void> _performConversion() async {
    if (_formKey.currentState!.validate()) {
      final amount = CurrencyFormatter.parseAmount(_amountController.text);
      if (amount != null) {
        await ref.read(conversionNotifierProvider.notifier).performConversion(
              amount: amount,
              from: _fromCurrency,
              to: _toCurrency,
            );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(conversionNotifierProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Convertisseur de Devises'),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const HistoryScreen(),
                ),
              );
            },
            tooltip: 'Historique',
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.read(conversionNotifierProvider.notifier).loadExchangeRates();
            },
            tooltip: 'Actualiser les taux',
          ),
        ],
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            await ref.read(conversionNotifierProvider.notifier).loadExchangeRates();
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (state.isOffline)
                    Card(
                      color: theme.colorScheme.errorContainer,
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          children: [
                            Icon(
                              Icons.wifi_off,
                              color: theme.colorScheme.onErrorContainer,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'Mode hors ligne - Derniers taux sauvegardés',
                                style: TextStyle(
                                  color: theme.colorScheme.onErrorContainer,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  const SizedBox(height: 16),
                  if (state.exchangeRate != null)
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Text(
                          'Dernière mise à jour : ${CurrencyFormatter.formatDate(state.exchangeRate!.lastUpdated)}',
                          style: theme.textTheme.bodySmall,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  const SizedBox(height: 24),
                  AmountInput(
                    controller: _amountController,
                    label: 'Montant',
                    onChanged: (_) {
                      ref.read(conversionNotifierProvider.notifier).clearConversion();
                    },
                  ),
                  const SizedBox(height: 16),
                  CurrencyDropdown(
                    value: _fromCurrency,
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _fromCurrency = value;
                        });
                        ref.read(conversionNotifierProvider.notifier).clearConversion();
                      }
                    },
                    label: 'De',
                  ),
                  const SizedBox(height: 8),
                  Center(
                    child: IconButton.filled(
                      icon: const Icon(Icons.swap_vert),
                      onPressed: _swapCurrencies,
                      tooltip: 'Inverser les devises',
                    ),
                  ),
                  const SizedBox(height: 8),
                  CurrencyDropdown(
                    value: _toCurrency,
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _toCurrency = value;
                        });
                        ref.read(conversionNotifierProvider.notifier).clearConversion();
                      }
                    },
                    label: 'Vers',
                  ),
                  const SizedBox(height: 24),
                  FilledButton.icon(
                    onPressed: state.isLoading ? null : _performConversion,
                    icon: state.isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(Icons.currency_exchange),
                    label: Text(
                      state.isLoading ? 'Conversion...' : 'Convertir',
                    ),
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                  if (state.error != null) ...[
                    const SizedBox(height: 16),
                    Card(
                      color: theme.colorScheme.errorContainer,
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          children: [
                            Icon(
                              Icons.error_outline,
                              color: theme.colorScheme.onErrorContainer,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                state.error!,
                                style: TextStyle(
                                  color: theme.colorScheme.onErrorContainer,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                  if (state.currentConversion != null) ...[
                    const SizedBox(height: 24),
                    ConversionResult(conversion: state.currentConversion!),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}