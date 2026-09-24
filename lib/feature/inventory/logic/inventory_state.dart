import '../data/model/inventory_movement_model.dart';
import '../data/model/stock_item_model.dart';

abstract class InventoryState {}

class InventoryInitialState extends InventoryState {}

class InventoryLoadingState extends InventoryState {}

class StockLoadedState extends InventoryState {
  final List<StockItemModel> items;
  final int totalCount;

  StockLoadedState({required this.items, required this.totalCount});
}

class LowStockLoadedState extends InventoryState {
  final List<StockItemModel> items;

  LowStockLoadedState(this.items);
}

class InventoryMovementsLoadedState extends InventoryState {
  final List<InventoryMovementModel> movements;

  InventoryMovementsLoadedState(this.movements);
}

class StockUpdateSuccessState extends InventoryState {}

class InventoryErrorState extends InventoryState {
  final String message;

  InventoryErrorState(this.message);
}