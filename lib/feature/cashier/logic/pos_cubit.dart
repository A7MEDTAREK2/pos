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

  // ================= Delivery Validation =================
  String? validateDeliveryOrder() {
    if (selectedOrderType == OrderType.delivery) {
      if (customerPhone == null || customerPhone!.trim().isEmpty) {
        return "يجب إدخال رقم هاتف العميل لأوردر الدليفري!";
      }
      if (customerAddress == null || customerAddress!.trim().isEmpty) {
        return "يجب إدخال عنوان التوصيل بالتفصيل!";
      }
      if (_driverName == null || _driverName!.trim().isEmpty) {
        return "يجب اختيار مندوب التوصيل!";
      }
      if (deliveryFee <= 0) {
        return "يجب إدخال تكلفة التوصيل بشكل صحيح أكبر من الصفر!";
      }
    }
    return null; // كل البيانات سليمة
  }

  // ================= Cart Actions =================

  void addToCart(Map<String, dynamic> product) {
    // 🔍 دمج دقيق بالـ productId والـ size والـ note لمنع تكرار الكروت وتجميعها فوراً
    final index = _cartItems.indexWhere(
          (e) =>
      e['productId'].toString() == product['productId'].toString() &&
          (e['size']?.toString() ?? '') == (product['size']?.toString() ?? '') &&
          (e['note']?.toString() ?? '') == (product['note']?.toString() ?? ''),
    );

    final updatedItems = List<Map<String, dynamic>>.from(_cartItems);
    if (index != -1) {
      updatedItems[index] = Map<String, dynamic>.from(updatedItems[index]);
      final currentQty = (updatedItems[index]['quantity'] as num).toInt();
      final addQty = (product['quantity'] as num?)?.toInt() ?? 1;
      updatedItems[index]['quantity'] = currentQty + addQty;
    } else {
      updatedItems.add({...product, 'quantity': (product['quantity'] as num?)?.toInt() ?? 1});
    }
    _cartItems = updatedItems;
    emit(CartUpdatedState(List.from(_cartItems)));
  }

  void incrementItem(String productId, {String? size}) {
    // 🔍 البحث المطابق باستخدام .toString() لتجنب اختلاف أنواع البيانات في الأوردرات القديمة
    final index = _cartItems.indexWhere(
          (e) => e['productId'].toString() == productId.toString() &&
          (e['size']?.toString() ?? '') == (size?.toString() ?? ''),
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
    // 🔍 البحث المطابق باستخدام .toString() لتجنب اختلاف أنواع البيانات في الأوردرات القديمة
    final index = _cartItems.indexWhere(
          (e) => e['productId'].toString() == productId.toString() &&
          (e['size']?.toString() ?? '') == (size?.toString() ?? ''),
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
    // 🔍 الحذف الدقيق للمنتج بالحجم المحدد
    final updatedItems = List<Map<String, dynamic>>.from(_cartItems)
      ..removeWhere((e) =>
      e['productId'].toString() == productId.toString() &&
          (e['size']?.toString() ?? '') == (size?.toString() ?? '')
      );
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

    discount = 0.0;
    deliveryFee = 0.0;
    taxPercent = 0.0;
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

      final subtotal = totalAmount;
      final currentDiscount = discount;
      final currentTax = taxEnabled ? (subtotal * taxPercent / 100) : 0.0;
      final currentDelivery = deliveryFee;

      final calculatedTotal =
          (subtotal - currentDiscount) + currentTax + currentDelivery;

      OrderModel order;

      if (isUpdate) {
        order = OrderModel(
          id: _currentOrder!.id,
          orderNumber: _currentOrder!.orderNumber,
          items: List.from(_cartItems),
          totalAmount: calculatedTotal,
          orderType: orderType,
          orderStatus: OrderStatus.holding,
          customerId: selectedCustomer?.id,
          customerAddressId: selectedAddress?.id,
          tableNumber: tableNumber,
          customerName: customerName,
          customerPhone: customerPhone,
          customerAddress: customerAddress,
          createdAt: _currentOrder!.createdAt,
          subtotal: subtotal,
          discount: currentDiscount,
          tax: currentTax,
          deliveryFee: currentDelivery,
          paymentMethod: paymentMethod,
          customerArea: customerArea,
          driverName: _driverName,
        );

        await _repository.updateHoldingOrder(order);
        // ✅ الحفاظ على مرجعية الأوردر الحالي لتحديثه مجدداً دون الحاجة لإعادة فتح الشاشة
        _currentOrder = order;
      } else {
        final orderNumber = await _repository.getNextOrderNumber();

        order = OrderModel(
          id: const Uuid().v4(),
          orderNumber: orderNumber,
          items: List.from(_cartItems),
          totalAmount: calculatedTotal,
          orderType: orderType,
          orderStatus: OrderStatus.holding,
          tableNumber: tableNumber,
          customerName: customerName,
          customerPhone: customerPhone,
          customerAddress: customerAddress,
          createdAt: DateTime.now(),
          subtotal: subtotal,
          discount: currentDiscount,
          tax: currentTax,
          deliveryFee: currentDelivery,
          paymentMethod: paymentMethod,
          customerArea: customerArea,
          driverName: _driverName,
        );

        await _repository.holdOrderAndPrintKitchen(order);
        await _repository.increaseOrderCounter();
        await refreshNextOrderNumber();
        // ✅ ربط الأوردر الجديد بمتغير التعديل المباشر
        _currentOrder = order;
      }

      if (clearAfterSave) {
        clearCart();
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
      final subtotal = totalAmount;
      final currentDiscount = discount;
      final currentTax = taxEnabled ? (subtotal * taxPercent / 100) : 0.0;
      final currentDelivery = deliveryFee;

      final calculatedTotal =
          (subtotal - currentDiscount) + currentTax + currentDelivery;

      if (_currentOrder != null) {
        final updatedOrder = _currentOrder!.copyWith(
          customerId: customerId,
          customerAddressId: customerAddressId,
          customerName: customerName,
          customerPhone: customerPhone,
          customerAddress: customerAddress,
          subtotal: subtotal,
          discount: currentDiscount,
          tax: currentTax,
          deliveryFee: currentDelivery,
          paymentMethod: paymentMethod,
          totalAmount: calculatedTotal,
          customerArea: customerArea,
          driverName: _driverName,
        );

        await _repository.updateHoldingOrder(
          updatedOrder,
          printKitchenTicket: false,
        );
        _currentOrder = updatedOrder;
      }

      await _repository.completePaymentAndPrintReceipt(orderId);
      await refreshNextOrderNumber();

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

    _driverName = order.driverName;

    // ====== دمج الأصناف المتشابهة لمنع ظهور كروت منفصلة عند فتح الأوردر للتعديل ======
    final Map<String, Map<String, dynamic>> mergedItems = {};
    for (final item in order.items) {
      final String productId = item['productId'].toString();
      final String size = item['size']?.toString() ?? '';
      final String note = item['note']?.toString() ?? '';
      final String key = '${productId}_${size}_$note';

      if (mergedItems.containsKey(key)) {
        final currentQty = (mergedItems[key]!['quantity'] as num).toInt();
        final addQty = (item['quantity'] as num).toInt();
        mergedItems[key]!['quantity'] = currentQty + addQty;
      } else {
        mergedItems[key] = Map<String, dynamic>.from(item);
      }
    }

    _cartItems = mergedItems.values.toList();
    // ===========================================================================

    discount = order.discount ?? 0.0;
    deliveryFee = order.deliveryFee ?? 0.0;
    paymentMethod = order.paymentMethod ?? "Cash";

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
    // 🔍 البحث المطابق باستخدام .toString() لتجنب اختلاف أنواع البيانات في الأوردرات القديمة
    final index = _cartItems.indexWhere(
          (e) => e['productId'].toString() == productId.toString() &&
          (e['size']?.toString() ?? '') == (size?.toString() ?? ''),
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
  // ================= Update Item Quantity Directly =================
  void updateItemQuantity(String productId, int quantity, {String? size}) {
    // 🔍 البحث المطابق باستخدام معرف المنتج والحجم
    final index = _cartItems.indexWhere(
          (e) => e['productId'].toString() == productId.toString() &&
          (e['size']?.toString() ?? '') == (size?.toString() ?? ''),
    );
    if (index == -1) return;

    final updatedItems = List<Map<String, dynamic>>.from(_cartItems);

    if (quantity > 0) {
      updatedItems[index] = Map<String, dynamic>.from(updatedItems[index]);
      updatedItems[index]['quantity'] = quantity;
    } else {
      // لو الكمية صفر أو أقل، يتم حذف المنتج من السلة
      updatedItems.removeAt(index);
    }

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
}