import '../../../../core/service/audit_log_service.dart';
import '../datasource/inventory_local_data_source.dart';
import '../model/inventory_movement_model.dart';
import '../model/stock_item_model.dart';

abstract class InventoryRepository {
  Future<List<StockItemModel>> getStockItems({
    String search = '',
    int limit = 20,
    int offset = 0,
  });

  Future<int> getStockItemsCount({String search = ''});

  Future<List<StockItemModel>> getLowStockItems();

  Future<void> updateStockQuantity({
    required int productId,
    required double newQuantity,
    required String reason,
    String? note,
    int? userId,
  });

  Future<List<InventoryMovementModel>> getInventoryMovements({
    required DateTime from,
    required DateTime to,
    int? productId,
    String? movementType,
    int limit = 50,
    int offset = 0,
  });
}

class InventoryRepositoryImpl implements InventoryRepository {
  final InventoryLocalDataSource localDataSource;

  InventoryRepositoryImpl({required this.localDataSource});

  @override
  Future<List<StockItemModel>> getStockItems({
    String search = '',
    int limit = 20,
    int offset = 0,
  }) {
    return localDataSource.getStockItems(search: search, limit: limit, offset: offset);
  }

  @override
  Future<int> getStockItemsCount({String search = ''}) {
    return localDataSource.getStockItemsCount(search: search);
  }

  @override
  Future<List<StockItemModel>> getLowStockItems() {
    return localDataSource.getLowStockItems();
  }

  @override
  Future<void> updateStockQuantity({
    required int productId,
    required double newQuantity,
    required String reason,
    String? note,
    int? userId,
  }) async {
    // 1. تنفيذ تحديث الكمية في المخزن محلياً
    await localDataSource.updateStockQuantity(
      productId: productId,
      newQuantity: newQuantity,
      reason: reason,
      note: note,
      userId: userId,
    );

    // 2. 📝 تسجيل حركة تعديل المخزن في الـ Audit Log
    await AuditLogService.instance.log(
      userId: userId ?? 1,
      userName: 'مشرف النظام',
      action: 'UPDATE',
      module: 'المخزن',
      entityType: 'Inventory',
      entityId: productId.toString(),
      description: 'تم تحديث كمية المنتج (ID: $productId) إلى $newQuantity. السبب: $reason',
    );
  }

  @override
  Future<List<InventoryMovementModel>> getInventoryMovements({
    required DateTime from,
    required DateTime to,
    int? productId,
    String? movementType,
    int limit = 50,
    int offset = 0,
  }) {
    return localDataSource.getInventoryMovements(
      from: from,
      to: to,
      productId: productId,
      movementType: movementType,
      limit: limit,
      offset: offset,
    );
  }
}