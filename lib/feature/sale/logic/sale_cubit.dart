import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/model/sale_model.dart';
import '../data/repo/local_rapo.dart';
import 'sale_state.dart';

class SalesHistoryCubit extends Cubit<SalesHistoryState> {
  final SalesHistoryRepository repository;
  SalesHistoryModel? selectedSale;
  List<SaleItemModel> selectedItems = [];

  SalesHistoryCubit({
    required this.repository,
  }) : super(SalesHistoryInitial());

  // =========================
  // Load Sales
  // =========================

  Future<void> loadSales() async {
    emit(SalesHistoryLoading());

    try {
      final sales = await repository.getSales();

      emit(
        SalesHistorySuccess(
          sales: sales,
        ),
      );
    } catch (e) {
      emit(
        SalesHistoryError(
          e.toString(),
        ),
      );
    }
  }

  // =========================
  // Search
  // =========================

  Future<void> searchSales(String keyword) async {
    if (state is! SalesHistorySuccess) return;

    final current = state as SalesHistorySuccess;

    if (keyword.trim().isEmpty) {
      emit(
        current.copyWith(
          filteredSales: current.sales,
          isSearching: false,
        ),
      );
      return;
    }

    final result = await repository.searchSales(keyword);

    emit(
      current.copyWith(
        filteredSales: result,
        isSearching: true,
      ),
    );
  }

  void clearSearch() {
    if (state is! SalesHistorySuccess) return;

    final current = state as SalesHistorySuccess;

    emit(
      current.copyWith(
        filteredSales: current.sales,
        isSearching: false,
      ),
    );
  }

  // =========================
  // Delete Sale
  // =========================

  Future<void> deleteSale(int id) async {
    emit(SalesDeleteLoading());

    try {
      await repository.deleteSale(id);

      final sales = await repository.getSales();

      emit(
        SalesHistorySuccess(
          sales: sales,
          successMessage: "تم حذف الفاتورة بنجاح",
        ),
      );
    } catch (e) {
      emit(SalesHistoryError(e.toString()));
    }
  }


  // =========================
  // Reopen Order
  // =========================

  Future<void> reopenOrder(int id) async {
    emit(SalesReopenLoading());

    try {
      await repository.reopenOrder(id);

      final sales = await repository.getSales();

      emit(
        SalesHistorySuccess(
          sales: sales,
          successMessage: "تم إعادة فتح الأوردر بنجاح",
        ),
      );
    } catch (e) {
      emit(SalesHistoryError(e.toString()));
    }
  }
  // =========================
  // Print
  // =========================

  Future<void> printSale(int id) async {
    emit(SalesPrintLoading());

    try {
      final sale = await repository.getSaleById(id);

      final sales = await repository.getSales();

      emit(
        SalesHistorySuccess(
          sales: sales,
          successMessage:
          "تم طباعة الفاتورة رقم ${sale?.orderNumber ?? ''}",
        ),
      );
    } catch (e) {
      emit(SalesHistoryError(e.toString()));
    }
  }

  // =========================
  // Details
  // =========================


}