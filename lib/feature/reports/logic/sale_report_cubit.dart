import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home/feature/reports/logic/sale_report_state.dart';

import '../data/model/sale_report_model.dart';
import '../data/repo/local_rapo.dart';


class ReportCubit extends Cubit<ReportsState> {
  final ReportsRepository repository;

  ReportCubit(this.repository) : super(ReportsInitial());

  DateTime from = DateTime.now().subtract(const Duration(days: 7));
  DateTime to = DateTime.now();

  String search = '';

  int page = 0;

  int limit = 20;

  List<SalesReportModel> sales = [];
  int totalCount = 0;

  int get totalPages => (totalCount / limit).ceil();

  Future<void> loadSalesReport() async {
    emit(ReportsLoading());

    try {
      totalCount = await repository.getSalesReportCount(
        from: from,
        to: to,
        search: search,
      );
      sales = await repository.getSalesReport(
        from: from,
        to: to,
        search: search,
        limit: limit,
        offset: page * limit,
      );

      emit(ReportsLoaded(sales));
    } catch (e) {
      emit(ReportsError(e.toString()));
    }
  }

  Future<void> searchReport(String value) async {
    search = value;
    page = 0;
    await loadSalesReport();
  }

  Future<void> changeDateRange({
    required DateTime from,
    required DateTime to,
  }) async {
    this.from = from;
    this.to = to;
    page = 0;

    await loadSalesReport();
  }

  Future<void> nextPage() async {
    page++;
    await loadSalesReport();
  }

  Future<void> previousPage() async {
    if (page == 0) return;

    page--;
    await loadSalesReport();
  }

  Future<void> refresh() async {
    await loadSalesReport();
  }

}