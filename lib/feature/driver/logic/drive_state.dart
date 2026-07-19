import '../data/model_drive.dart';

abstract class DriverState {}

class DriverInitial extends DriverState {}

class DriverLoading extends DriverState {}

class DriversLoaded extends DriverState {
  final List<DriverModel> drivers;
  DriversLoaded(this.drivers);
}

class DriverOperationLoading extends DriverState {}

class DriverOperationSuccess extends DriverState {
  final String message;
  DriverOperationSuccess(this.message);
}

class DriverError extends DriverState {
  final String message;
  DriverError(this.message);
}