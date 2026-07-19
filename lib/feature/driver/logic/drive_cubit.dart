import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/model_drive.dart';
import '../data/repo.dart';
import 'drive_state.dart';

class DriverCubit extends Cubit<DriverState> {
  final DriverRepository _repository;
  List<DriverModel> _drivers = [];

  DriverCubit(this._repository) : super(DriverInitial());

  List<DriverModel> get drivers => _drivers;

  Future<void> loadDrivers() async {
    try {
      emit(DriverLoading());
      _drivers = await _repository.getDrivers();
      emit(DriversLoaded(_drivers));
    } catch (e) {
      emit(DriverError(e.toString()));
    }
  }

  Future<void> searchDrivers(String query) async {
    try {
      emit(DriverLoading());
      _drivers = await _repository.searchDrivers(query);
      emit(DriversLoaded(_drivers));
    } catch (e) {
      emit(DriverError(e.toString()));
    }
  }

  Future<void> addDriver(DriverModel driver) async {
    try {
      emit(DriverOperationLoading());
      await _repository.addDriver(driver);
      await loadDrivers();
      emit(DriverOperationSuccess('تم إضافة المندوب بنجاح'));
    } catch (e) {
      emit(DriverError(e.toString()));
    }
  }

  Future<void> updateDriver(DriverModel driver) async {
    try {
      emit(DriverOperationLoading());
      await _repository.updateDriver(driver);
      await loadDrivers();
      emit(DriverOperationSuccess('تم تحديث المندوب بنجاح'));
    } catch (e) {
      emit(DriverError(e.toString()));
    }
  }

  Future<void> deleteDriver(int id) async {
    try {
      emit(DriverOperationLoading());
      await _repository.deleteDriver(id);
      await loadDrivers();
      emit(DriverOperationSuccess('تم حذف المندوب بنجاح'));
    } catch (e) {
      emit(DriverError(e.toString()));
    }
  }
}