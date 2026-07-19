import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../logic/dash_cubit.dart';
import '../../logic/dash_state.dart';
import 'dashboard_card.dart';
import 'section_title.dart';

class RecentSalesCard extends StatelessWidget {
  const RecentSalesCard({super.key});

  @override
  Widget build(BuildContext context) {
    return DashboardCard(
      child: BlocBuilder<DashboardCubit, DashboardState>(
        builder: (context, state) {
          if (state is DashboardLoading) {
            return const SizedBox(
              height: 250,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }

          if (state is DashboardError) {
            return SizedBox(
              height: 250,
              child: Center(
                child: Text(state.message),
              ),
            );
          }

          if (state is! DashboardSuccess) {
            return const SizedBox();
          }

          final sales = state.dashboard.recentSales;

          if (sales.isEmpty) {
            return const SizedBox(
              height: 250,
              child: Center(
                child: Text("لا توجد فواتير"),
              ),
            );
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SectionTitle(title: 'آخر الفواتير'),
              const SizedBox(height: 12),

              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columnSpacing: 24,
                  headingRowColor: WidgetStateProperty.all(
                    const Color(0xFFF8FAFC),
                  ),
                  headingTextStyle: GoogleFonts.cairo(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF6B7280),
                  ),
                  dataTextStyle: GoogleFonts.cairo(
                    fontSize: 13,
                    color: const Color(0xFF111827),
                  ),
                  columns: const [
                    DataColumn(label: Text('رقم الفاتورة')),
                    DataColumn(label: Text('العميل')),
                    DataColumn(label: Text('الإجمالي')),
                    DataColumn(label: Text('طريقة الدفع')),
                  ],
                  rows: sales.map((sale) {
                    return DataRow(
                      cells: [
                        DataCell(
                          Text(
                            '#${sale.orderNumber}',
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        DataCell(
                          Text(sale.customerName),
                        ),
                        DataCell(
                          Text(
                            '${sale.total.toStringAsFixed(2)} ج.م',
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        DataCell(
                          Text(sale.paymentMethod),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}