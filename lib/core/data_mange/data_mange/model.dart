class MaintenanceModel {
  final bool success;
  final String message;

  const MaintenanceModel({
    required this.success,
    required this.message,
  });

  factory MaintenanceModel.success([String message = "Success"]) {
    return MaintenanceModel(
      success: true,
      message: message,
    );
  }

  factory MaintenanceModel.error(String message) {
    return MaintenanceModel(
      success: false,
      message: message,
    );
  }
}