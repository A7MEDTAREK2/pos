// lib/feature/sales/presentation/widgets/invoice_details/sale_actions_bar.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../data/model/sale_detail_report.dart';

class SaleActionsBar extends StatelessWidget {
  final SaleDetailsModel sale;

  const SaleActionsBar({
    super.key,
    required this.sale,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.vertical(
          bottom: Radius.circular(20),
        ),
        border: Border(
          top: BorderSide(color: theme.dividerColor),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // ====== Print Button ======
          _buildPrimaryButton(
            context,
            onPressed: () {},
            icon: Icons.print_outlined,
            label: 'طباعة الفاتورة',
          ),

          const SizedBox(width: 12),

          // ====== Export PDF Button ======
          _buildSecondaryButton(
            context,
            onPressed: () {},
            icon: Icons.picture_as_pdf_outlined,
            label: 'تصدير PDF',
          ),

          const SizedBox(width: 12),

          // ====== Close Button ======
          _buildOutlinedButton(
            context,
            onPressed: () => Navigator.pop(context),
            label: 'إغلاق',
          ),
        ],
      ),
    );
  }

  Widget _buildPrimaryButton(
      BuildContext context, {
        required VoidCallback onPressed,
        required IconData icon,
        required String label,
      }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 18, color: colorScheme.onPrimary),
        label: Text(
          label,
          style: theme.textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w600,
            color: colorScheme.onPrimary,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 2,
        ),
      ),
    );
  }

  Widget _buildSecondaryButton(
      BuildContext context, {
        required VoidCallback onPressed,
        required IconData icon,
        required String label,
      }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 18, color: colorScheme.onSurface),
        label: Text(
          label,
          style: theme.textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.background,
          foregroundColor: colorScheme.onSurface,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          side: BorderSide(color: colorScheme.outlineVariant),
          elevation: 0,
        ),
      ),
    );
  }

  Widget _buildOutlinedButton(
      BuildContext context, {
        required VoidCallback onPressed,
        required String label,
      }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: OutlinedButton(
        onPressed: onPressed,
        child: Text(
          label,
          style: theme.textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w500,
            color: colorScheme.onSurface.withOpacity(0.6),
          ),
        ),
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          side: BorderSide(color: colorScheme.outlineVariant),
        ),
      ),
    );
  }
}