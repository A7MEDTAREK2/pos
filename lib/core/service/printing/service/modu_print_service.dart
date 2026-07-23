import 'package:dio/dio.dart';

class ModuPrintService {
  static const String _baseUrl = "http://127.0.0.1:5089";

  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: _baseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        "Content-Type": "application/json",
      },
      validateStatus: (status) => status != null && status < 500,
    ),
  );

  // =============================
  // Get Installed Printers
  // =============================
  Future<List<dynamic>> getPrinters() async {
    final response = await _dio.get("/api/printer/list");
    if (response.statusCode == 200) {
      return response.data as List<dynamic>;
    }
    throw Exception("فشل جلب قائمة الطابعات: ${response.statusCode}");
  }

  // =============================
  // Get Settings (/api/settings)
  // =============================
  Future<Map<String, dynamic>?> getSettings() async {
    try {
      final response = await _dio.get("/api/settings");
      if (response.statusCode == 200 && response.data != null) {
        return Map<String, dynamic>.from(response.data);
      }
    } catch (e) {
      print("خطأ أثناء جلب الإعدادات: $e");
    }
    return null;
  }

  // =============================
  // Printer Status
  // =============================
  Future<Map<String, dynamic>> getStatus() async {
    final response = await _dio.get("/api/printer/status");
    return Map<String, dynamic>.from(response.data);
  }

  // =============================
  // Save Settings (/api/settings/save)
  // =============================
  Future<void> saveSettings(Map<String, dynamic> settingsData) async {
    print("📤 Data sent to server: $settingsData"); // أضف هذا السطر هنا

    final response = await _dio.post(
      "/api/settings/save",
      data: settingsData,
    );

    if (response.statusCode != 200) {
      throw Exception("خطأ أثناء حفظ الإعدادات (${response.statusCode}): ${response.data}");
    }
  }

  // =============================
  // Test Print (/api/printer/test)
  // =============================
  Future<void> testPrint({
    required String printerName,
    required int paperWidth,
  }) async {
    final response = await _dio.post(
      "/api/printer/test",
      data: {
        "printerName": printerName,
        "printer": printerName,
        "paperWidth": paperWidth,
      },
    );

    if (response.statusCode != 200) {
      throw Exception("خطأ من السيرفر (${response.statusCode}): ${response.data}");
    }
  }

  // =============================
  // Open Drawer (/api/printer/open-drawer)
  // =============================
  Future<void> openDrawer({
    required String printerName,
  }) async {
    final response = await _dio.post(
      "/api/printer/open-drawer",
      data: {
        "printerName": printerName,
        "printer": printerName,
      },
    );

    if (response.statusCode != 200) {
      throw Exception("خطأ من السيرفر (${response.statusCode}): ${response.data}");
    }
  }

  // =============================
  // Print Receipt (/api/printer/receipt)
  // =============================
  Future<void> printReceipt(Map<String, dynamic> request) async {
    final response = await _dio.post(
      "/api/printer/receipt",
      data: request,
    );

    if (response.statusCode != 200) {
      throw Exception("خطأ أثناء طباعة الفاتورة (${response.statusCode}): ${response.data}");
    }
  }

  // =============================
  // Kitchen Receipt (/api/printer/kitchen)
  // =============================
  Future<void> printKitchen(Map<String, dynamic> request) async {
    final response = await _dio.post(
      "/api/printer/kitchen",
      data: request,
    );

    if (response.statusCode != 200) {
      throw Exception(" خطأ أثناء طباعة المطبخ (${response.statusCode}): ${response.data}");
    }
  }

  // =============================
  // End Shift Report (/api/printer/end-shift)
  // =============================
  Future<void> printEndShift(Map<String, dynamic> request) async {
    await _dio.post("/api/printer/end-shift", data: request);
  }

  // =============================
  // Daily Report (/api/printer/daily-report)
  // =============================
  Future<void> printDailyReport(Map<String, dynamic> request) async {
    await _dio.post("/api/printer/daily-report", data: request);
  }

  // =============================
  // Thermal Report (/api/printer/report)
  // =============================
  Future<void> printReport(Map<String, dynamic> request) async {
    await _dio.post("/api/printer/report", data: request);
  }

  // =============================
  // Barcode Print (/api/printer/barcode)
  // =============================
  Future<void> printBarcode(Map<String, dynamic> request) async {
    final response = await _dio.post(
      "/api/printer/barcode",
      data: request,
    );

    if (response.statusCode != 200) {
      throw Exception("خطأ أثناء طباعة الباركود (${response.statusCode}): ${response.data}");
    }
  }
}