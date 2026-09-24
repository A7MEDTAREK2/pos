// lib/feature/cashier/presentation/widget/pos_financial_summary.dart

import 'package:flutter/material.dart';
import '../../../../core/theming/colors manegments.dart';
import '../../../../core/theming/icons.dart';
import '../../../../core/theming/txt_style.dart';
import '../helper/pos_helpers.dart';
import 'editable_summary_card.dart';

class PosFinancialSummary extends StatelessWidget {
  final PosTotals totals;
  final bool isDelivery;
  final VoidCallback onTaxTap;
  final VoidCallback onDeliveryTap;
  final VoidCallback onDiscountTap;

  const PosFinancialSummary({
    super.key,
    required this.totals,
    required this.isDelivery,
    required this.onTaxTap,
    required this.onDeliveryTap,
    required this.onDiscountTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // زيادة الحشو الخارجي قليلاً لإعطاء راحة بصرية للكروت
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 1. صف بطاقات الملخص المالي (موزعة بشكل متساوٍ ومرن)
          _buildSummaryCards(context),
          const SizedBox(height: 8),
          Divider(color: theme.dividerColor, height: 12),
          // 2. صف الإجمالي النهائي بخطوط أكبر وأكثر وضوحاً
          _buildTotalRow(context),
        ],
      ),
    );
  }

  // بناء بطاقات الملخص بحيث تكبر وتتوزع بالتساوي (4 كروت دائماً)
  Widget _buildSummaryCards(BuildContext context) {
    return Row(
      children: [
        // 1. بطاقة الإجمالي الفرعي
        Expanded(
          child: EditableSummaryCard(
            title: "الإجمالي",
            value: totals.subTotal,
            icon: Iconss.receipt,
            onTap: () {},
          ),
        ),
        const SizedBox(width: 6),

        // 2. بطاقة الضريبة
        Expanded(
          child: EditableSummaryCard(
            title: "الضريبة",
            value: totals.tax,
            icon: Iconss.percent,
            onTap: onTaxTap,
          ),
        ),
        const SizedBox(width: 6),

        // 3. بطاقة التوصيل (تظهر ككارت رابع عند الدليفري، أو تترك مساحة مرنة لتثبيت التخطيط)
        Expanded(
          child: isDelivery
              ? EditableSummaryCard(
            title: "التوصيل",
            value: totals.delivery,
            icon: Iconss.delivery,
            onTap: onDeliveryTap,
          )
              : const SizedBox(), // لحفاظ التوازن لو مفيش دليفري
        ),
        if (isDelivery) const SizedBox(width: 6),

        // 4. بطاقة الخصم
        Expanded(
          child: EditableSummaryCard(
            title: "الخصم",
            value: totals.discount,
            icon: Iconss.discount,
            onTap: onDiscountTap,
          ),
        ),
      ],
    );
  }

  // بناء صف الإجمالي النهائي بخطوط ومقاسات أكبر بارزة
  Widget _buildTotalRow(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "الإجمالي النهائي",
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 16, // تكبير حجم الخط لعنوان الإجمالي
            ),
          ),
          Text(
            "${totals.finalTotal.toStringAsFixed(2)} ج.م",
            style: theme.textTheme.titleLarge?.copyWith(
              color: colorScheme.primary,
              fontWeight: FontWeight.bold,
              fontSize: 20, // تكبير وتبريز رقم الإجمالي النهائي بوضوح تام
            ),
          ),
        ],
      ),
    );
  }
}