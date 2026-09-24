import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repo/driver_report_repository.dart';

import 'driver_report_state.dart';

class DriverReportCubit extends Cubit<DriverReportState> {
  final DriverReportRepository repository;

  DriverReportCubit({required this.repository}) : super(DriverReportInitial());

  int page = 0;
  final int limit = 10;
  int totalCount = 0;
  int get totalPages => (totalCount == 0) ? 1 : (totalCount / limit).ceil();

  void loadReport() async {
    emit(DriverReportLoading());
    try {
      totalCount = await repository.fetchTotalDriversCount();
      final drivers = await repository.fetchDriversReport(
        limit: limit,
        offset: page * limit,
      );
      emit(DriverReportLoaded(drivers: drivers));
    } catch (e) {
      emit(DriverReportError(message: 'حدث خطأ أثناء تحميل تقرير المناديب: $e'));
    }
  }

  void nextPage() {
    if (page < totalPages - 1) {
      page++;
      loadReport();
    }
  }

  void previousPage() {
    if (page > 0) {
      page--;
      loadReport();
    }
  }
}