// lib/core/service/printing/service/printing_manager.dart

import 'dart:async';
import 'dart:convert';
import 'package:home/core/service/printing/service/modu_print_service.dart';
import 'package:home/core/service/printing/service/print_queue_local.dart';
import 'package:home/core/service/printing/service/print_queue_repository.dart';
import '../../../../feature/cashier/data/model/pos_model.dart';
import '../../../../feature/setting/data/datasorce/local_data.dart';
import '../../../../feature/setting/data/model/settings_model.dart';
import '../export/report_export_model.dart';
import 'mapper/receipt_mapper.dart';
import 'model/print_queue_model.dart';

bool _isRetrying = false;

class PrintingManager {
  PrintingManager._();
  Timer? _timer;

  void stopRetryService() {
    _timer?.cancel();
  }

  void dispose() {
    _timer?.cancel();
  }

  static final PrintingManager instance = PrintingManager._();

  final ModuPrintService _service = ModuPrintService();
  final SettingsLocalDataSource _settingsDataSource = SettingsLocalDataSourceImpl();

  final PrintQueueRepository _queueRepository = PrintQueueRepository(
    PrintQueueLocalDataSource(),
  );

  // 🎯 جلب الإعدادات الحالية من قاعدة البيانات محلياً
  Future<SettingsModel?> _getSettings() async {
    try {
      return await _settingsDataSource.getSettings();
    } catch (_) {
      return null;
    }
  }

  Future<void> _savePrintJob({
    required String type,
    required Map<String, dynamic> payload,
  }) async {
    await _queueRepository.addJob(
      PrintQueueModel(
        type: type,
        payload: jsonEncode(payload),
        createdAt: DateTime.now().toIso8601String(),
      ),
    );
  }

  // =============================
  // KITCHEN PRINT
  // =============================
  Future<void> printKitchen(OrderModel order) async {
    final settings = await _getSettings();

    // 🔍 التحقق من اسم طابعة المطبخ وتجاوز "طابعة 1" إن وجدت
    String printerName = settings?.kitchenPrinter ?? "";
    if (printerName.isEmpty || printerName == "طابعة 1") {
      printerName = "XP-80C";
    }

    print("🔍 طابعة المطبخ المُستخدمة: $printerName");

    final int paperWidth = settings?.paperWidth ?? 80;

    if (printerName.isEmpty) return;

    final Map<String, List<Map<String, dynamic>>> groupedItems = {};

    for (final e in order.items) {
      final quantity = int.tryParse(e["quantity"].toString()) ?? 0;
      final price = double.tryParse(e["price"].toString()) ?? 0.0;

      final category = e["categoryName"]?.toString() ??
          e["category"]?.toString() ??
          "General";

      groupedItems.putIfAbsent(category, () => []);

      groupedItems[category]!.add({
        "name": e["name"].toString(),
        "qty": quantity,
        "price": price,
        "total": price * quantity,
        "size": e["size"]?.toString() ?? "",
        "note": e["note"]?.toString() ?? "",
      });
    }

    for (final entry in groupedItems.entries) {
      final department = entry.key;
      final items = entry.value;

      // 🎯 الاعتماد على ReceiptMapper لتوليد الـ Payload الخاص بالمطبخ
      final requestData = ReceiptMapper.toKitchenPayload(
        order: order,
        settings: settings,
        printerName: printerName,
        department: department,
        items: items,
      );

      try {
        await _service.printKitchen(requestData);
      } catch (e) {
        await _savePrintJob(
          type: "kitchen",
          payload: requestData,
        );
        print("❌ Kitchen Print Failed: $e");
      }
    }
  }

  // =============================
  // RECEIPT PRINT (مع التنسيقات الكاملة للسيرفر)
  // =============================
  Future<void> printReceipt(OrderModel order) async {
    final settings = await _getSettings();

    // 🔍 التحقق من اسم طابعة الكاشير وتجاوز "طابعة 1" إن وجدت
    String printerName = settings?.cashierPrinter ?? "";
    if (printerName.isEmpty || printerName == "طابعة 1") {
      printerName = "XP-80C";
    }

    print("🔍 طابعة الكاشير المُستخدمة: $printerName");

    if (printerName.isEmpty) return;

    // 🎯 الاعتماد على ReceiptMapper لتوليد الـ Payload الخاص بالكاشير
    final requestData = ReceiptMapper.toCashierPayload(
      order: order,
      settings: settings,
      printerName: printerName,
    );

    try {
      await _service.printReceipt(requestData);
    } catch (e) {
      await _savePrintJob(
        type: "receipt",
        payload: requestData,
      );
      print("❌ Receipt Print Failed: $e");
    }
  }

