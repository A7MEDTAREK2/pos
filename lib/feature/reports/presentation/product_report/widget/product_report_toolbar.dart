// lib/feature/reports/product_report/presentation/widgets/product_report_toolbar.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../logic/product_report_cubit.dart';

class ProductReportToolbar extends StatelessWidget {
  const ProductReportToolbar({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: colorScheme.outlineVariant),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // ====== Search Field ======
          Expanded(
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                color: colorScheme.background,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: colorScheme.outlineVariant),
              ),
              child: TextField(
                textDirection: TextDirection.rtl,
                onChanged: (value) {
                  context.read<ProductReportCubit>().searchReport(value);
                },
                style: theme.textTheme.bodyMedium,
                decoration: InputDecoration(
                  hintText: 'ابحث باسم المنتج...',
                  hintStyle: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurface.withOpacity(0.5),
                  ),
                  prefixIcon: Icon(
                    Icons.search,
                    size: 18,
                    color: colorScheme.onSurface.withOpacity(0.5),
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14),
                ),
              ),
            ),
          ),

          const SizedBox(width: 12),

          // ====== PDF Button ======
          _buildToolButton(
            context,
            icon: Icons.picture_as_pdf,
            label: 'PDF',
            color: Colors.red,
            onPressed: () {},
          ),

          const SizedBox(width: 8),

          // ====== Excel Button ======
          _buildToolButton(
            context,
            icon: Icons.grid_on,
            label: 'Excel',
            color: Colors.green,
            onPressed: () {},
          ),

          const SizedBox(width: 8),

          // ====== Print Button ======
          _buildToolButton(
            context,
            icon: Icons.print,
            label: 'طباعة',
            color: colorScheme.primary,
            isPrimary: true,
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildToolButton(
      BuildContext context, {
        required IconData icon,
        required String label,
        required Color color,
        required VoidCallback onPressed,
        bool isPrimary = false,
      }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: isPrimary
          ? ElevatedButton.icon(
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
          backgroundColor: color,
          foregroundColor: colorScheme.onPrimary,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 0,
        ),
      )
          : OutlinedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 18, color: color),
        label: Text(
          label,
          style: theme.textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w500,
            color: color,
          ),
        ),
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          side: BorderSide(color: color.withOpacity(0.3)),
          elevation: 0,
        ),
      ),
    );
  }
}