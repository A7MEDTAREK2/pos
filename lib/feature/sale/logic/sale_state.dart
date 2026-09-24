import 'package:equatable/equatable.dart';
import '../data/model/sale_model.dart';

abstract class SalesHistoryState extends Equatable {
  const SalesHistoryState();

  @override
  List<Object?> get props => [];
}

class SalesHistoryInitial extends SalesHistoryState {}

class SalesHistoryLoading extends SalesHistoryState {}

class SalesHistorySuccess extends SalesHistoryState {
  final List<SalesHistoryModel> sales;
  final bool isSearching;
  final List<SalesHistoryModel> filteredSales;
  final String? successMessage;
  final String? errorMessage;

  const SalesHistorySuccess({
    required this.sales,
    this.filteredSales = const [],
    this.isSearching = false,
    this.successMessage,
    this.errorMessage,
  });

  List<SalesHistoryModel> get displaySales =>
      isSearching ? filteredSales : sales;

  // ✅ التعديل هنا: استخدام subtotal بدلاً من total عشان يحسب صافي المنتجات فقط بدون الدليفري
  double get totalSales =>
      displaySales.fold(0.0, (sum, e) => sum + (e.subtotal ?? 0.0));

  int get totalOrders => displaySales.length;

  double get averageOrderValue =>
      totalOrders == 0 ? 0 : totalSales / totalOrders;

  SalesHistorySuccess copyWith({
    List<SalesHistoryModel>? sales,
    List<SalesHistoryModel>? filteredSales,
    bool? isSearching,
    String? successMessage,
    String? errorMessage,
  }) {
    return SalesHistorySuccess(
      sales: sales ?? this.sales,
      filteredSales: filteredSales ?? this.filteredSales,
      isSearching: isSearching ?? this.isSearching,
      successMessage: successMessage,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    sales,
    filteredSales,
    isSearching,
    successMessage,
    errorMessage,
  ];
}

class SalesHistoryError extends SalesHistoryState {
  final String message;

  const SalesHistoryError(this.message);

  @override
  List<Object?> get props => [message];
}

class SalesDeleteLoading extends SalesHistoryState {}

class SalesReopenLoading extends SalesHistoryState {}

class SalesPrintLoading extends SalesHistoryState {}