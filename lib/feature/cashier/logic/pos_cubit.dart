import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import '../../cutomer/data/model/customer_model.dart';
import '../data/model/pos_model.dart';
import '../data/repo/local_rapo.dart';
import 'pos_state.dart';

class OrderCubit extends Cubit<OrderState> {
  final OrderRepository _repository;
  CustomerModel? selectedCustomer;
  int? customerId;
  int? customerAddressId;
  CustomerAddressModel? selectedAddress;

  OrderCubit(this._repository) : super(OrderInitial()) {
    refreshNextOrderNumber();
  }

  // ================= Financial Settings =================
  double discount = 0.0;
  double deliveryFee = 0.0;
  double taxPercent = 0.0;
  bool taxEnabled = true;
  String paymentMethod = "Cash";

  // ================= Driver =================
  String? _driverName;

  String? get driverName => _driverName;

  void setDriver(String? name) {
    _driverName = name;
    print("Driver Name = $_driverName");
    emit(CartUpdatedState(List.from(_cartItems)));
  }

  void clearDriver() {
    _driverName = null;
    emit(CartUpdatedState(List.from(_cartItems)));
  }

  void setDiscount(double value) {
    discount = value;
    print("Discount = $discount");
    emit(CartUpdatedState(List.from(_cartItems)));
  }

  void setDeliveryFee(double value) {
    deliveryFee = value;
    print("Delivery Fee = $deliveryFee");
    emit(CartUpdatedState(List.from(_cartItems)));
  }

  void setTaxPercent(double value) {
    taxPercent = value;
    print("Tax Percent = $taxPercent");
    emit(CartUpdatedState(List.from(_cartItems)));
  }

  void setPaymentMethod(String method) {
    paymentMethod = method;
    print("Payment Method = $paymentMethod");
  }

  // ================= Cart State =================
  List<Map<String, dynamic>> _cartItems = [];

  List<Map<String, dynamic>> get cartItems => _cartItems;

  // ================= Order Fields =================
  String? customerName;
  String? customerPhone;
  String? customerAddress;
  String? tableNumber;
  String? customerArea;
  OrderType selectedOrderType = OrderType.takeAway;

  int? nextOrderNumber;

  OrderModel? _currentOrder;

  OrderModel? get currentOrder => _currentOrder;

  // ================= Next Order Number =================
  Future<void> refreshNextOrderNumber() async {
    try {
      nextOrderNumber = await _repository.getNextOrderNumber();
      emit(CartUpdatedState(List.from(_cartItems)));
    } catch (e) {
      // تجاهل الخطأ هنا
    }
  }

  // ================= Cart Actions =================

  void addToCart(Map<String, dynamic> product) {
    final index = _cartItems.indexWhere(
          (e) =>
      e['productId'] == product['productId'] &&
          e['size'] == product['size'],
    );
    final updatedItems = List<Map<String, dynamic>>.from(_cartItems);
    if (index != -1) {
      updatedItems[index] = Map<String, dynamic>.from(updatedItems[index]);
      updatedItems[index]['quantity'] =
          (updatedItems[index]['quantity'] as int) + 1;
    } else {
      updatedItems.add({...product, 'quantity': 1});
    }
    _cartItems = updatedItems;
    emit(CartUpdatedState(List.from(_cartItems)));
  }

  void incrementItem(String productId, {String? size}) {
    final index = _cartItems.indexWhere(
          (e) => e['productId'] == productId && e['size'] == size,
    );
    if (index == -1) return;
    final updatedItems = List<Map<String, dynamic>>.from(_cartItems);
    updatedItems[index] = Map<String, dynamic>.from(updatedItems[index]);
    updatedItems[index]['quantity'] =
        (updatedItems[index]['quantity'] as int) + 1;
    _cartItems = updatedItems;
    emit(CartUpdatedState(List.from(_cartItems)));
  }

  void decrementItem(String productId, {String? size}) {
    final index = _cartItems.indexWhere(
          (e) => e['productId'] == productId && e['size'] == size,
    );
    if (index == -1) return;
    final updatedItems = List<Map<String, dynamic>>.from(_cartItems);
    if ((updatedItems[index]['quantity'] as int) > 1) {
      updatedItems[index] = Map<String, dynamic>.from(updatedItems[index]);
      updatedItems[index]['quantity'] =
          (updatedItems[index]['quantity'] as int) - 1;
    } else {
      updatedItems.removeAt(index);
    }
    _cartItems = updatedItems;
    emit(CartUpdatedState(List.from(_cartItems)));
  }