  // =============================
  // BARCODE PRINT (جديد للربط مع السيرفر)
  // =============================
  Future<void> printBarcode({
    required String itemName,
    required double price,
    required String barcodeValue,
    String barcodeSize = "رول 38 * 25",
  }) async {
    final settings = await _getSettings();

    final String printerName = settings?.barcodePrinter ?? settings?.cashierPrinter ?? "XP-80C";

    final requestData = {
      "printerName": printerName,
      "barcodeSize": barcodeSize,
      "itemName": itemName,
      "price": price,
      "barcodeValue": barcodeValue,
      "titleStyle": {
        "font": "Arial (Arabic)",
        "size": 12,
        "bold": true,
        "italic": false,
        "underline": false,
      },
      "displayOptions": {
        "showBarcodeValue": true,
        "showBarcodeTitle": true,
        "showPrice": true,
        "showItemName": true,
      }
    };

    try {
      await _service.printBarcode(requestData);
    } catch (e) {
      await _savePrintJob(
        type: "barcode",
        payload: requestData,
      );
      print("❌ Barcode Print Failed: $e");
    }
  }

  // =============================
  // DAILY REPORT PRINT
  // =============================
  Future<void> printDailyReport({
    required String storeName,
    required String cashier,
    required int ordersCount,
    required double subTotal,
    required double discount,
    required double tax,
    required double delivery,
    required double netSales,
    required Map<String, dynamic> paymentSummary,
    required List<Map<String, dynamic>> products,
  }) async {
    final settings = await _getSettings();

    final String printerName = settings?.reportsPrinter ?? settings?.cashierPrinter ?? "XP-80C";
    final int paperWidth = settings?.paperWidth ?? 80;

    final requestData = {
      "printerName": printerName,
      "paperWidth": paperWidth,
      "storeName": settings?.storeName ?? storeName,
      "cashier": cashier,
      "reportDate": DateTime.now().toIso8601String(),
      "ordersCount": ordersCount,
      "subTotal": subTotal,
      "discount": discount,
      "tax": tax,
      "delivery": delivery,
      "netSales": netSales,
      "paymentSummary": paymentSummary,
      "products": products,
    };

    try {
      await _service.printDailyReport(requestData);
    } catch (e) {
      await _savePrintJob(
        type: "daily_report",
        payload: requestData,
      );
      print("❌ Daily Report Print Failed: $e");
    }
  }

  // =============================
  // THERMAL REPORT PRINT
  // =============================
  Future<void> printReport(ReportExportModel report) async {
    final settings = await _getSettings();

    final String printerName = settings?.reportsPrinter ?? settings?.cashierPrinter ?? "XP-80C";
    final int paperWidth = settings?.paperWidth ?? 80;

    final request = {
      "printerName": printerName,
      "paperWidth": paperWidth,
      "title": report.title,
      "from": report.from?.toIso8601String(),
      "to": report.to?.toIso8601String(),
      "headers": report.headers,
      "rows": report.rows,
    };

    try {
      await _service.printReport(request);
    } catch (e) {
      await _savePrintJob(
        type: "report",
        payload: request,
      );
      print("❌ Report Print Failed: $e");
    }
  }

  // =============================
  // QUEUE RETRY WORKER
  // =============================
  void startQueueWorker() {
    _timer?.cancel();

    _timer = Timer.periodic(
      const Duration(seconds: 30),
          (_) async {
        if (_isRetrying) return;
        _isRetrying = true;

        try {
          await _queueRepository.retryPendingJobs(
                (job) async {
              final payload = jsonDecode(job.payload) as Map<String, dynamic>;

              switch (job.type) {
                case "receipt":
                  await _service.printReceipt(payload);
                  break;
                case "kitchen":
                  await _service.printKitchen(payload);
                  break;
                case "barcode":
                  await _service.printBarcode(payload);
                  break;
                case "daily_report":
                  await _service.printDailyReport(payload);
                  break;
                case "report":
                  await _service.printReport(payload);
                  break;
              }
            },
          );
        } finally {
          _isRetrying = false;
        }
      },
    );
  }

  Future<void> retryPendingJobs() async {
    if (_isRetrying) return;
    _isRetrying = true;

    try {
      await _queueRepository.retryPendingJobs((job) async {
        final payload = jsonDecode(job.payload) as Map<String, dynamic>;

        switch (job.type) {
          case "receipt":
            await _service.printReceipt(payload);
            break;
          case "kitchen":
            await _service.printKitchen(payload);
            break;
          case "barcode":
            await _service.printBarcode(payload);
            break;
          case "daily_report":
            await _service.printDailyReport(payload);
            break;
          case "report":
            await _service.printReport(payload);
            break;
          default:
            throw Exception("Unknown print type");
        }
      });
    } finally {
      _isRetrying = false;
    }
  }
}