import '../../../../core/service/audit_log_service.dart';
import '../data_source/payment_local_data_source.dart';
import '../model/payment_report.dart';

abstract class PaymentReportRepository {
  Future<List<PaymentReportModel>> getPaymentReport({
    required DateTime from,
    required DateTime to,
  });
}

class PaymentReportRepositoryImpl
    implements PaymentReportRepository {

  final PaymentReportLocalDataSource localDataSource;

  PaymentReportRepositoryImpl({
    required this.localDataSource,
  });

  @override
  Future<List<PaymentReportModel>> getPaymentReport({
    required DateTime from,
    required DateTime to,
  }) async {
    final result = await localDataSource.getPaymentReport(
      from: from,
      to: to,
    );

    await AuditLogService.instance.log(
      userId: 1,
      userName: 'مشرف النظام',
      action: 'VIEW',
      module: 'التقارير',
      entityType: 'PaymentReport',
      description: 'تم فتح تقرير طرق الدفع والتحصيلات',
    );

    return result;
  }
}