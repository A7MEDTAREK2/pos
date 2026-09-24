// lib/feature/supplier/logic/inventory_cubit.dart

import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/model/supplier_model.dart';
import '../data/repo/local_repo.dart';
import 'supplier_state.dart';

class SupplierCubit extends Cubit<SupplierState> {
  final SupplierRepository repository;

  SupplierCubit(this.repository) : super(SupplierInitial());

  List<SupplierModel> suppliers = [];

  Future<void> loadSuppliers() async {
    try {
      emit(SupplierLoading());

      suppliers = await repository.getSuppliers();

      emit(SupplierLoaded(List.unmodifiable(suppliers)));
    } catch (e) {
      emit(
        SupplierError(
          'حدث خطأ أثناء تحميل الموردين: $e',
        ),
      );
    }
  }

  Future<void> searchSuppliers(String keyword) async {
    try {
      if (keyword.trim().isEmpty) {
        await loadSuppliers();
        return;
      }

      final result = await repository.searchSuppliers(
        keyword.trim(),
      );

      emit(SupplierLoaded(result));
    } catch (e) {
      emit(
        SupplierError(
          'حدث خطأ أثناء البحث: $e',
        ),
      );
    }
  }

  Future<void> addSupplier({
    required String name,
    String phone = '',
    String address = '',
    String notes = '',
  }) async {
    try {
      final supplier = SupplierModel(
        name: name.trim(),
        phone: phone.trim(),
        address: address.trim(),
        notes: notes.trim(),
        isActive: true,
        createdAt: DateTime.now().toIso8601String(),
      );

      await repository.addSupplier(supplier);

      await loadSuppliers();
    } catch (e) {
      emit(
        SupplierError(
          'حدث خطأ أثناء إضافة المورد: $e',
        ),
      );
    }
  }

  Future<void> updateSupplier(SupplierModel supplier) async {
    try {
      await repository.updateSupplier(supplier);

      await loadSuppliers();
    } catch (e) {
      emit(
        SupplierError(
          'حدث خطأ أثناء تعديل المورد: $e',
        ),
      );
    }
  }

  Future<void> deleteSupplier(int id) async {
    try {
      await repository.deleteSupplier(id);

      await loadSuppliers();
    } catch (e) {
      emit(
        SupplierError(
          'حدث خطأ أثناء حذف المورد: $e',
        ),
      );
    }
  }

  Future<void> toggleSupplierStatus(
      SupplierModel supplier,
      ) async {
    try {
      await repository.toggleSupplierStatus(
        supplier.id!,
        !supplier.isActive,
      );

      await loadSuppliers();
    } catch (e) {
      emit(
        SupplierError(
          'حدث خطأ أثناء تغيير حالة المورد: $e',
        ),
      );
    }
  }
}