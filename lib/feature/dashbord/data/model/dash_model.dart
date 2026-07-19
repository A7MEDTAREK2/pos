

import 'package:home/feature/dashbord/data/model/payment_method_model.dart';
import 'package:home/feature/dashbord/data/model/recent_sale_model.dart';
import 'package:home/feature/dashbord/data/model/sales_chart_model.dart';
import 'package:home/feature/dashbord/data/model/top_product_model.dart';

import 'low_stock_model.dart';
import 'order_type_model.dart';

class DashboardModel {
  final double totalSales;
  final double totalProfit;
  final int totalOrders;
  final double averageOrder;

  final int totalCustomers;
  final int totalProducts;

  final List<SalesChartModel> salesChart;
  final List<TopProductModel> topProducts;
  final List<RecentSaleModel> recentSales;
  final List<PaymentMethodModel> paymentMethods;
  final List<OrderTypeModel> orderTypes;
  final List<LowStockModel> lowStockProducts;

  const DashboardModel({
    required this.totalSales,
    required this.totalProfit,
    required this.totalOrders,
    required this.averageOrder,
    required this.totalCustomers,
    required this.totalProducts,
    required this.salesChart,
    required this.topProducts,
    required this.recentSales,
    required this.paymentMethods,
    required this.orderTypes,
    required this.lowStockProducts,
  });
}