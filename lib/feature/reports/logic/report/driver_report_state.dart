import '../../data/model/drive_model.dart'; // عدل مسار الموديل حسب مشروعك

abstract class DriverReportState {}

class DriverReportInitial extends DriverReportState {}

class DriverReportLoading extends DriverReportState {}

class DriverReportLoaded extends DriverReportState {
  final List<DriverReportModel> drivers;

  DriverReportLoaded({required this.drivers});
}

class DriverReportError extends DriverReportState {
  final String message;

  DriverReportError({required this.message});
}