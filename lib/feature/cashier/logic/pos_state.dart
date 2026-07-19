import '../data/model/pos_model.dart';

abstract class OrderState {}

class OrderInitial extends OrderState {}

class OrderLoading extends OrderState {}

// ✅ تحديث السلة
class CartUpdatedState extends OrderState {
  final List<Map<String, dynamic>> items;
  final String? selectedTable;
  final String? customerPhone;
  final String? customerAddress;

  CartUpdatedState(
      this.items, {
        this.selectedTable,
        this.customerPhone,
        this.customerAddress, String? customerName,
      });
}

// ✅ نجاح حجز الأوردر
class OrderHeldSuccess extends OrderState {
  final OrderModel order;
  OrderHeldSuccess(this.order);
}

// ✅ نجاح إتمام الدفع
class PaymentCompleteSuccess extends OrderState {}

// ✅ جلب الطلبات المعلقة
class HoldingOrdersLoaded extends OrderState {
  final List<OrderModel> holdingOrders;
  HoldingOrdersLoaded(this.holdingOrders);
}

// ✅ خطأ
class OrderError extends OrderState {
  final String error;
  OrderError(this.error);
}