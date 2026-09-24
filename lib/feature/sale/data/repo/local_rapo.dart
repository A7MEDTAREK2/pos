// lib/feature/sales_history/data/repo/local_rapo.dart

import '../../../../core/service/audit_log_service.dart';
import '../../../cashier/data/model/pos_model.dart';
import '../data_source/local_data_source.dart';
import '../model/sale_model.dart';

abstract class SalesHistoryRepository {
  Future<OrderModel> getSaleAsOrder(int saleId);
  Future<List<SalesHistoryModel>> getSales();
  Future<List<SalesHistoryModel>> searchSales(String keyword);
  Future<List<SaleItemModel>> getSaleItems(int saleId);
  Future<void> deleteSale(int saleId);
  Future<SalesHistoryModel?> getSaleById(int saleId);

  // ✅ إضافة دالة إعادة فتح الأوردر
  Future<void> reopenOrder(int saleId);
}

class SalesHistoryRepositoryImpl implements SalesHistoryRepository {
  final SalesHistoryLocalDataSource dataSource;

  SalesHistoryRepositoryImpl({required this.dataSource});

  @override
  Future<List<SalesHistoryModel>> getSales() async {
    try {
      final result = await dataSource.getSales();
      return result.map((map) => SalesHistoryModel.fromMap(map)).toList();
    } catch (e) {
      throw Exception('Failed to load sales: $e');
    }
  }

  @override
  Future<List<SalesHistoryModel>> searchSales(String keyword) async {
    try {
      final result = await dataSource.searchSales(keyword);
      return result.map((map) => SalesHistoryModel.fromMap(map)).toList();
    } catch (e) {
      throw Exception('Failed to search sales: $e');
    }
  }

  @override
  Future<List<SaleItemModel>> getSaleItems(int saleId) async {
    try {
      final result = await dataSource.getSaleItems(saleId);
      return result.map((map) => SaleItemModel.fromMap(map)).toList();
    } catch (e) {
      throw Exception('Failed to load sale items: $e');
    }
  }

  @override
  Future<void> deleteSale(int saleId) async {
    try {
      await dataSource.deleteSale(saleId);

      // 📝 تسجيل حركة حذف فاتورة مبيعات
      await AuditLogService.instance.log(
        userId: 1,
        userName: 'مشرف النظام',
        action: 'DELETE',
        module: 'سجل المبيعات',
        entityType: 'Sale',
        entityId: saleId.toString(),
        description: 'تم حذف فاتورة المبيعات رقم: $saleId',
      );
    } catch (e) {
      throw Exception('Failed to delete sale: $e');
    }
  }

  @override
  Future<SalesHistoryModel?> getSaleById(int saleId) async {
    try {
      final sales = await getSales();
      try {
        return sales.firstWhere((s) => s.id == saleId);
      } catch (e) {
        return null;
      }
    } catch (e) {
      throw Exception('Failed to get sale by id: $e');
    }
  }

  // ✅ إعادة فتح الأوردر
  @override
  Future<void> reopenOrder(int saleId) async {
    try {
      await dataSource.reopenOrder(saleId);

      // 📝 تسجيل حركة إعادة فتح فاتورة/أوردر
      await AuditLogService.instance.log(
        userId: 1,
        userName: 'مشرف النظام',
        action: 'UPDATE',
        module: 'سجل المبيعات',
        entityType: 'Sale',
        entityId: saleId.toString(),
        description: 'تم إعادة فتح فاتورة المبيعات رقم: $saleId لتعديلها',
      );
    } catch (e) {
      throw Exception('Failed to reopen order: $e');
    }
  }

  @override
  Future<OrderModel> getSaleAsOrder(int saleId) {
    return dataSource.getSaleAsOrder(saleId);
  }
}