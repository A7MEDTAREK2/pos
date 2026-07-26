// lib/feature/reports/presentation/screen/reports_screen.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:home/feature/reports/presentation/widgets/reports_content.dart';
import 'package:home/feature/reports/presentation/widgets/reports_search_bar.dart';
import 'package:home/feature/reports/presentation/widgets/reports_sidebar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home/feature/reports/logic/sale_report_cubit.dart';

import '../../core/service/export/report_export_helper.dart';
import '../../core/service/export/report_export_model.dart';
import '../../core/service/export/report_export_service.dart';
import 'logic/product_report_cubit.dart';
import 'logic/report/customer_report_cubit.dart';
import 'logic/report/order_type_report_cubit.dart';
import 'logic/report/payment_report_cubit.dart';
import 'logic/report/stock_report_cubit.dart';
import '../../../../core/service/printing/printing_manager.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();

}

class _ReportsScreenState extends State<ReportsScreen> {

  final exporter = ReportExportService();
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadCurrentReport();
    });
  }

  int selectedIndex = 0;
  String _getHint() {
    switch (selectedIndex) {
      case 0:
        return "ابحث برقم الفاتورة أو اسم العميل...";

      case 1:
        return "ابحث باسم المنتج...";

      case 2:
        return "ابحث باسم العميل...";

      case 3:
        return "ابحث باسم المنتج...";

      case 4:
        return "لا يوجد بحث";

      case 5:
        return "لا يوجد بحث";

      default:
        return "بحث...";
    }

  }
  void _onSearch(BuildContext context, String value) {
    switch (selectedIndex) {
      case 0:
        context.read<ReportCubit>().searchReport(value);
        break;

      case 1:
        context.read<ProductReportCubit>().searchReport(value);
        break;

      case 2:
        context.read<CustomerReportCubit>().searchReport(value);
        break;

      case 3:
        context.read<StockReportCubit>().searchReport(value);
        break;

      case 4:
        break;

      case 5:
        break;
    }

  }
  void _onDateChanged(
      BuildContext context,
      DateTime from,
      DateTime to,
      ) {
    switch (selectedIndex) {
      case 0:
        context.read<ReportCubit>().changeDateRange(
          from: from,
          to: to,
        );
        break;

      case 1:
        context.read<ProductReportCubit>().changeDateRange(
          from: from,
          to: to,
        );
        break;

      case 2:
        context.read<CustomerReportCubit>().changeDateRange(
          from: from,
          to: to,
        );
        break;

      case 3:
        break;

      case 4:
        context.read<PaymentReportCubit>().changeDateRange(
          from: from,
          to: to,
        );
        break;

      case 5:
        context.read<OrderTypeReportCubit>().changeDateRange(
          from: from,
          to: to,
        );
        break;
    }
  }
  void _loadCurrentReport() {
    switch (selectedIndex) {
      case 0:
        context.read<ReportCubit>().loadSalesReport();
        break;

      case 1:
        context.read<ProductReportCubit>().loadReport();
        break;

      case 2:
        context.read<CustomerReportCubit>().loadReport();
        break;

      case 3:
        context.read<StockReportCubit>().loadReport();
        break;

      case 4:
        context.read<PaymentReportCubit>().loadReport();
        break;

      case 5:
        context.read<OrderTypeReportCubit>().loadReport();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFF8FAFC),
        body: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ====== Sidebar ======
            ReportsSidebar(
              selectedIndex: selectedIndex,
              onChanged: (index) {
                setState(() {
                  selectedIndex = index;
                });

                switch (index) {
                  case 0:
                    context.read<ReportCubit>().loadSalesReport();
                    break;

                  case 1:
                    context.read<ProductReportCubit>().loadReport();
                    break;

                  case 2:
                    context.read<CustomerReportCubit>().loadReport();
                    break;

                  case 3:
                    context.read<StockReportCubit>().loadReport();
                    break;

                  case 4:
                    context.read<PaymentReportCubit>().loadReport();
                    break;

                  case 5:
                    context.read<OrderTypeReportCubit>().loadReport();
                    break;
                }
              },
            ),

            // ====== Main Content ======
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ====== Top Bar with Back Button ======
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 16,
                    ),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      border: Border(
                        bottom: BorderSide(color: Color(0xFFE5E7EB)),
                      ),
                    ),
                    child: Row(
                      children: [
                        const SizedBox(width: 16),

                        // ====== Title ======
                        Text(
                          'التقارير التفصيلية',
                          style: GoogleFonts.cairo(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF111827),
                          ),
                        ),
                        const Spacer(),

                        // ====== Close Button ======
                        InkWell(
                          borderRadius: BorderRadius.circular(10),
                          onTap: () => Navigator.pop(context),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF8FAFC),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: const Color(0xFFE5E7EB),
                              ),
                            ),
                            child: const Icon(
                              Icons.arrow_back_ios,
                              size: 18,
                              color: Color(0xFF6B7280),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // ====== Content ======
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // ====== Search & Filter ======
                          ReportToolbar(
                          hintText: _getHint(),
                      onSearch: (value) => _onSearch(context, value),

                      onDateChanged: (from, to) =>
                          _onDateChanged(context, from, to),

                      onPdf: _exportPdf,

                      onExcel: _exportExcel,

                      onPrint: _print,

                          ),
                          const SizedBox(height: 24),

                          // ====== Content ======
                          Expanded(
                            child: ReportsContent(selectedIndex: selectedIndex),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  Future<void> _exportPdf() async {
    final mapper = ReportExportMapper(context);

    switch (selectedIndex) {
      case 0:
        await exporter.exportPdf(mapper.sales());
        break;

      case 1:
        await exporter.exportPdf(mapper.products());
        break;

      case 2:
        await exporter.exportPdf(mapper.customers());
        break;

      case 3:
        await exporter.exportPdf(mapper.stock());
        break;

      case 4:
        await exporter.exportPdf(mapper.payments());
        break;

      case 5:
        await exporter.exportPdf(mapper.orderTypes());
        break;
    }
  }
  Future<void> _exportExcel() async {
    final mapper = ReportExportMapper(context);

    switch (selectedIndex) {
      case 0:
        await exporter.exportExcel(mapper.sales());
        break;

      case 1:
        await exporter.exportExcel(mapper.products());
        break;

      case 2:
        await exporter.exportExcel(mapper.customers());
        break;

      case 3:
        await exporter.exportExcel(mapper.stock());
        break;

      case 4:
        await exporter.exportExcel(mapper.payments());
        break;

      case 5:
        await exporter.exportExcel(mapper.orderTypes());
        break;
    }
  }

  Future<void> _print() async {
    print("PRINT BUTTON CLICKED");

    final mapper = ReportExportMapper(context);

    switch (selectedIndex) {
      case 0:
        print("SALES REPORT");
        await _printDailySalesReport();
        break;

      case 1:
        print("PRODUCT REPORT");
        await PrintingManager.instance.printReport(
          mapper.products(),
        );
        break;

      case 2:
        print("CUSTOMER REPORT");
        await PrintingManager.instance.printReport(
          mapper.customers(),
        );
        break;

      case 3:
        print("STOCK REPORT");
        await PrintingManager.instance.printReport(
          mapper.stock(),
        );
        break;

      case 4:
        print("PAYMENT REPORT");
        await PrintingManager.instance.printReport(
          mapper.payments(),
        );
        break;

      case 5:
        print("ORDER TYPE REPORT");
        await PrintingManager.instance.printReport(
          mapper.orderTypes(),
        );
        break;
    }

  }
  Future<void> _printDailySalesReport() async {
    print("STEP 1");

    final cubit = context.read<ReportCubit>();

    final sales = cubit.sales;

    print("STEP 2 - Sales Count = ${sales.length}");

    if (sales.isEmpty) {
      print("NO SALES");
      return;
    }

    final total = sales.fold<double>(
      0,
          (sum, item) => sum + item.total,
    );

    print("STEP 3 - Total = $total");

    final Map<String, double> payments = {};

    for (final sale in sales) {
      payments[sale.paymentMethod] =
          (payments[sale.paymentMethod] ?? 0) + sale.total;
    }

    print("STEP 4");

    final shiftProducts = await cubit.repository.getShiftProducts(
      from: cubit.from,
      to: cubit.to,
    );

    print("STEP 5 - Products = ${shiftProducts.length}");

    final products = shiftProducts.map((e) {
      return {
        "name": e.name,
        "quantitySold": e.quantitySold,
        "totalSales": e.totalSales,
      };
    }).toList();

    print("STEP 6");

    await PrintingManager.instance.printDailyReport(
      storeName: "Modu POS",
      cashier: "Admin",
      ordersCount: sales.length,
      subTotal: total,
      discount: 0,
      tax: 0,
      delivery: 0,
      netSales: total,
      paymentSummary: payments,
      products: products,
    );

    print("STEP 7");
  }
}
