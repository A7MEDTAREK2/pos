import '../../../../core/service/audit_log_service.dart';
import '../data_source/stock_local_data_source.dart';
import '../model/stock.dart';

abstract class StockReportRepository {
  Future<List<StockReportModel>> getStockReport({
    String search = '',
    int limit = 20,
    int offset = 0,
  });

  Future<int> getStockReportCount({
    String search = '',
  });
}

class StockReportRepositoryImpl implements StockReportRepository {
  final StockReportLocalDataSource localDataSource;

  StockReportRepositoryImpl({
    required this.localDataSource,
  });

  @override
  Future<List<StockReportModel>> getStockReport({
    String search = '',
    int limit = 20,
    int offset = 0,
  }) async {
    final result = await localDataSource.getStockReport(
      search: search,
      limit: limit,
      offset: offset,
    );

    await AuditLogService.instance.log(
      userId: 1,
      userName: 'مشرف النظام',
      action: 'VIEW',
      module: 'التقارير',
      entityType: 'StockReport',
      description: 'تم فتح تقرير جرد المخزن',
    );

    return result;
  }

  @override
  Future<int> getStockReportCount({
    String search = '',
  }) {
    return localDataSource.getStockReportCount(
      search: search,
    );
  }
}