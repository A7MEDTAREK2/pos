// lib/feature/supplier/logic/inventory_state.dart

import '../data/model/supplier_model.dart';

abstract class SupplierState {
  const SupplierState();
}

class SupplierInitial extends SupplierState {}

class SupplierLoading extends SupplierState {}

class SupplierLoaded extends SupplierState {
  final List<SupplierModel> suppliers;

  const SupplierLoaded(this.suppliers);
}

class SupplierError extends SupplierState {
  final String message;

  const SupplierError(this.message);
}