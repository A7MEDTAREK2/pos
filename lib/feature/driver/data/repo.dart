
import 'localdata.dart';
import 'model_drive.dart';

class DriverRepository {
  final DriverLocalDataSource _localDataSource;

  DriverRepository(this._localDataSource);

  Future<List<DriverModel>> getDrivers() async {
    return await _localDataSource.getDrivers();
  }

  Future<List<DriverModel>> searchDrivers(String query) async {
    return await _localDataSource.searchDrivers(query);
  }

  Future<DriverModel?> getDriverById(int id) async {
    return await _localDataSource.getDriverById(id);
  }

  Future<DriverModel?> getDriverByName(String name) async {
    return await _localDataSource.getDriverByName(name);
  }

  Future<void> addDriver(DriverModel driver) async {
    await _localDataSource.insertDriver(driver);
  }

  Future<void> updateDriver(DriverModel driver) async {
    await _localDataSource.updateDriver(driver);
  }

  Future<void> deleteDriver(int id) async {
    await _localDataSource.deleteDriver(id);
  }
}