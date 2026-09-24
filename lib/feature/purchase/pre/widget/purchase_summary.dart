import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../logic/purchase_cubit.dart';

class PurchaseSummary extends StatelessWidget {
  const PurchaseSummary({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<PurchaseCubit>();
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colors.outlineVariant,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'ملخص المشتريات',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 20),

          _SummaryRow(
            title: 'الإجمالي الفرعي',
            value: cubit.subtotal,
          ),

          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                child: Text(
                  'الخصم',
                  style: theme.textTheme.bodyMedium,
                ),
              ),
              SizedBox(
                width: 120,
                child: TextFormField(
                  initialValue: cubit.discount.toStringAsFixed(2),
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: const InputDecoration(
                    suffixText: 'ج.م',
                    isDense: true,
                  ),
                  onFieldSubmitted: (value) {
                    final discount =
                        double.tryParse(value) ?? 0;

                    cubit.setDiscount(discount);
                  },
                ),
              ),
            ],
          ),

          const Divider(height: 28),

          _SummaryRow(
            title: 'الإجمالي',
            value: cubit.total,
            isTotal: true,
          ),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String title;
  final double value;
  final bool isTotal;

  const _SummaryRow({
    required this.title,
    required this.value,
    this.isTotal = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight:
              isTotal ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
        Text(
          '${value.toStringAsFixed(2)} ج.م',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: isTotal ? colors.primary : null,
          ),
        ),
      ],
    );
  }
}