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
  }) {
    return localDataSource.getPaymentReport(
      from: from,
      to: to,
    );
  }
}