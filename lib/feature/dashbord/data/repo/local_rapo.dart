import '../data_source/local_data_source.dart';
import '../model/dash_model.dart';
import '../model/low_stock_model.dart';
import '../model/order_type_model.dart';
import '../model/payment_method_model.dart';
import '../model/recent_sale_model.dart';
import '../model/sales_chart_model.dart';
import '../model/top_product_model.dart';

abstract class DashboardRepository {
  Future<DashboardModel> getDashboardSummary({
    required DateTime from,
    required DateTime to,
  });

  Future<List<SalesChartModel>> getSalesChart({
    required DateTime from,
    required DateTime to,
  });

  Future<List<TopProductModel>> getTopProducts({
    required DateTime from,
    required DateTime to,
    int limit = 5,
  });

  Future<List<RecentSaleModel>> getRecentSales({
    required DateTime from,
    required DateTime to,
    int limit = 10,
  });

  Future<List<PaymentMethodModel>> getPaymentMethods({
    required DateTime from,
    required DateTime to,
  });

  Future<List<OrderTypeModel>> getOrderTypes({
    required DateTime from,
    required DateTime to,
  });

  Future<List<LowStockModel>> getLowStockProducts({
    int limit = 10,
  });
}

class DashboardRepositoryImpl implements DashboardRepository {
  final DashboardLocalDataSource localDataSource;

  DashboardRepositoryImpl({
    required this.localDataSource,
  });

  @override
  Future<DashboardModel> getDashboardSummary({
    required DateTime from,
    required DateTime to,
  }) {
    return localDataSource.getDashboardSummary(
      from: from,
      to: to,
    );
  }

  @override
  Future<List<SalesChartModel>> getSalesChart({
    required DateTime from,
    required DateTime to,
  }) {
    return localDataSource.getSalesChart(
      from: from,
      to: to,
    );
  }

  @override
  Future<List<TopProductModel>> getTopProducts({
    required DateTime from,
    required DateTime to,
    int limit = 5,
  }) {
    return localDataSource.getTopProducts(
      from: from,
      to: to,
      limit: limit,
    );
  }

  @override
  Future<List<RecentSaleModel>> getRecentSales({
    required DateTime from,
    required DateTime to,
    int limit = 10,
  }) {
    return localDataSource.getRecentSales(
      from: from,
      to: to,
      limit: limit,
    );
  }

  @override
  Future<List<PaymentMethodModel>> getPaymentMethods({
    required DateTime from,
    required DateTime to,
  }) {
    return localDataSource.getPaymentMethods(
      from: from,
      to: to,
    );
  }

  @override
  Future<List<OrderTypeModel>> getOrderTypes({
    required DateTime from,
    required DateTime to,
  }) {
    return localDataSource.getOrderTypes(
      from: from,
      to: to,
    );
  }

  @override
  Future<List<LowStockModel>> getLowStockProducts({
    int limit = 10,
  }) {
    return localDataSource.getLowStockProducts(
      limit: limit,
    );
  }
}