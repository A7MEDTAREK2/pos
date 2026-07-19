import '../../../../core/service/printing/mapper/kitchen_mapper.dart';
import '../../../../core/service/printing/mapper/receipt_mapper.dart';
import '../../../../core/service/printing/printing_manager.dart';
import '../../../../core/service/printing/service/modu_print_service.dart';
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

  // لو عندك برضه برينتر داتا سورس ممكن تعملها Inject هنا

  OrderRepositoryImpl({required this.localDataSource, required this.printService,});

  @override
  Future<void> holdOrderAndPrintKitchen(OrderModel order) async {
    // 1. احفظ الأوردر في الداتا سورس المحلي كـ holding
    await localDataSource.cacheOrder(order);

    // 2. تريجر كود الطباعة الصغير للمطبخ (بون الشغل)
    await PrintingManager.instance.printKitchen(order);
  }

  @override
  Future<void> completePaymentAndPrintReceipt(String orderId) async {
    // 1. هات الأوردر من الـ Holding
    final order = await localDataSource.getOrderById(orderId);

    if (order == null) {
      throw Exception("Order not found");
    }

    print("Repository Payment Method = ${order.paymentMethod}");
    // 2. انقله إلى جدول المبيعات
    await localDataSource.completeOrder(order);

    // 3. اطبع الفاتورة الكبيرة
    await PrintingManager.instance.printReceipt(order); }

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

  // ميثودس داخلية للطباعة



  @override
  Future<void> deleteHoldingOrder(String orderId) {
    return localDataSource.deleteHoldingOrder(orderId);
  }
  @override
  @override
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