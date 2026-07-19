import 'dart:io';

import 'package:intl/intl.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';

import 'report_document_builder.dart';

class PdfExportService {
  final ReportDocumentBuilder _builder = ReportDocumentBuilder();

  Future<void> export({
    required String title,
    required String fileName,
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

    final now = DateTime.now();

    final documents = await getApplicationDocumentsDirectory();

    final reportsDir = Directory(
      "${documents.path}/Modu POS/Reports",
    );

    if (!await reportsDir.exists()) {
      await reportsDir.create(recursive: true);
    }

    final fileNameWithDate =
        "${fileName}_${DateFormat("yyyy-MM-dd_HH-mm").format(now)}.pdf";

    final file = File(
      "${reportsDir.path}/$fileNameWithDate",
    );

    await file.writeAsBytes(
      await pdf.save(),
    );

    await OpenFilex.open(file.path);
  }
}