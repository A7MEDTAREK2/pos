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
    return Padding(
      padding: const EdgeInsets.all(30),
      child: Column(
        children: [
          _buildSummaryCards(),
          const SizedBox(height: 5),
          const Divider(),
          _buildTotalRow(),
        ],
      ),
    );
  }

  Widget _buildSummaryCards() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 110,
          child: EditableSummaryCard(
            title: "الإجمالي",
            value: totals.subTotal,
            icon: Iconss.receipt,
            onTap: () {},
          ),
        ),
        const SizedBox(width: 10),
        SizedBox(
          width: 110,
          child: EditableSummaryCard(
            title: "الضريبة",
            value: totals.tax,
            icon: Iconss.percent,
            onTap: onTaxTap,
          ),
        ),
        const SizedBox(width: 10),
        if (isDelivery)
          SizedBox(
            width: 110,
            child: EditableSummaryCard(
              title: "التوصيل",
              value: totals.delivery,
              icon: Iconss.delivery,
              onTap: onDeliveryTap,
            ),
          ),
        if (isDelivery) const SizedBox(width: 10),
        SizedBox(
          width: 110,
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

  Widget _buildTotalRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "الإجمالي",
            style: TxtStyle.totalMedium,
          ),
          Text(
            "${totals.finalTotal.toStringAsFixed(2)} ج.م",
            style: TxtStyle.totalLarge.copyWith(
              color: Colorsmanegments.info,
            ),
          ),
        ],
      ),
    );
  }
}