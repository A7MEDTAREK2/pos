import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home/core/data_mange/data_mange/repo.dart';
import 'package:home/core/data_mange/data_mange/state_mange.dart';

import '../../data_base/pos_database.dart';




class MaintenanceCubit extends Cubit<MaintenanceState> {
  final MaintenanceRepository repository;

  MaintenanceCubit(this.repository)
      : super(MaintenanceInitial());

  Future<void> backupDatabase() async {
    emit(MaintenanceLoading());

    final result = await repository.backupDatabase();

    if (result.success) {
      emit(MaintenanceSuccess(result.message));
    } else {
      emit(MaintenanceError(result.message));
    }
  }

  Future<void> restoreDatabase() async {
    emit(MaintenanceLoading());

    final result = await repository.restoreDatabase();
    await repository.closeDatabase();

    if (result.success) {
      emit(
        MaintenanceSuccess(
          "تم استرجاع النسخة الاحتياطية بنجاح\nسيتم إعادة تشغيل البرنامج...",
        ),
      );
    } else {
      emit(MaintenanceError(result.message));
    }
  }

  Future<void> deleteSales() async {
    emit(MaintenanceLoading());

    final result = await repository.deleteSales();

    if (result.success) {
      emit(MaintenanceSuccess(result.message));
    } else {
      emit(MaintenanceError(result.message));
    }
  }

  Future<void> deleteCustomers() async {
    emit(MaintenanceLoading());

    final result = await repository.deleteCustomers();

    if (result.success) {
      emit(MaintenanceSuccess(result.message));
    } else {
      emit(MaintenanceError(result.message));
    }
  }

  Future<void> deleteAllData() async {
    emit(MaintenanceLoading());

    final result = await repository.deleteAllData();

    if (result.success) {
      emit(MaintenanceSuccess(result.message));
    } else {
      emit(MaintenanceError(result.message));
    }
  }

  Future<void> restartShift() async {
    emit(MaintenanceLoading());

    final result = await repository.restartShift();

    if (result.success) {
      emit(MaintenanceSuccess(result.message));
    } else {
      emit(MaintenanceError(result.message));
    }
  }

  Future<void> closeDatabase() async {
    await repository.closeDatabase();
  }
}

