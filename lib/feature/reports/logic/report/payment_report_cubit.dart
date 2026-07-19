import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path/path.dart';


import '../../../../core/service/export/report_export_model.dart';
import '../../data/model/payment_report.dart';
import '../../data/repo/payment_report_repository.dart';

import 'payment_report_state.dart';

class PaymentReportCubit extends Cubit<PaymentReportState> {
  final PaymentReportRepository repository;


  PaymentReportCubit(this.repository)
      : super(PaymentReportInitial());

  DateTime from = DateTime.now().subtract(const Duration(days: 7));
  DateTime to = DateTime.now();

  List<PaymentReportModel> payments = [];
  int get totalCount => payments.length;

  Future<void> loadReport() async {
    emit(PaymentReportLoading());

    try {
      payments = await repository.getPaymentReport(
        from: from,
        to: to,
      );

      emit(PaymentReportLoaded(payments));
    } catch (e) {
      emit(PaymentReportError(e.toString()));
    }
  }

  Future<void> changeDateRange({
    required DateTime from,
    required DateTime to,
  }) async {
    this.from = from;
    this.to = to;
    await loadReport();
  }
  Future<void> loadPayments() async {
    await loadReport();
  }


}