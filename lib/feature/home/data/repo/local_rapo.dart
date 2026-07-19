import '../data_source/local_data_source.dart';
import '../model/home_model.dart';

class HomeRepository {
  final HomeLocalDataSource _dataSource;

  HomeRepository(this._dataSource);

  Future<HomeMetricsModel> getHomeMetrics() async {
    final rawData = await _dataSource.getRawMetrics();
    return HomeMetricsModel.fromMap(rawData);
  }
}