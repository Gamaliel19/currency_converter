import 'package:flutter/material.dart';
import '../../core/constants/api_constants.dart';

/// Widget pour sélectionner une devise
class CurrencyDropdown extends StatelessWidget {
  final String value;
  final ValueChanged<String?> onChanged;
  final String label;

  const CurrencyDropdown({
    super.key,
    required this.value,
    required this.onChanged,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      initialValue: value,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: const Icon(Icons.money),
      ),
      items: SupportedCurrencies.currencies.map((currency) {
        final name = SupportedCurrencies.currencyNames[currency] ?? currency;
        return DropdownMenuItem(
          value: currency,
          child: Text('$currency - $name'),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }
}