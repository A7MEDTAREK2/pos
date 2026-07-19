import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/model/reports.dart';
import 'reports_state.dart';

class ReportsCubit extends Cubit<ReportsState> {
  ReportsCubit() : super(ReportsInitial());

  ReportType currentReport = ReportType.sales;

  void changeReport(ReportType report) {
    currentReport = report;
    emit(ReportChanged(report));
  }
}