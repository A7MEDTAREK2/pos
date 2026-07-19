import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/model/dash_model.dart';

import '../data/model/data_rang.dart';
import '../data/repo/local_rapo.dart';
import 'dash_state.dart';

class DashboardCubit extends Cubit<DashboardState> {
  final DashboardRepository repository;

  DashboardCubit(this.repository) : super(DashboardInitial());

  DashboardFilter selectedFilter = DashboardFilter.today;
  DateTime from = DateTime.now().subtract(const Duration(days: 7));
  DateTime to = DateTime.now();


  Future<void> changeFilter(DashboardFilter filter) async {
    selectedFilter = filter;
    await loadDashboard();
  }

  DateRangeModel get currentRange {
    final now = DateTime.now();

    switch (selectedFilter) {
      case DashboardFilter.today:
        return DateRangeModel(
          from: DateTime(now.year, now.month, now.day),
          to: now,
        );

      case DashboardFilter.week:
        return DateRangeModel(
          from: now.subtract(const Duration(days: 6)),
          to: now,
        );

      case DashboardFilter.month:
        return DateRangeModel(
          from: DateTime(now.year, now.month, 1),
          to: now,
        );

      case DashboardFilter.year:
        return DateRangeModel(
          from: DateTime(now.year, 1, 1),
          to: now,
        );
    }
  }

  Future<void> loadDashboard() async {
    emit(DashboardLoading());

    try {
      final summary = await repository.getDashboardSummary(
        from: from,
        to: to,
      );

      final salesChart = await repository.getSalesChart(
        from: from,
        to: to,
      );

      final topProducts = await repository.getTopProducts(
        from: from,
        to: to,
      );

      final recentSales = await repository.getRecentSales(
        from: from,
        to: to,
      );

      final paymentMethods = await repository.getPaymentMethods(
        from: from,
        to: to,
      );

      final orderTypes = await repository.getOrderTypes(
        from: from,
        to: to,
      );

      final lowStock = await repository.getLowStockProducts();

      final dashboard = DashboardModel(
        totalSales: summary.totalSales,
        totalProfit: summary.totalProfit,
        totalOrders: summary.totalOrders,
        averageOrder: summary.averageOrder,
        totalCustomers: summary.totalCustomers,
        totalProducts: summary.totalProducts,
        salesChart: salesChart,
        topProducts: topProducts,
        recentSales: recentSales,
        paymentMethods: paymentMethods,
        orderTypes: orderTypes,
        lowStockProducts: lowStock,
      );

      emit(DashboardSuccess(dashboard));
    } catch (e) {
      emit(DashboardError(e.toString()));
    }
  }

  Future<void> refresh() async {
    await loadDashboard();
  }
  Future<void> changeDateRange({
    required DateTime from,
    required DateTime to,
  }) async {
    this.from = from;
    this.to = to;

    await loadDashboard();
  }
}