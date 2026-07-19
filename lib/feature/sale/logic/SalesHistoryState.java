// lib/feature/sales_history/presentation/cubit/sales_history_state.dart

import '../../data/model/sales_history_model.dart';

abstract class SalesHistoryState {}

class SalesHistoryInitial extends SalesHistoryState {}

class SalesHistoryLoading extends SalesHistoryState {}

class SalesHistorySuccess extends SalesHistoryState {
  final List<SalesHistoryModel> sales;
  final List<SalesHistoryModel> filteredSales; // للبحث
  final bool isSearching;

  SalesHistorySuccess({
    required this.sales,
    this.filteredSales = const [],
    this.isSearching = false,
  });

  List<SalesHistoryModel> get displaySales =>
      isSearching ? filteredSales : sales;

  double get totalSales =>
      displaySales.fold(0, (sum, sale) => sum + sale.total);

  int get totalOrders => displaySales.length;

  double get averageOrderValue =>
      totalOrders > 0 ? totalSales / totalOrders : 0;
}

class SalesHistoryError extends SalesHistoryState {
  final String message;

  SalesHistoryError({required this.message});
}

class SalesHistoryDeleteLoading extends SalesHistoryState {}

class SalesHistoryDeleteSuccess extends SalesHistoryState {
  final String message;

  SalesHistoryDeleteSuccess({required this.message});
}

class SalesHistoryDeleteError extends SalesHistoryState {
  final String message;

  SalesHistoryDeleteError({required this.message});
}

class SalesHistoryDetailsLoading extends SalesHistoryState {}

class SalesHistoryDetailsSuccess extends SalesHistoryState {
  final SalesHistoryModel sale;
  final List<SaleItemModel> items;

  SalesHistoryDetailsSuccess({
    required this.sale,
    required this.items,
  });
}

class SalesHistoryDetailsError extends SalesHistoryState {
  final String message;

  SalesHistoryDetailsError({required this.message});
}