  void removeItem(String productId, {String? size}) {
    final updatedItems = List<Map<String, dynamic>>.from(_cartItems)
      ..removeWhere((e) => e['productId'] == productId && e['size'] == size);
    _cartItems = updatedItems;

    emit(
      CartUpdatedState(
        List.from(_cartItems),
        selectedTable: tableNumber,
        customerPhone: customerPhone,
        customerAddress: customerAddress,
        customerName: customerName,
      ),
    );
  }

  double get totalAmount {
    return _cartItems.fold(0.0, (sum, item) {
      final price = (item['price'] as num).toDouble();
      final quantity = (item['quantity'] as int);
      return sum + (price * quantity);
    });
  }

  // ================= Reset =================
  void clearCart({bool clearCurrentOrder = true}) {
    _cartItems = [];

    customerName = null;
    customerPhone = null;
    customerAddress = null;
    tableNumber = null;
    customerArea = null;

    selectedCustomer = null;
    selectedAddress = null;

    customerId = null;
    customerAddressId = null;

    deliveryFee = 0;
    paymentMethod = "Cash";
    selectedOrderType = OrderType.takeAway;

    // ====== تصفير المندوب ======
    _driverName = null;

    if (clearCurrentOrder) {
      _currentOrder = null;
    }

    emit(CartUpdatedState([]));

    refreshNextOrderNumber();
  }

  void clearItemsOnly() {
    _cartItems = [];
    emit(CartUpdatedState([]));
  }

  // ================= Order Type =================
  void changeOrderType(OrderType type) {
    if (selectedOrderType == type) return;

    selectedOrderType = type;

    switch (type) {
      case OrderType.takeAway:
        tableNumber = null;
        customerName = null;
        customerPhone = null;
        customerAddress = null;
        break;

      case OrderType.dineIn:
        customerName = null;
        customerPhone = null;
        customerAddress = null;
        break;

      case OrderType.delivery:
        tableNumber = null;
        break;
    }

    emit(
      CartUpdatedState(
        List.from(_cartItems),
        selectedTable: tableNumber,
        customerName: customerName,
        customerPhone: customerPhone,
        customerAddress: customerAddress,
      ),
    );
  }

  // ================= Hold Order =================
  Future<OrderModel?> holdOrder({bool clearAfterSave = true}) async {
    if (_cartItems.isEmpty) return null;

    emit(OrderLoading());

    try {
      final bool isUpdate = _currentOrder != null;
      final orderType = selectedOrderType;

      OrderModel order;

      if (isUpdate) {
        order = OrderModel(
          id: _currentOrder!.id,
          orderNumber: _currentOrder!.orderNumber,
          items: List.from(_cartItems),
          totalAmount: totalAmount,
          orderType: orderType,
          orderStatus: OrderStatus.holding,

          customerId: selectedCustomer?.id,
          customerAddressId: selectedAddress?.id,
          tableNumber: tableNumber,
          customerName: customerName,
          customerPhone: customerPhone,
          customerAddress: customerAddress,
          createdAt: _currentOrder!.createdAt,
          subtotal: totalAmount,
          discount: discount,
          tax: taxEnabled ? (totalAmount * taxPercent / 100) : 0,
          deliveryFee: deliveryFee,
          paymentMethod: paymentMethod,
          customerArea: customerArea,
          driverName: _driverName, // ====== إضافة اسم المندوب ======
        );

        await _repository.updateHoldingOrder(order);
      } else {
        final orderNumber = await _repository.getNextOrderNumber();

        order = OrderModel(
          id: const Uuid().v4(),
          orderNumber: orderNumber,
          items: List.from(_cartItems),
          totalAmount: totalAmount,
          orderType: orderType,
          orderStatus: OrderStatus.holding,
          tableNumber: tableNumber,
          customerName: customerName,
          customerPhone: customerPhone,
          customerAddress: customerAddress,
          createdAt: DateTime.now(),
          subtotal: totalAmount,
          discount: discount,
          tax: taxEnabled ? (totalAmount * taxPercent / 100) : 0,
          deliveryFee: deliveryFee,
          paymentMethod: paymentMethod,
          customerArea: customerArea,
          driverName: _driverName, // ====== إضافة اسم المندوب ======
        );

        await _repository.holdOrderAndPrintKitchen(order);
      }

      if (clearAfterSave) {
        clearCart();
      } else {
        _currentOrder = order;
      }

      emit(OrderHeldSuccess(order));

      return order;
    } catch (e) {
      emit(OrderError(e.toString()));
      return null;
    }
  }

