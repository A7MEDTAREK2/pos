// lib/feature/reports/stock_report/presentation/widgets/stock_report_table.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:home/feature/reports/presentation/Stock%20Report/widget/stock.dart' show StockTableRow;
import 'package:home/feature/reports/presentation/Stock%20Report/widget/stock_table_header.dart';

import '../../../logic/report/stock_report_cubit.dart';
import '../../../logic/report/stock_report_state.dart';


class StockReportTable extends StatelessWidget {
  const StockReportTable({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StockReportCubit, StockReportState>(
      builder: (context, state) {
        if (state is! StockReportLoaded) {
          return const SizedBox();
        }

        final stocks = state.products;
        final cubit = context.read<StockReportCubit>();

        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: const Color(0xFFE5E7EB),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              const StockTableHeader(),
              Container(
                height: 1,
                color: const Color(0xFFE5E7EB),
              ),
              Expanded(
                child: ListView.separated(
                  padding: EdgeInsets.zero,
                  itemCount: stocks.length,
                  separatorBuilder: (_, __) => const SizedBox.shrink(),
                  itemBuilder: (context, index) {
                    final stock = stocks[index];
                    return StockTableRow(
                      index: index + 1,
                      productName: stock.productName,
                      quantity: stock.quantity,

                      stockValue: stock.stockValue,

                      isEven: index % 2 == 0, status: '',
                    );
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(14),
                    bottomRight: Radius.circular(14),
                  ),
                  border: Border(
                    top: BorderSide(color: const Color(0xFFE5E7EB)),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'إجمالي النتائج: ${cubit.totalCount}',
                      style: GoogleFonts.cairo(
                        fontSize: 13,
                        color: const Color(0xFF6B7280),
                      ),
                    ),
                    Row(
                      children: [
                        _buildPaginationButton(
                          icon: Icons.chevron_left,
                          isActive: cubit.page > 0,
                          onPressed: cubit.previousPage,
                        ),
                        const SizedBox(width: 4),
                        _buildPaginationNumber(
                          '${cubit.page + 1}',
                          true,
                        ),
                        _buildPaginationNumber(
                          '${cubit.totalPages}',
                          false,
                        ),
                        const SizedBox(width: 4),
                        _buildPaginationButton(
                          icon: Icons.chevron_right,
                          isActive: cubit.page < cubit.totalPages - 1,
                          onPressed: cubit.nextPage,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPaginationButton({
    required IconData icon,
    required bool isActive,
    required VoidCallback onPressed,
  }) {
    return MouseRegion(
      cursor: isActive ? SystemMouseCursors.click : SystemMouseCursors.basic,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFF2563EB) : const Color(0xFFF3F4F6),
          borderRadius: BorderRadius.circular(8),
          border: isActive
              ? null
              : Border.all(color: const Color(0xFFE5E7EB), width: 1),
        ),
        child: IconButton(
          onPressed: isActive ? onPressed : null,
          icon: Icon(
            icon,
            size: 18,
            color: isActive ? Colors.white : const Color(0xFF9CA3AF),
          ),
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
          splashRadius: 20,
        ),
      ),
    );
  }

  Widget _buildPaginationNumber(String number, bool isSelected) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF2563EB) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: isSelected
              ? null
              : Border.all(color: Colors.transparent, width: 1),
        ),
        child: Center(
          child: Text(
            number,
            style: GoogleFonts.cairo(
              fontSize: 13,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w400,
              color: isSelected ? Colors.white : const Color(0xFF6B7280),
            ),
          ),
        ),
      ),
    );
  }
}