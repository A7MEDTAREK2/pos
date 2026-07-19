class SettingsModel {
  final int? id;
  final String storeName;
  final String phone;
  final String address;
  final String taxNumber;
  final String currency;
  final double taxPercentage;
  final String language;
  final String logo;

  final String cashierPrinter;
  final String kitchenPrinter;
  final int paperWidth;
  final bool taxEnabled;

  final bool autoPrintReceipt;
  final bool autoPrintKitchen;
  final bool autoOpenDrawer;

  final bool showLogo;
  final bool showAddress;
  final bool showPhone;
  final bool showTaxNumber;
  final bool showQr;

  final String footerMessage;

  const SettingsModel({
    this.id,
    required this.storeName,
    required this.phone,
    required this.address,
    required this.taxNumber,
    required this.currency,
    required this.taxPercentage,
    required this.language,
    required this.logo,
    required this.cashierPrinter,
    required this.kitchenPrinter,
    required this.paperWidth,
    required this.taxEnabled,

    required this.autoPrintReceipt,
    required this.autoPrintKitchen,
    required this.autoOpenDrawer,

    required this.showLogo,
    required this.showAddress,
    required this.showPhone,
    required this.showTaxNumber,
    required this.showQr,

    required this.footerMessage,
  });

  factory SettingsModel.fromMap(Map<String, dynamic> map) {
    return SettingsModel(
      id: map["id"],
      storeName: map["store_name"] ?? "",
      phone: map["phone"] ?? "",
      address: map["address"] ?? "",
      taxNumber: map["tax_number"] ?? "",
      currency: map["currency"] ?? "EGP",
      taxPercentage: (map["tax_percentage"] ?? 0).toDouble(),
      language: map["language"] ?? "ar",
      logo: map["logo"] ?? "",
      cashierPrinter:
      (map["cashier_printer"] == null ||
          map["cashier_printer"].toString().isEmpty)
          ? "طابعة 1"
          : map["cashier_printer"],

      kitchenPrinter:
      (map["kitchen_printer"] == null ||
          map["kitchen_printer"].toString().isEmpty)
          ? "طابعة 1"
          : map["kitchen_printer"],
      paperWidth: map["paper_width"] ?? 80,
      taxEnabled: (map["tax_enabled"] ?? 1) == 1,

      autoPrintReceipt:
      (map["auto_print_receipt"] ?? 0) == 1,

      autoPrintKitchen:
      (map["auto_print_kitchen"] ?? 1) == 1,

      autoOpenDrawer:
      (map["auto_open_drawer"] ?? 1) == 1,

      showLogo:
      (map["show_logo"] ?? 1) == 1,

      showAddress:
      (map["show_address"] ?? 1) == 1,

      showPhone:
      (map["show_phone"] ?? 1) == 1,

      showTaxNumber:
      (map["show_tax_number"] ?? 0) == 1,

      showQr:
      (map["show_qr"] ?? 1) == 1,

      footerMessage:
      map["footer_message"] ?? "",
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "store_name": storeName,
      "phone": phone,
      "address": address,
      "tax_number": taxNumber,
      "currency": currency,
      "tax_percentage": taxPercentage,
      "language": language,
      "logo": logo,
      "cashier_printer": cashierPrinter,
      "kitchen_printer": kitchenPrinter,
      "paper_width": paperWidth,
      "tax_enabled": taxEnabled ? 1 : 0,

      "auto_print_receipt": autoPrintReceipt ? 1 : 0,
      "auto_print_kitchen": autoPrintKitchen ? 1 : 0,
      "auto_open_drawer": autoOpenDrawer ? 1 : 0,

      "show_logo": showLogo ? 1 : 0,
      "show_address": showAddress ? 1 : 0,
      "show_phone": showPhone ? 1 : 0,
      "show_tax_number": showTaxNumber ? 1 : 0,
      "show_qr": showQr ? 1 : 0,

      "footer_message": footerMessage,
    };
  }

  SettingsModel copyWith({
    String? storeName,
    String? phone,
    String? address,
    String? taxNumber,
    String? currency,
    double? taxPercentage,
    String? language,
    String? logo,
    String? cashierPrinter,
    String? kitchenPrinter,
    int? paperWidth,
    bool? taxEnabled,

    bool? autoPrintReceipt,
    bool? autoPrintKitchen,
    bool? autoOpenDrawer,

    bool? showLogo,
    bool? showAddress,
    bool? showPhone,
    bool? showTaxNumber,
    bool? showQr,

    String? footerMessage,
  }) {
    return SettingsModel(
      id: id,
      storeName: storeName ?? this.storeName,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      taxNumber: taxNumber ?? this.taxNumber,
      currency: currency ?? this.currency,
      taxPercentage: taxPercentage ?? this.taxPercentage,
      language: language ?? this.language,
      logo: logo ?? this.logo,
      cashierPrinter: cashierPrinter ?? this.cashierPrinter,
      kitchenPrinter: kitchenPrinter ?? this.kitchenPrinter,
      paperWidth: paperWidth ?? this.paperWidth,
      taxEnabled: taxEnabled ?? this.taxEnabled,

      autoPrintReceipt:
      autoPrintReceipt ?? this.autoPrintReceipt,

      autoPrintKitchen:
      autoPrintKitchen ?? this.autoPrintKitchen,

      autoOpenDrawer:
      autoOpenDrawer ?? this.autoOpenDrawer,

      showLogo:
      showLogo ?? this.showLogo,

      showAddress:
      showAddress ?? this.showAddress,

      showPhone:
      showPhone ?? this.showPhone,

      showTaxNumber:
      showTaxNumber ?? this.showTaxNumber,

      showQr:
      showQr ?? this.showQr,

      footerMessage:
      footerMessage ?? this.footerMessage,
    );
  }
}