import 'dart:io';

import 'package:intl/intl.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' as xlsio;

class ExcelExportService {
  Future<void> export({
    required String title,
    required List<String> headers,
    required List<List<String>> rows,
    required String fileName,
    DateTime? from,
    DateTime? to,
  }) async {
    final workbook = xlsio.Workbook();

    final sheet = workbook.worksheets[0];

    sheet.name = title;

    //======================
    // Title
    //======================

    sheet.getRangeByName('A1').setText("Modu POS");

    sheet.getRangeByName('A2').setText(title);

    sheet.getRangeByName('A3').setText(
      "تاريخ التصدير : ${DateFormat("dd/MM/yyyy hh:mm a").format(DateTime.now())}",
    );

    if (from != null && to != null) {
      sheet.getRangeByName('A4').setText(
        "الفترة : ${DateFormat("dd/MM/yyyy").format(from)} - ${DateFormat("dd/MM/yyyy").format(to)}",
      );
    }

    //======================
    // Header
    //======================

    final headerRow = 6;

    for (int i = 0; i < headers.length; i++) {
      final cell = sheet.getRangeByIndex(headerRow, i + 1);

      cell.setText(headers[i]);

      cell.cellStyle.bold = true;

      cell.cellStyle.backColor = '#2563EB';

      cell.cellStyle.fontColor = '#FFFFFF';

      cell.cellStyle.hAlign = xlsio.HAlignType.center;

      cell.cellStyle.vAlign = xlsio.VAlignType.center;
    }
    sheet
        .getRangeByIndex(
      headerRow,
      1,
      headerRow,
      headers.length,
    )
        .rowHeight = 28;

    //======================
// Data
//======================

    for (int r = 0; r < rows.length; r++) {
      for (int c = 0; c < rows[r].length; c++) {
        final cell = sheet.getRangeByIndex(
          headerRow + r + 1,
          c + 1,
        );

        final value = rows[r][c];

        final number = double.tryParse(value);

        if (number != null) {
          cell.setNumber(number);
          cell.numberFormat = '#,##0';
        } else {
          cell.setText(value);
        }

        cell.cellStyle.hAlign = xlsio.HAlignType.center;
        cell.cellStyle.vAlign = xlsio.VAlignType.center;

        cell.cellStyle.borders.all.lineStyle =
            xlsio.LineStyle.thin;

        if (r.isEven) {
          cell.cellStyle.backColor = '#F8FAFC';
        }
      }
    }

    //======================
    // Footer
    //======================

    final footerRow = headerRow + rows.length + 2;

    sheet
        .getRangeByIndex(footerRow, 1)
        .setText("عدد السجلات : ${rows.length}");

    sheet.getRangeByIndex(footerRow, 1).cellStyle.bold = true;

    //======================
    // Auto Fit
    //======================

    for (int i = 1; i <= headers.length; i++) {
      sheet.autoFitColumn(i);

      if (sheet.getRangeByIndex(1, i).columnWidth < 18) {
        sheet.getRangeByIndex(1, i).columnWidth = 18;
      }
    }

    for (int i = 1; i <= footerRow; i++) {
      sheet.autoFitRow(i);
    }

    //======================
    // Freeze Header
    //======================

    //sheet.freezePanes(headerRow + 1, 1);

    //======================
    // Save
    //======================
    sheet.enableSheetCalculations();
    final bytes = workbook.saveAsStream();

    workbook.dispose();

    final documents = await getApplicationDocumentsDirectory();

    final reportsDir = Directory(
      "${documents.path}/Modu POS/Reports",
    );

    if (!await reportsDir.exists()) {
      await reportsDir.create(recursive: true);
    }

    final finalName =
        "${fileName}_${DateFormat("yyyy-MM-dd_HH-mm").format(DateTime.now())}.xlsx";

    final file = File(
      "${reportsDir.path}/$finalName",
    );

    await file.writeAsBytes(bytes);

    await OpenFilex.open(file.path);
  }
}