import '../data_source/stock_local_data_source.dart';
import '../model/stock.dart';

abstract class StockReportRepository {
  Future<List<StockReportModel>> getStockReport({
    required String search,
    required int limit,
    required int offset,
  });

  Future<int> getStockReportCount({
    required String search,
  });
}

class StockReportRepositoryImpl
    implements StockReportRepository {

  final StockReportLocalDataSource localDataSource;

  StockReportRepositoryImpl({
    required this.localDataSource,
  });

  @override
  Future<List<StockReportModel>> getStockReport({
    required String search,
    required int limit,
    required int offset,
  }) {
    return localDataSource.getStockReport(
      search: search,
      limit: limit,
      offset: offset,
    );
  }

  @override
  Future<int> getStockReportCount({
    required String search,
  }) {
    return localDataSource.getStockReportCount(
      search: search,
    );
  }
}