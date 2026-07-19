import 'package:dio/dio.dart';

class ModuPrintService {
  static const String _baseUrl = "http://127.0.0.1:5089";

  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: _baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 20),
      headers: {
        "Content-Type": "application/json",
      },
    ),
  );

  // =============================
  // Get Installed Printers
  // =============================

  Future<List<dynamic>> getPrinters() async {
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
  // Print Receipt
  // =============================

  Future<void> printReceipt(
      Map<String, dynamic> request,
      ) async {
    await _dio.post(
      "/api/printer/receipt",
      data: request,
    );
  }

  // =============================
  // Kitchen Receipt
  // =============================

  Future<void> printKitchen(
      Map<String, dynamic> request,
      ) async {
    await _dio.post(
      "/api/printer/kitchen",
      data: request,
    );
  }

  // =============================
  // End Shift Report
  // =============================

  Future<void> printEndShift(
      Map<String, dynamic> request,
      ) async {
    await _dio.post(
      "/api/printer/end-shift",
      data: request,
    );
  }

  // =============================
  // Daily Report
  // =============================

  Future<void> printDailyReport(
      Map<String, dynamic> request,
      ) async {
    await _dio.post(
      "/api/printer/daily-report",
      data: request,
    );
  }
  // =============================
// Thermal Report
// =============================

  Future<void> printReport(
      Map<String, dynamic> request,
      ) async {
    await _dio.post(
      "/api/printer/report",
      data: request,
    );
  }
}