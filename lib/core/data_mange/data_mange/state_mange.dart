abstract class MaintenanceState {}

class MaintenanceInitial extends MaintenanceState {}

class MaintenanceLoading extends MaintenanceState {}

class MaintenanceSuccess extends MaintenanceState {
  final String message;

  MaintenanceSuccess(this.message);
}

class MaintenanceError extends MaintenanceState {
  final String message;

  MaintenanceError(this.message);
}