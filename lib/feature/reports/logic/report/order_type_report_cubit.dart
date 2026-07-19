import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path/path.dart';

import '../../../../core/service/export/exel_export_service.dart';
import '../../../../core/service/export/pdf_export_service.dart';
import '../../../../core/service/export/print_service.dart';
import '../../../../core/service/export/report_export_model.dart';
import '../../data/model/order_type_report.dart';
import '../../data/repo/order_type_report_repository.dart';

import 'order_type_report_state.dart';

class OrderTypeReportCubit extends Cubit<OrderTypeReportState> {

  final OrderTypeReportRepository repository;


  OrderTypeReportCubit(this.repository)
      : super(OrderTypeReportInitial());

  DateTime from = DateTime.now().subtract(const Duration(days: 7));
  DateTime to = DateTime.now();

  List<OrderTypeReportModel> orderTypes = [];

  Future<void> loadReport() async {
    emit(OrderTypeReportLoading());

    try {
      orderTypes = await repository.getOrderTypeReport(
        from: from,
        to: to,
      );

      emit(OrderTypeReportLoaded(orderTypes));
    } catch (e) {
      emit(OrderTypeReportError(e.toString()));
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
  int get totalCount => orderTypes.length;

  Future<void> loadOrderTypes() async {
    await loadReport();
  }


}