import 'exel_export_service.dart';
import 'pdf_export_service.dart';
import 'print_service.dart';
import 'report_export_model.dart';

class ReportExportService {
  final PdfExportService _pdf = PdfExportService();
  final ExcelExportService _excel = ExcelExportService();
  final PrintService _printer = PrintService();

  Future<void> exportPdf(ReportExportModel model) {
    return _pdf.export(
      title: model.title,
      fileName: model.fileName,
      headers: model.headers,
      rows: model.rows,
      from: model.from,
      to: model.to,

    );
  }

  Future<void> exportExcel(ReportExportModel model) {
    return _excel.export(
      title: model.title,
      fileName: model.fileName,
      headers: model.headers,
      rows: model.rows,
    );
  }

  Future<void> print(ReportExportModel model) {
    return _printer.printReport(
      title: model.title,
      headers: model.headers,
      rows: model.rows,
      from: model.from,
      to: model.to,
    );
  }
}