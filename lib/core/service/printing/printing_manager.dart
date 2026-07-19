import 'dart:async';
import 'dart:convert';
import 'package:home/core/service/printing/service/modu_print_service.dart';
import 'package:home/core/service/printing/service/print_queue_local.dart';
import 'package:home/core/service/printing/service/print_queue_repository.dart';
import '../../../feature/cashier/data/model/pos_model.dart';
import '../export/report_export_model.dart';
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
  final PrintQueueRepository _queueRepository =
  PrintQueueRepository(
    PrintQueueLocalDataSource(),
  );
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

  String printerName = "XP-80C";

  Future<void> printKitchen(OrderModel order) async {
    if (printerName.isEmpty) return;

    final Map<String, List<Map<String, dynamic>>> groupedItems = {};

    for (final e in order.items) {
      final quantity = int.tryParse(e["quantity"].toString()) ?? 0;
      final price = double.tryParse(e["price"].toString()) ?? 0.0;

      final category =
          e["categoryName"]?.toString() ??
              e["category"]?.toString() ??
              "General";

      groupedItems.putIfAbsent(category, () => []);
      print("PRODUCT: ${e["name"]}");
      print("CATEGORY: $category");

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
      print("PRINT DEPARTMENT => ${entry.key}");
      final department = entry.key;
      final items = entry.value;

      final requestData = {
        "printerName": printerName,
        "paperWidth": 80,
        "invoiceNumber": order.orderNumber,
        "date": order.createdAt.toIso8601String(),
        "orderType": order.orderType.name,
        "tableNumber": order.tableNumber ?? "",
        "customerName": order.customerName ?? "",
        "deliveryAddress": order.customerAddress ?? "",
        "cashier": "Admin",

        // الجديد
        "department": department,

        "items": items,
      };

      print("📤 Kitchen [$department]");
      print(jsonEncode(requestData));

      try {
        print("Start Kitchen Request");
        await _service.printKitchen(requestData);
        print("Kitchen Request Finished");
      } catch (e) {
        await _savePrintJob(
          type: "kitchen",
          payload: requestData,
        );

        print("❌ Kitchen Print Failed");
        print(e);
      }
    }
  }

  Future<void> printReceipt(OrderModel order) async {
    if (printerName.isEmpty) return;

    final products = order.items.map((e) {
      final price = (e["price"] as num).toDouble();
      final quantity = (e["quantity"] as num).toInt();

      return {
        "name": e["name"].toString(),
        "qty": quantity,
        "size": e["size"]?.toString() ?? "", // ✅ أضفنا الحجم
        "note": e["note"]?.toString() ?? "",
        "price": price,
        "total": price * quantity,
      };
    }).toList();

    final requestData = {
      "printerName": printerName,
      "paperWidth": 80,
      "storeName": "Modu POS",
      "invoiceNumber": order.orderNumber,
      "date": order.createdAt.toIso8601String(),
      "cashier": "Admin",
      "customerName": order.customerName ?? "",
      "customerPhone": order.customerPhone ?? "",
      "orderType": order.orderType.name,
      "paymentMethod": order.paymentMethod ?? "Cash",

      // ✅ رجعناها products
      "products": products,

      "subTotal": (order.subtotal ?? order.totalAmount).toDouble(),
      "discount": (order.discount ?? 0).toDouble(),
      "tax": (order.tax ?? 0).toDouble(),
      "delivery": (order.deliveryFee ?? 0).toDouble(),
      "grandTotal": order.totalAmount.toDouble(),
      "footer": "م / أحمد طارق",
    };

    print("📤 Receipt JSON: ${jsonEncode(requestData)}");

    try {
      print("Start Receipt Request");
      await _service.printReceipt(requestData);
      print("Receipt Request Finished");
    } catch (e) {
      await _savePrintJob(
        type: "receipt",
        payload: requestData,
      );

      print("❌ Receipt Print Failed");
      print(e);
    }
  }
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

    final requestData = {
      "printerName": printerName,
      "paperWidth": 80,

      "storeName": storeName,
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

    print("📤 Daily Report");
    print(requestData);

    try {
      await _service.printDailyReport(requestData);
    } catch (e) {
      await _savePrintJob(
        type: "daily_report",
        payload: requestData,
      );

      print("❌ Daily Report Print Failed");
      print(e);
    }
  }
  Future<void> printReport(
      ReportExportModel report,
      ) async {

    final request = {

      "printerName": printerName,
      "paperWidth":80,

      "title":report.title,

      "from":report.from?.toIso8601String(),
      "to":report.to?.toIso8601String(),

      "headers":report.headers,

      "rows":report.rows,

    };


    try {
      await _service.printReport(request);
    } catch (e) {
      await _savePrintJob(
        type: "report",
        payload: request,
      );

      print("❌ Report Print Failed");
      print(e);
    }
  }


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
              final payload =
              jsonDecode(job.payload) as Map<String, dynamic>;

              switch (job.type) {
                case "receipt":
                  await _service.printReceipt(payload);
                  break;

                case "kitchen":
                  await _service.printKitchen(payload);
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