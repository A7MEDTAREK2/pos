import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class ReportDocumentBuilder {
  Future<pw.Document> build({
    required String title,
    required List<String> headers,
    required List<List<String>> rows,
    DateTime? from,
    DateTime? to,
  }) async {
    final font = pw.Font.ttf(
      await rootBundle.load("assets/fonts/hacen.ttf"),
    );

    final pdf = pw.Document();

    final now = DateTime.now();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4.landscape,
        margin: const pw.EdgeInsets.all(24),
        theme: pw.ThemeData.withFont(
          base: font,
          bold: font,
        ),

        header: (context) {
          return pw.Container(
            padding: const pw.EdgeInsets.only(bottom: 15),
            decoration: const pw.BoxDecoration(
              border: pw.Border(
                bottom: pw.BorderSide(color: PdfColors.grey400),
              ),
            ),
            child: pw.Directionality(
              textDirection: pw.TextDirection.rtl,
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.stretch,
                children: [
                  pw.Center(
                    child: pw.Text(
                      "Modu POS",
                      style: pw.TextStyle(
                        font: font,
                        fontSize: 22,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  ),
                  pw.SizedBox(height: 6),
                  pw.Center(
                    child: pw.Text(
                      title,
                      style: pw.TextStyle(
                        font: font,
                        fontSize: 18,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  ),
                  pw.SizedBox(height: 15),
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text(
                        "تاريخ التصدير : ${DateFormat("dd/MM/yyyy hh:mm a").format(now)}",
                        style: pw.TextStyle(font: font),
                      ),
                      if (from != null && to != null)
                        pw.Text(
                          "الفترة : ${DateFormat("dd/MM/yyyy").format(from)} - ${DateFormat("dd/MM/yyyy").format(to)}",
                          style: pw.TextStyle(font: font),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },

        footer: (context) {
          return pw.Container(
            margin: const pw.EdgeInsets.only(top: 12),
            decoration: const pw.BoxDecoration(
              border: pw.Border(
                top: pw.BorderSide(color: PdfColors.grey400),
              ),
            ),
            padding: const pw.EdgeInsets.only(top: 8),
            child: pw.Directionality(
              textDirection: pw.TextDirection.rtl,
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text(
                    "عدد السجلات : ${rows.length}",
                    style: pw.TextStyle(font: font),
                  ),
                  pw.Text(
                    "الصفحة ${context.pageNumber} / ${context.pagesCount}",
                    style: pw.TextStyle(font: font),
                  ),
                ],
              ),
            ),
          );
        },

        build: (_) => [
          pw.Directionality(
            textDirection: pw.TextDirection.rtl,
            child: pw.Table.fromTextArray(
              headers: headers,
              data: rows,
              headerDecoration:
              const pw.BoxDecoration(color: PdfColors.blue100),
              headerStyle: pw.TextStyle(
                font: font,
                fontWeight: pw.FontWeight.bold,
              ),
              cellStyle: pw.TextStyle(
                font: font,
                fontSize: 11,
              ),
              cellAlignment: pw.Alignment.center,
              border: pw.TableBorder.all(
                color: PdfColors.grey400,
              ),
            ),
          ),
        ],
      ),
    );

    return pdf;
  }
}