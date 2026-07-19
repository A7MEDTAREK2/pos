
import '../data/model/sale_report_model.dart';

abstract class ReportsState {}

class ReportsInitial extends ReportsState {}

class ReportsLoading extends ReportsState {}

class ReportsLoaded extends ReportsState {
  final List<SalesReportModel> sales;

  ReportsLoaded(this.sales);
}

class ReportsError extends ReportsState {
  final String message;

  ReportsError(this.message);
}