import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'report_document_builder.dart';

class PrintService {
  final ReportDocumentBuilder _builder = ReportDocumentBuilder();

  Future<void> printReport({
    required String title,
    required List<String> headers,
    required List<List<String>> rows,
    DateTime? from,
    DateTime? to,
  }) async {
    final pdf = await _builder.build(
      title: title,
      headers: headers,
      rows: rows,
      from: from,
      to: to,
    );

    await Printing.layoutPdf(
      name: title,
      onLayout: (_) async => pdf.save(),
    );
  }

  // ====== طباعة فاتورة نصية ======
  static Future<void> printTextReceipt(String receiptText) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.roll80,
        build: (_) {
          return pw.Center(
            child: pw.Text(
              receiptText,
              style: const pw.TextStyle(
                fontSize: 10,
              ),
              textAlign: pw.TextAlign.center,
            ),
          );
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (_) async => pdf.save(),
      name: "Receipt",
    );
  }

  // ====== طباعة فاتورة العميل ======
  static Future<void> printCustomerReceipt(String receiptText) async {
    await printTextReceipt(receiptText);
  }

  // ====== طباعة فاتورة المندوب ======
  static Future<void> printDeliveryReceipt(String deliveryText) async {
    await printTextReceipt(deliveryText);
  }

  // ====== طباعة الفواتير حسب نوع الطلب ======
  static Future<void> printOrderReceipts({
    required String customerReceipt,
    String? deliveryReceipt,
    required String orderType,
  }) async {
    // طباعة فاتورة العميل
    await printCustomerReceipt(customerReceipt);

    // إذا كان الطلب توصيل وموجود فاتورة المندوب، اطبعها
    if (orderType == 'delivery' && deliveryReceipt != null && deliveryReceipt.isNotEmpty) {
      // تأخير بسيط بين الطباعتين
      await Future.delayed(const Duration(milliseconds: 500));
      await printDeliveryReceipt(deliveryReceipt);
    }
  }

  // ====== طباعة فاتورة مباشرة ======
  static Future<void> printReceipt(String receiptText) async {
    await printTextReceipt(receiptText);
  }

  // ====== طباعة فاتورة المطبخ ======
  static Future<void> printKitchenTicket(String ticketText) async {
    await printTextReceipt(ticketText);
  }
}