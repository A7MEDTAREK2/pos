import 'package:equatable/equatable.dart';

import '../data/model/purchase_item_model.dart';
import '../data/model/purchase_model.dart';
import '../data/model/purchase_product_model.dart';

abstract class PurchaseState extends Equatable {
  const PurchaseState();

  @override
  List<Object?> get props => [];
}

// =========================================================
// Initial
// =========================================================

class PurchaseInitial extends PurchaseState {}

// =========================================================
// Loading
// =========================================================

class PurchaseLoading extends PurchaseState {}

// =========================================================
// Loaded
// =========================================================

class PurchaseLoaded extends PurchaseState {
  final List<PurchaseModel> purchases;

  /// المنتجات الخاصة بالمشتريات فقط
  final List<PurchaseProductModel> purchaseProducts;

  /// الموردين
  final List<Map<String, dynamic>> suppliers;

  /// المنتجات الموجودة حاليًا في فاتورة الشراء
  final List<PurchaseItemModel> items;

  final int? selectedSupplierId;
  final String selectedSupplierName;

  final double discount;
  final String paymentMethod;

  const PurchaseLoaded({
    required this.purchases,
    required this.purchaseProducts,
    required this.suppliers,
    required this.items,
    required this.selectedSupplierId,
    required this.selectedSupplierName,
    required this.discount,
    required this.paymentMethod,
  });

  // =========================================================
  // Financial Calculations
  // =========================================================

  double get subtotal {
    return items.fold(
      0,
          (sum, item) => sum + item.total,
    );
  }

  double get total {
    final value = subtotal - discount;

    return value < 0 ? 0 : value;
  }

  // =========================================================
  // Equatable
  // =========================================================

  @override
  List<Object?> get props => [
    purchases,
    purchaseProducts,
    suppliers,
    items,
    selectedSupplierId,
    selectedSupplierName,
    discount,
    paymentMethod,
  ];
}

// =========================================================
// Saving
// =========================================================

class PurchaseSaving extends PurchaseState {}

// =========================================================
// Saved
// =========================================================

class PurchaseSaved extends PurchaseState {
  final int purchaseId;

  const PurchaseSaved(this.purchaseId);

  @override
  List<Object?> get props => [
    purchaseId,
  ];
}

// =========================================================
// Error
// =========================================================

class PurchaseError extends PurchaseState {
  final String message;

  const PurchaseError(this.message);

  @override
  List<Object?> get props => [
    message,
  ];
}