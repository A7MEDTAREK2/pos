abstract class ExportService {
  Future<void> exportPdf({
    required String title,
    required List<String> headers,
    required List<List<String>> rows,
    required String fileName,
  });

  Future<void> exportExcel({
    required String title,
    required List<String> headers,
    required List<List<String>> rows,
    required String fileName,
  });

  Future<void> print({
    required String title,
    required List<String> headers,
    required List<List<String>> rows,
  });
}