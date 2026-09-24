import '../../../../core/service/audit_log_service.dart';
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
  }) async {
    final result = await localDataSource.getCustomerReport(
      from: from,
      to: to,
      search: search,
      limit: limit,
      offset: offset,
    );

    await AuditLogService.instance.log(
      userId: 1,
      userName: 'مشرف النظام',
      action: 'VIEW',
      module: 'التقارير',
      entityType: 'CustomerReport',
      description: 'تم فتح واستعراض تقرير العملاء',
    );

    return result;
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