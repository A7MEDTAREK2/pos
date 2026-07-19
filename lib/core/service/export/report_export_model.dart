class ReportExportModel {
  final String title;
  final String fileName;
  final List<String> headers;
  final List<List<String>> rows;


  final DateTime? from;
  final DateTime? to;

  const ReportExportModel({
    required this.title,
    required this.fileName,
    required this.headers,
    required this.rows,

    this.from,
    this.to,
  });
}