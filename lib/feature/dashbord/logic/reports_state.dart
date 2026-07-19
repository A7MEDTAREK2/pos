import '../data/model/reports.dart';

abstract class ReportsState {}

class ReportsInitial extends ReportsState {}

class ReportChanged extends ReportsState {
  final ReportType report;

  ReportChanged(this.report);
}