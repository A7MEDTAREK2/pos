// lib/feature/reports/order_type_report/presentation/widgets/order_type_report_table.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../logic/report/order_type_report_cubit.dart';
import '../../../logic/report/order_type_report_state.dart';
import 'orderType_table_header.dart';
import 'orderType_table_row.dart';


class OrderTypeReportTable extends StatelessWidget {
  const OrderTypeReportTable({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrderTypeReportCubit, OrderTypeReportState>(
      builder: (context, state) {
        if (state is! OrderTypeReportLoaded) {
          return const SizedBox();
        }

        final orderTypes = state.orderTypes;
        final cubit = context.read<OrderTypeReportCubit>();

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
              const OrderTypeTableHeader(),
              Container(
                height: 1,
                color: const Color(0xFFE5E7EB),
              ),
              Expanded(
                child: ListView.separated(
                  padding: EdgeInsets.zero,
                  itemCount: orderTypes.length,
                  separatorBuilder: (_, __) => const SizedBox.shrink(),
                  itemBuilder: (context, index) {
                    final orderType = orderTypes[index];
                    return OrderTypeTableRow(
                      index: index + 1,
                      orderType: orderType.orderTypeName,
                      orderCount: orderType.orderCount,
                      totalRevenue: orderType.totalRevenue,
                      averageValue: orderType.averageValue,
                      isEven: index % 2 == 0,
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

                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }


}