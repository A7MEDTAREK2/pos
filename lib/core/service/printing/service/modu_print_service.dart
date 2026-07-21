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
    ),
  );

  // =============================
  // Get Installed Printers
  // =============================

  Future<List<dynamic>> getPrinters() async {
    print("HTTP PRINTER LIST REQUEST");
    final response = await _dio.get("/api/printer/list");
    return response.data;
  }

  // =============================
  // Printer Status
  // =============================

  Future<Map<String, dynamic>> getStatus() async {
    final response = await _dio.get("/api/printer/status");
    return Map<String, dynamic>.from(response.data);
  }

  // =============================
  // Test Print
  // =============================

  Future<void> testPrint({
    required String printerName,
    int paperWidth = 58,
  }) async {
    await _dio.post(
      "/api/printer/test",
      data: {
        "printerName": printerName,
        "paperWidth": paperWidth,
      },
    );
  }

  // =============================
  // Open Drawer
  // =============================

  Future<void> openDrawer({
    required String printerName,
  }) async {
    await _dio.post(
      "/api/printer/open-drawer",
      data: {
        "printerName": printerName,
      },
    );
  }

  // =============================
  // Print Receipt (معالجة ذكية للـ Timeout)
  // =============================

  Future<void> printReceipt(Map<String, dynamic> request) async {
    print("➡️ Before POST /api/printer/receipt");

    try {
      final response = await _dio.post(
        "/api/printer/receipt",
        data: request,
      );

      print("✅ After POST Success");
      print("Status Code: ${response.statusCode}");
      print("Response Data: ${response.data}");
    } on DioException catch (e) {
      print("❌ Dio Error on Receipt Print");
      print("Error Type: ${e.type}");
      print("Error Message: ${e.message}");

      if (e.type == DioExceptionType.receiveTimeout) {
        // إذا كان الخطأ مجرد تأخر استجابة ولكن السيرفر نفذ الطباعة
        print("⚠️ Warning: Receive timeout reached, but print job was dispatched.");
      }

      // إعادة الـ Exception ليتعامل معها الـ UI إذا لزم الأمر
      rethrow;
    }
  }

  // =============================
  // Kitchen Receipt
  // =============================

  Future<void> printKitchen(Map<String, dynamic> request) async {
    await _dio.post(
      "/api/printer/kitchen",
      data: request,
    );
  }

  // =============================
  // End Shift Report
  // =============================

  Future<void> printEndShift(Map<String, dynamic> request) async {
    await _dio.post(
      "/api/printer/end-shift",
      data: request,
    );
  }

  // =============================
  // Daily Report
  // =============================

  Future<void> printDailyReport(Map<String, dynamic> request) async {
    await _dio.post(
      "/api/printer/daily-report",
      data: request,
    );
  }

  // =============================
  // Thermal Report
  // =============================

  Future<void> printReport(Map<String, dynamic> request) async {
    await _dio.post(
      "/api/printer/report",
      data: request,
    );
  }
}