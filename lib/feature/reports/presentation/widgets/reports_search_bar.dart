import 'package:flutter/material.dart';

import '../../../../core/widgets/date_filter.dart';

class ReportToolbar extends StatelessWidget {
  final String hintText;
  final ValueChanged<String> onSearch;
  final void Function(DateTime from, DateTime to)? onDateChanged;
  final VoidCallback? onPdf;
  final VoidCallback? onExcel;
  final VoidCallback? onPrint;

  const ReportToolbar({
    super.key,
    required this.hintText,
    required this.onSearch,
    this.onDateChanged,
    this.onPdf,
    this.onExcel,
    this.onPrint,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      children: [
        SizedBox(
          width: 320,
          child: TextField(
            onChanged: onSearch,
            style: theme.textTheme.bodyMedium,
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface.withOpacity(0.5),
              ),
              prefixIcon: Icon(
                Icons.search,
                color: colorScheme.onSurface.withOpacity(0.5),
              ),
              filled: true,
              fillColor: colorScheme.surface,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: colorScheme.outlineVariant,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: colorScheme.outlineVariant,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: colorScheme.primary,
                  width: 2,
                ),
              ),
            ),
          ),
        ),

        const Spacer(),

        OutlinedButton.icon(
          onPressed: onPdf,
          style: OutlinedButton.styleFrom(
            side: BorderSide(color: colorScheme.outlineVariant),
          ),
          icon: Icon(
            Icons.picture_as_pdf_outlined,
            color: colorScheme.onSurface.withOpacity(0.6),
          ),
          label: Text(
            "PDF",
            style: theme.textTheme.labelLarge?.copyWith(
              color: colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
        ),

        const SizedBox(width: 12),

        OutlinedButton.icon(
          onPressed: onExcel,
          style: OutlinedButton.styleFrom(
            side: BorderSide(color: colorScheme.outlineVariant),
          ),
          icon: Icon(
            Icons.table_chart_outlined,
            color: colorScheme.onSurface.withOpacity(0.6),
          ),
          label: Text(
            "Excel",
            style: theme.textTheme.labelLarge?.copyWith(
              color: colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
        ),

        const SizedBox(width: 12),

        ElevatedButton.icon(
          onPressed: onPrint,
          style: ElevatedButton.styleFrom(
            backgroundColor: colorScheme.primary,
            foregroundColor: colorScheme.onPrimary,
          ),
          icon: Icon(
            Icons.print_outlined,
            color: colorScheme.onPrimary,
          ),
          label: Text(
            "طباعة",
            style: theme.textTheme.labelLarge?.copyWith(
              color: colorScheme.onPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        const SizedBox(width: 16),

        DateFilter(
          isCompact: true,
          onDateChanged: onDateChanged,
        ),
      ],
    );
  }
}