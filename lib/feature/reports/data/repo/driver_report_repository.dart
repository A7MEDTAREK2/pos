import '../data_source/driver_report_local_data_source.dart';
import '../model/drive_model.dart'; // عدل المسار حسب مكان الـ DataSource

class DriverReportRepository {
  final DriverReportLocalDataSource localDataSource;

  DriverReportRepository({required this.localDataSource});

  Future<List<DriverReportModel>> fetchDriversReport({
    int limit = 10,
    int offset = 0,
  }) async {
    return await localDataSource.getDriversReport(limit: limit, offset: offset);
  }

  Future<int> fetchTotalDriversCount() async {
    return await localDataSource.getDriversCount();
  }
}