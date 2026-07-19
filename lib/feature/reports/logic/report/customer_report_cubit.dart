import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path/path.dart';

import '../../../../core/service/export/exel_export_service.dart';
import '../../../../core/service/export/pdf_export_service.dart';
import '../../../../core/service/export/print_service.dart';
import '../../../../core/service/export/report_export_model.dart';
import '../../data/model/customer.dart';
import '../../data/repo/customer_report_repository.dart';

import 'customer_report_state.dart';

class CustomerReportCubit extends Cubit<CustomerReportState> {
  final CustomerReportRepository repository;


  CustomerReportCubit(this.repository)
      : super(CustomerReportInitial());

  DateTime from = DateTime.now().subtract(const Duration(days: 7));

  DateTime to = DateTime.now();

  String search = '';

  int page = 0;

  int limit = 20;

  int totalCount = 0;

  int get totalPages => (totalCount / limit).ceil();

  List<CustomerReportModel> customers = [];

  Future<void> loadReport() async {
    emit(CustomerReportLoading());

    try {
      totalCount = await repository.getCustomerReportCount(
        from: from,
        to: to,
        search: search,
      );

      customers = await repository.getCustomerReport(
        from: from,
        to: to,
        search: search,
        limit: limit,
        offset: page * limit,
      );

      emit(CustomerReportLoaded(customers));
    } catch (e) {
      emit(CustomerReportError(e.toString()));
    }
  }

  Future<void> searchReport(String value) async {
    search = value;
    page = 0;
    await loadReport();
  }

  Future<void> changeDateRange({
    required DateTime from,
    required DateTime to,
  }) async {
    this.from = from;
    this.to = to;
    page = 0;
    await loadReport();
  }

  Future<void> nextPage() async {
    if (page >= totalPages - 1) return;
    page++;
    await loadReport();
  }

  Future<void> previousPage() async {
    if (page == 0) return;
    page--;
    await loadReport();
  }


}