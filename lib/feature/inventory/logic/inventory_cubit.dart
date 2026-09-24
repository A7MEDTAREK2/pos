import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/repo/inventory_repository.dart';
import 'inventory_state.dart';

class InventoryCubit extends Cubit<InventoryState> {
  final InventoryRepository inventoryRepository;

  InventoryCubit({required this.inventoryRepository}) : super(InventoryInitialState());

  static InventoryCubit get(context) => BlocProvider.of(context);

  Future<void> fetchStockItems({
    String search = '',
    int limit = 20,
    int offset = 0,
  }) async {
    emit(InventoryLoadingState());
    try {
      final items = await inventoryRepository.getStockItems(
        search: search,
        limit: limit,
        offset: offset,
      );
      final count = await inventoryRepository.getStockItemsCount(search: search);
      emit(StockLoadedState(items: items, totalCount: count));
    } catch (e) {
      emit(InventoryErrorState(e.toString()));
    }
  }

  Future<void> fetchLowStockAlerts() async {
    emit(InventoryLoadingState());
    try {
      final items = await inventoryRepository.getLowStockItems();
      emit(LowStockLoadedState(items));
    } catch (e) {
      emit(InventoryErrorState(e.toString()));
    }
  }

  Future<void> adjustStock({
    required int productId,
    required double newQuantity,
    required String reason,
    String? note,
    int? userId,
  }) async {
    emit(InventoryLoadingState());
    try {
      await inventoryRepository.updateStockQuantity(
        productId: productId,
        newQuantity: newQuantity,
        reason: reason,
        note: note,
        userId: userId,
      );
      emit(StockUpdateSuccessState());
      fetchStockItems(); // إعادة جلب البيانات
    } catch (e) {
      emit(InventoryErrorState(e.toString()));
    }
  }

  Future<void> fetchMovements({
    required DateTime from,
    required DateTime to,
    int? productId,
    String? movementType,
    int limit = 50,
    int offset = 0,
  }) async {
    emit(InventoryLoadingState());
    try {
      final movements = await inventoryRepository.getInventoryMovements(
        from: from,
        to: to,
        productId: productId,
        movementType: movementType,
        limit: limit,
        offset: offset,
      );
      emit(InventoryMovementsLoadedState(movements));
    } catch (e) {
      emit(InventoryErrorState(e.toString()));
    }
  }
}