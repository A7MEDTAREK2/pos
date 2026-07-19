class PrinterSettings {
  final String cashierPrinter;
  final String kitchenPrinter;
  final int paperWidth;

  const PrinterSettings({
    required this.cashierPrinter,
    required this.kitchenPrinter,
    required this.paperWidth,
  });

  factory PrinterSettings.empty() {
    return const PrinterSettings(
      cashierPrinter: "",
      kitchenPrinter: "",
      paperWidth: 80,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "cashierPrinter": cashierPrinter,
      "kitchenPrinter": kitchenPrinter,
      "paperWidth": paperWidth,
    };
  }

  factory PrinterSettings.fromMap(Map<String, dynamic> map) {
    return PrinterSettings(
      cashierPrinter: map["cashierPrinter"] ?? "",
      kitchenPrinter: map["kitchenPrinter"] ?? "",
      paperWidth: map["paperWidth"] ?? 80,
    );
  }

  PrinterSettings copyWith({
    String? cashierPrinter,
    String? kitchenPrinter,
    int? paperWidth,
  }) {
    return PrinterSettings(
      cashierPrinter: cashierPrinter ?? this.cashierPrinter,
      kitchenPrinter: kitchenPrinter ?? this.kitchenPrinter,
      paperWidth: paperWidth ?? this.paperWidth,
    );
  }
}