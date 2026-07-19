// lib/feature/reports/payment_report/presentation/widgets/payment_report_table.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:home/feature/reports/presentation/Payment%20Report/widget/payment_table_header.dart';
import 'package:home/feature/reports/presentation/Payment%20Report/widget/payment_table_row.dart';
import '../../../logic/report/payment_report_cubit.dart';
import '../../../logic/report/payment_report_state.dart';


class PaymentReportTable extends StatelessWidget {
  const PaymentReportTable({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PaymentReportCubit, PaymentReportState>(
      builder: (context, state) {
        if (state is! PaymentReportLoaded) {
          return const SizedBox();
        }

        final payments = state.payments;
        final cubit = context.read<PaymentReportCubit>();

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
              const PaymentTableHeader(),
              Container(
                height: 1,
                color: const Color(0xFFE5E7EB),
              ),
              Expanded(
                child: ListView.separated(
                  padding: EdgeInsets.zero,
                  itemCount: payments.length,
                  separatorBuilder: (_, __) => const SizedBox.shrink(),
                  itemBuilder: (context, index) {
                    final payment = payments[index];
                    return PaymentTableRow(
                      index: index + 1,
                      paymentMethod: payment.paymentMethod,
                      transactionCount: payment.transactionCount,
                      totalRevenue: payment.totalRevenue,
                      averageValue: payment.averageValue,
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