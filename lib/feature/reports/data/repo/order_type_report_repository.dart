import '../data_source/order_type_local_data_source.dart';
import '../model/order_type_report.dart';

abstract class OrderTypeReportRepository {
  Future<List<OrderTypeReportModel>> getOrderTypeReport({
    required DateTime from,
    required DateTime to,
  });
}

class OrderTypeReportRepositoryImpl
    implements OrderTypeReportRepository {

  final OrderTypeReportLocalDataSource localDataSource;

  OrderTypeReportRepositoryImpl({
    required this.localDataSource,
  });

  @override
  Future<List<OrderTypeReportModel>> getOrderTypeReport({
    required DateTime from,
    required DateTime to,
  }) {
    return localDataSource.getOrderTypeReport(
      from: from,
      to: to,
    );
  }
}