import '../data_source/customer_local_data_source.dart';
import '../model/customer.dart';

abstract class CustomerReportRepository {
  Future<List<CustomerReportModel>> getCustomerReport({
    required DateTime from,
    required DateTime to,
    required String search,
    required int limit,
    required int offset,
  });

  Future<int> getCustomerReportCount({
    required DateTime from,
    required DateTime to,
    required String search,
  });
}

class CustomerReportRepositoryImpl
    implements CustomerReportRepository {

  final CustomerReportLocalDataSource localDataSource;

  CustomerReportRepositoryImpl({
    required this.localDataSource,
  });

  @override
  Future<List<CustomerReportModel>> getCustomerReport({
    required DateTime from,
    required DateTime to,
    required String search,
    required int limit,
    required int offset,
  }) {
    return localDataSource.getCustomerReport(
      from: from,
      to: to,
      search: search,
      limit: limit,
      offset: offset,
    );
  }

  @override
  Future<int> getCustomerReportCount({
    required DateTime from,
    required DateTime to,
    required String search,
  }) {
    return localDataSource.getCustomerReportCount(
      from: from,
      to: to,
      search: search,
    );
  }
}