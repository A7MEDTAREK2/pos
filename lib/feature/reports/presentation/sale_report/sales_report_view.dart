import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:home/feature/reports/presentation/sale_report/sales_report_table.dart';


class SalesReportView extends StatelessWidget {
  const SalesReportView({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "تقرير المبيعات",
            style: GoogleFonts.cairo(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            "عرض جميع فواتير المبيعات والإحصائيات",
            style: GoogleFonts.cairo(
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 24),
          const SizedBox(height: 24),

          const SalesReportTable(),
        ],
      ),
    );
  }
}