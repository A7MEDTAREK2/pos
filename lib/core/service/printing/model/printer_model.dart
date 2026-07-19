class PrinterModel {
  final String name;
  final bool isDefault;
  final bool isOnline;
  final String status;

  PrinterModel({
    required this.name,
    required this.isDefault,
    required this.isOnline,
    required this.status,
  });

  factory PrinterModel.fromJson(Map<String, dynamic> json) {
    return PrinterModel(
      name: json["name"] ?? "",
      isDefault: json["isDefault"] ?? false,
      isOnline: json["isOnline"] ?? false,
      status: json["status"] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "isDefault": isDefault,
      "isOnline": isOnline,
      "status": status,
    };
  }
}