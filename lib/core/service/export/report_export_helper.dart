import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../core/service/export/report_export_model.dart';
import '../../../feature/reports/logic/product_report_cubit.dart';
import '../../../feature/reports/logic/report/customer_report_cubit.dart';
import '../../../feature/reports/logic/report/order_type_report_cubit.dart';
import '../../../feature/reports/logic/report/payment_report_cubit.dart';
import '../../../feature/reports/logic/report/stock_report_cubit.dart';
import '../../../feature/reports/logic/sale_report_cubit.dart';


class ReportExportMapper {
  final BuildContext context;

  ReportExportMapper(this.context);

  ReportExportModel sales() {
    final sales = context.read<ReportCubit>().sales;

    return ReportExportModel(
      title: "تقرير المبيعات",
      fileName: "sales_report",
      from: context.read<ReportCubit>().from,
      to: context.read<ReportCubit>().to,
      headers: const [
        "رقم الفاتورة",
        "العميل",
        "نوع الطلب",
        "طريقة الدفع",
        "الإجمالي",
        "التاريخ",
      ],
      rows: sales
          .map(
            (e) => [
          e.orderNumber.toString(),
          e.customerName,
          e.orderTypeName,
          e.paymentMethod,
          e.total.toStringAsFixed(2),
              formatDate(e.createdAt),
        ],
      )
          .toList(),
    );
  }

  ReportExportModel products() {
    final products = context.read<ProductReportCubit>().products;

    return ReportExportModel(
      title: "تقرير المنتجات",
      fileName: "products_report",
      from: context.read<ProductReportCubit>().from,
      to: context.read<ProductReportCubit>().to,
      headers: const [
        "المنتج",
        "عدد مرات البيع",
        "الكمية المباعة",
        "إجمالي المبيعات",
      ],
      rows: products
          .map(
            (e) => [
          e.productName,
          e.salesCount.toString(),
          e.totalQuantity.toString(),
              "${e.totalRevenue.toStringAsFixed(2)} ج.م",
        ],
      )
          .toList(),
    );
  }

  ReportExportModel customers() {
    final customers = context.read<CustomerReportCubit>().customers;

    return ReportExportModel(
      title: "تقرير العملاء",
      fileName: "customers_report",
      from: context.read<ProductReportCubit>().from,
      to: context.read<ProductReportCubit>().to,
      headers: const [
        "العميل",
        "الهاتف",
        "عدد الطلبات",
        "إجمالي المشتريات",
        "آخر عملية شراء",
      ],
      rows: customers
          .map(
            (e) => [
          e.customerName,
          e.phone,
          e.ordersCount.toString(),
          e.totalSpent.toStringAsFixed(2),
          e.lastPurchase,
        ],
      )
          .toList(),
    );
  }

  ReportExportModel stock() {
    final products = context.read<StockReportCubit>().products;

    return ReportExportModel(
      title: "تقرير المخزون",
      fileName: "stock_report",
      from: context.read<ProductReportCubit>().from,
      to: context.read<ProductReportCubit>().to,
      headers: const [
        "المنتج",
        "الكمية",
        "قيمة المخزون",
      ],
      rows: products
          .map(
            (e) => [
          e.productName,
          e.quantity.toString(),
          e.stockValue.toStringAsFixed(2),
        ],
      )
          .toList(),
    );
  }

  ReportExportModel payments() {
    final payments = context.read<PaymentReportCubit>().payments;

    return ReportExportModel(
      title: "تقرير طرق الدفع",
      fileName: "payment_report",
      from: context.read<ProductReportCubit>().from,
      to: context.read<ProductReportCubit>().to,
      headers: const [
        "طريقة الدفع",
        "عدد الطلبات",
        "إجمالي الإيرادات",
        "النسبة",
      ],
      rows: payments
          .map(
            (e) => [
          e.paymentMethod,
          e.ordersCount.toString(),
              "${e.totalRevenue.toStringAsFixed(2)} ج.م",
          "${e.percentage.toStringAsFixed(1)} %",
        ],
      )
          .toList(),
    );
  }

  ReportExportModel orderTypes() {
    final orders = context.read<OrderTypeReportCubit>().orderTypes;

    return ReportExportModel(
      title: "تقرير أنواع الطلبات",
      fileName: "order_type_report",
      from: context.read<ProductReportCubit>().from,
      to: context.read<ProductReportCubit>().to,
      headers: const [
        "نوع الطلب",
        "عدد الطلبات",
        "إجمالي الإيرادات",
        "النسبة",
      ],
      rows: orders
          .map(
            (e) => [
          e.orderTypeName,
          e.ordersCount.toString(),
              "${e.totalRevenue.toStringAsFixed(2)} ج.م",
          "${e.percentage.toStringAsFixed(1)} %",
        ],
      )
          .toList(),
    );
  }
  String formatDate(DateTime date) {
    return DateFormat(
      "dd/MM/yyyy hh:mm a",
    ).format(date);
  }
}