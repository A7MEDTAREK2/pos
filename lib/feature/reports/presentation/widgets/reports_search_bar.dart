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
    return Row(
      children: [
        SizedBox(
          width: 320,
          child: TextField(
            onChanged: onSearch,
            decoration: InputDecoration(
              hintText: hintText,
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: Color(0xFFE5E7EB),
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: Color(0xFFE5E7EB),
                ),
              ),
            ),
          ),
        ),

        const Spacer(),

        OutlinedButton.icon(
          onPressed: onPdf,
          icon: const Icon(Icons.picture_as_pdf_outlined),
          label: const Text("PDF"),
        ),

        const SizedBox(width: 12),

        OutlinedButton.icon(
          onPressed: onExcel,
          icon: const Icon(Icons.table_chart_outlined),
          label: const Text("Excel"),
        ),

        const SizedBox(width: 12),

        ElevatedButton.icon(
          onPressed: onPrint,
          icon: const Icon(Icons.print_outlined),
          label: const Text("طباعة"),
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