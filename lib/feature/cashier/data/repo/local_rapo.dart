import '../../../../core/service/printing/mapper/kitchen_mapper.dart';
import '../../../../core/service/printing/mapper/receipt_mapper.dart';
import '../../../../core/service/printing/printing_manager.dart';
import '../../../../core/service/printing/service/modu_print_service.dart';
// تأكد من ضبط هذا المسار حسب موقع ملف الـ audit_log_service.dart في مشروعك
import '../../../../core/service/audit_log_service.dart';
import '../../../setting/data/repo/repo.dart';
import '../data_source/local_data_source.dart';
import '../model/pos_model.dart';

abstract class OrderRepository {
  Future<void> increaseOrderCounter();
  OrderRepository(OrderLocalDataSource orderLocalDataSource);

  Future<void> holdOrderAndPrintKitchen(OrderModel order);
  Future<void> completePaymentAndPrintReceipt(String orderId);
  Future<List<OrderModel>> fetchHoldingOrders();
  Future<OrderModel?> getOrderById(String orderId);
  Future<void> deleteHoldingOrder(String orderId);
  Future<void> updateHoldingOrder(
      OrderModel order, {
        bool printKitchenTicket = true,
      });

  Future<int> getNextOrderNumber();
}

class OrderRepositoryImpl implements OrderRepository {
  final OrderLocalDataSource localDataSource;
  final ModuPrintService printService;
  final ModuPrintService _printer = ModuPrintService();

  OrderRepositoryImpl({required this.localDataSource, required this.printService,});

  @override
  Future<void> holdOrderAndPrintKitchen(OrderModel order) async {
    // 1. حفظ الأوردر
    await localDataSource.cacheOrder(order);

    // 2. طباعة بون المطبخ
    await PrintingManager.instance.printKitchen(order);

    // 3. تسجيل في سجل الحركات
    await AuditLogService.instance.log(
      userId: 1,
      userName: 'الكاشير',
      action: 'CREATE',
      module: 'المبيعات / الأوردرات',
      entityType: 'Order',
      entityId: order.id.toString(),
      description: 'تم تعليق أوردر جديد برقم: ${order.id}',
    );
  }

  @override
  Future<void> completePaymentAndPrintReceipt(String orderId) async {
    final order = await localDataSource.getOrderById(orderId);

    if (order == null) {
      throw Exception("Order not found");
    }

    // 1. نقل الأوردر إلى جدول المبيعات
    await localDataSource.completeOrder(order);

    // 2. طباعة الفاتورة
    await PrintingManager.instance.printReceipt(order);

    // 3. تسجيل في سجل الحركات
    await AuditLogService.instance.log(
      userId: 1,
      userName: 'الكاشير',
      action: 'PAYMENT',
      module: 'المبيعات',
      entityType: 'Order',
      entityId: orderId,
      description: 'تم إتمام دفع الفاتورة رقم $orderId',
    );
  }

  @override
  Future<List<OrderModel>> fetchHoldingOrders() async {
    return await localDataSource.getHoldingOrders();
  }

  @override
  Future<OrderModel?> getOrderById(String orderId) {
    return localDataSource.getOrderById(orderId);
  }

  @override
  Future<int> getNextOrderNumber() {
    return localDataSource.getNextOrderNumber();
  }

  @override
  Future<void> deleteHoldingOrder(String orderId) async {
    await localDataSource.deleteHoldingOrder(orderId);

    // تسجيل في سجل الحركات
    await AuditLogService.instance.log(
      userId: 1,
      userName: 'مشرف النظام',
      action: 'DELETE',
      module: 'المبيعات',
      entityType: 'Order',
      entityId: orderId,
      description: 'تم حذف أوردر معلق برقم: $orderId',
    );
  }

  @override
  Future<void> updateHoldingOrder(
      OrderModel order, {
        bool printKitchenTicket = true,
      }) async {
    await localDataSource.updateHoldingOrder(order);

    if (printKitchenTicket) {
      await PrintingManager.instance.printKitchen(order);
    }
  }

  @override
  Future<void> increaseOrderCounter() {
    return localDataSource.increaseOrderCounter();
  }
}