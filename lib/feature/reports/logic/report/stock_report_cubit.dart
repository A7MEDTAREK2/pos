import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path/path.dart';

import '../../../../core/service/export/exel_export_service.dart';
import '../../../../core/service/export/pdf_export_service.dart';
import '../../../../core/service/export/print_service.dart';
import '../../../../core/service/export/report_export_model.dart';
import '../../data/model/stock.dart';
import '../../data/repo/stock_report_repository.dart';

import 'stock_report_state.dart';

class StockReportCubit extends Cubit<StockReportState> {
  final StockReportRepository repository;


  StockReportCubit(this.repository)
      : super(StockReportInitial());

  String search = '';

  int page = 0;
  int limit = 20;

  int totalCount = 0;

  int get totalPages => (totalCount / limit).ceil();

  List<StockReportModel> products = [];

  Future<void> loadReport() async {
    emit(StockReportLoading());

    try {
      totalCount = await repository.getStockReportCount(
        search: search,
      );

      products = await repository.getStockReport(
        search: search,
        limit: limit,
        offset: page * limit,
      );

      emit(StockReportLoaded(products));
    } catch (e) {
      emit(StockReportError(e.toString()));
    }
  }

  Future<void> searchReport(String value) async {
    search = value;
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