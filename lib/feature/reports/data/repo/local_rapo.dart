import '../../../../core/service/printing/model/daily_closing_report_model.dart';
import '../data_source/local_data_source.dart';
import '../data_source/prudct_local_data_source.dart';
import '../model/product_report.dart';
import '../model/sale_detail_report.dart';
import '../model/sale_report_model.dart';


abstract class ReportsRepository {

  Future<List<ShiftProductModel>> getShiftProducts({
    required DateTime from,
    required DateTime to,
  });
  Future<List<SalesReportModel>> getSalesReport({
    required DateTime from,
    required DateTime to,
    String search,
    int limit,
    int offset,
  });
  Future<int> getSalesReportCount({
    required DateTime from,
    required DateTime to,
    String search,
  });
  Future<SaleDetailsModel?> getSaleDetails(int saleId);
}

class ReportsRepositoryImpl implements ReportsRepository {
  @override
  Future<List<ShiftProductModel>> getShiftProducts({
    required DateTime from,
    required DateTime to,
  }) {
    return localDataSource.getShiftProducts(
      from: from,
      to: to,
    );
  }
  final ReportsLocalDataSource localDataSource;

  ReportsRepositoryImpl({
    required this.localDataSource,
  });

  @override
  Future<List<SalesReportModel>> getSalesReport({
    required DateTime from,
    required DateTime to,
    String search = '',
    int limit = 20,
    int offset = 0,
  }) {
    return localDataSource.getSalesReport(
      from: from,
      to: to,
      search: search,
      limit: limit,
      offset: offset,
    );
  }
  @override
  Future<int> getSalesReportCount({
    required DateTime from,
    required DateTime to,
    String search = '',
  }) {
    return localDataSource.getSalesReportCount(
      from: from,
      to: to,
      search: search,
    );
  }
  @override
  Future<SaleDetailsModel?> getSaleDetails(int saleId) {
    return localDataSource.getSaleDetails(saleId);
  }

}


abstract class ProductReportRepository {

  Future<List<ProductReportModel>> getProductReport({
    required DateTime from,
    required DateTime to,
    String search,
    int limit,
    int offset,
  });

  Future<int> getProductReportCount({
    required DateTime from,
    required DateTime to,
    String search,
  });

}

class ProductReportRepositoryImpl
    implements ProductReportRepository {

  final ProductReportLocalDataSource localDataSource;

  ProductReportRepositoryImpl({
    required this.localDataSource,
  });

  @override
  Future<List<ProductReportModel>> getProductReport({
    required DateTime from,
    required DateTime to,
    String search='',
    int limit=20,
    int offset=0,
  }) {

    return localDataSource.getProductReport(
      from: from,
      to: to,
      search: search,
      limit: limit,
      offset: offset,
    );
  }

  @override
  Future<int> getProductReportCount({
    required DateTime from,
    required DateTime to,
    String search='',
  }) {

    return localDataSource.getProductReportCount(
      from: from,
      to: to,
      search: search,
    );
  }



}