  // ================= Payment =================
  Future<void> completePayment(String orderId) async {
    emit(OrderLoading());

    try {
      if (_currentOrder != null) {
        final updatedOrder = _currentOrder!.copyWith(
          customerId: customerId,
          customerAddressId: customerAddressId,
          customerName: customerName,
          customerPhone: customerPhone,
          customerAddress: customerAddress,
          subtotal: totalAmount,
          discount: discount,
          tax: taxEnabled ? (totalAmount * taxPercent / 100) : 0,
          deliveryFee: deliveryFee,
          paymentMethod: paymentMethod,
          totalAmount: totalAmount,
          customerArea: customerArea,
          driverName: _driverName, // ====== إضافة اسم المندوب ======
        );

        await _repository.updateHoldingOrder(
          updatedOrder,
          printKitchenTicket: false,
        );
        _currentOrder = updatedOrder;
      }

      await _repository.completePaymentAndPrintReceipt(orderId);

      clearCart();

      emit(PaymentCompleteSuccess());
    } catch (e) {
      emit(OrderError(e.toString()));
    }
  }

  // ================= Holding Orders =================
  Future<void> fetchHoldingOrders() async {
    emit(OrderLoading());
    try {
      final orders = await _repository.fetchHoldingOrders();
      emit(HoldingOrdersLoaded(orders));
    } catch (e) {
      emit(OrderError(e.toString()));
    }
  }

  void loadHoldingOrder(OrderModel order) {
    _currentOrder = order;

    selectedOrderType = order.orderType;

    customerName = order.customerName;
    customerPhone = order.customerPhone;
    customerAddress = order.customerAddress;
    tableNumber = order.tableNumber;

    customerId = order.customerId;
    customerAddressId = order.customerAddressId;
    customerArea = order.customerArea;

    // ====== تحميل اسم المندوب ======
    _driverName = order.driverName;

    _cartItems = List<Map<String, dynamic>>.from(order.items);

    emit(
      CartUpdatedState(
        List.from(_cartItems),
        selectedTable: tableNumber,
        customerName: customerName,
        customerPhone: customerPhone,
        customerAddress: customerAddress,
      ),
    );
  }

  Future<void> deleteHoldingOrder(String orderId) async {
    try {
      await _repository.deleteHoldingOrder(orderId);
      fetchHoldingOrders();
    } catch (e) {
      emit(OrderError(e.toString()));
    }
  }

  void updateItemNote(String productId, String note, {String? size}) {
    final index = _cartItems.indexWhere(
          (e) => e['productId'] == productId && e['size'] == size,
    );
    if (index == -1) return;

    final updatedItems = List<Map<String, dynamic>>.from(_cartItems);
    updatedItems[index] = Map<String, dynamic>.from(updatedItems[index]);
    updatedItems[index]['note'] = note;
    _cartItems = updatedItems;

    emit(
      CartUpdatedState(
        List.from(_cartItems),
        selectedTable: tableNumber,
        customerPhone: customerPhone,
        customerAddress: customerAddress,
        customerName: customerName,
      ),
    );
  }

  void cancelPayment() {
    clearCart();
  }

  void setCustomer(CustomerModel customer) {
    selectedCustomer = customer;
    customerId = customer.id;

    customerName = customer.name;
    customerPhone = customer.phone;

    emit(
      CartUpdatedState(
        List.from(_cartItems),
        selectedTable: tableNumber,
        customerName: customerName,
        customerPhone: customerPhone,
        customerAddress: customerAddress,
      ),
    );
  }

  void clearCustomer() {
    selectedCustomer = null;

    customerName = null;
    customerPhone = null;
    customerAddress = null;
    customerArea = null;

    emit(
      CartUpdatedState(
        List.from(_cartItems),
        selectedTable: tableNumber,
        customerName: customerName,
        customerPhone: customerPhone,
        customerAddress: customerAddress,
      ),
    );
  }

  void setAddress(CustomerAddressModel address) {
    selectedAddress = address;
    customerAddressId = address.id;

    customerArea = address.area;
    customerAddress = address.address;

    emit(
      CartUpdatedState(
        List.from(_cartItems),
        selectedTable: tableNumber,
        customerName: customerName,
        customerPhone: customerPhone,
        customerAddress: customerAddress,
      ),
    );
  }
}