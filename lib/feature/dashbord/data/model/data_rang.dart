class DateRangeModel {
  final DateTime from;
  final DateTime to;

  const DateRangeModel({
    required this.from,
    required this.to,
  });
}
enum DashboardFilter {
  today,
  week,
  month,
  year,
}