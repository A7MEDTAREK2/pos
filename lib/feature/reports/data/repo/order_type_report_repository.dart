import '../../../../core/service/audit_log_service.dart';
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
  }) async {
    final result = await localDataSource.getOrderTypeReport(
      from: from,
      to: to,
    );

    await AuditLogService.instance.log(
      userId: 1,
      userName: 'مشرف النظام',
      action: 'VIEW',
      module: 'التقارير',
      entityType: 'OrderTypeReport',
      description: 'تم فتح تقرير أنواع الطلبات',
    );

    return result;
  }
}