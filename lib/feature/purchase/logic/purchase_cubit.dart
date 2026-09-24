import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/model/purchase_item_model.dart';
import '../data/model/purchase_model.dart';
import '../data/model/purchase_product_model.dart';
import '../data/repo/local_repo.dart';
import 'purchase_state.dart';

class PurchaseCubit extends Cubit<PurchaseState> {
  final PurchaseRepository repository;

  PurchaseCubit(this.repository) : super(PurchaseInitial());

  // =========================================================
  // Data
  // =========================================================

  List<PurchaseModel> purchases = [];

  List<PurchaseProductModel> purchaseProducts = [];

  List<Map<String, dynamic>> suppliers = [];

  /// المنتجات الموجودة حاليًا داخل فاتورة الشراء
  List<PurchaseItemModel> items = [];

  // =========================================================
  // Purchase Info
  // =========================================================

  int? selectedSupplierId;
  String selectedSupplierName = '';

  double discount = 0;

  String paymentMethod = 'Cash';

  // =========================================================
  // Load All Data
  // =========================================================

  Future<void> loadData() async {
    emit(PurchaseLoading());

    try {
      purchases = await repository.getPurchases();

      purchaseProducts =
      await repository.getPurchaseProducts();

      suppliers = await repository.getSuppliers();

      emit(_loadedState());
    } catch (e) {
      emit(
        PurchaseError(
          'حدث خطأ أثناء تحميل بيانات المشتريات: $e',
        ),
      );
    }
  }

  // =========================================================
  // Load Purchases
  // =========================================================

  Future<void> loadPurchases() async {
    try {
      purchases = await repository.getPurchases();

      emit(_loadedState());
    } catch (e) {
      emit(
        PurchaseError(
          'حدث خطأ أثناء تحميل المشتريات: $e',
        ),
      );
    }
  }

  // =========================================================
  // Load Purchase Products
  // =========================================================

  Future<void> loadPurchaseProducts() async {
    try {
      purchaseProducts =
      await repository.getPurchaseProducts();

      emit(_loadedState());
    } catch (e) {
      emit(
        PurchaseError(
          'حدث خطأ أثناء تحميل منتجات المشتريات: $e',
        ),
      );
    }
  }

  // =========================================================
  // Suppliers
  // =========================================================

  void selectSupplier(int? supplierId) {
    selectedSupplierId = supplierId;

    final supplier = suppliers.where(
          (element) => element['id'] == supplierId,
    );

    if (supplier.isNotEmpty) {
      selectedSupplierName =
          supplier.first['name']?.toString() ?? '';
    } else {
      selectedSupplierName = '';
    }

    emit(_loadedState());
  }

  // =========================================================
  // Purchase Products CRUD
  // =========================================================

  Future<void> addPurchaseProduct({
    required String name,
    String? barcode,
    String unit = 'piece',
    double costPrice = 0,
  }) async {
    if (name.trim().isEmpty) {
      emit(
        const PurchaseError(
          'اسم المنتج مطلوب.',
        ),
      );
      return;
    }

    if (costPrice < 0) {
      emit(
        const PurchaseError(
          'سعر التكلفة لا يمكن أن يكون سالبًا.',
        ),
      );
      return;
    }

    try {
      final product = PurchaseProductModel(
        name: name.trim(),
        barcode:
        barcode?.trim().isEmpty == true
            ? null
            : barcode?.trim(),
        unit: unit,
        costPrice: costPrice,
        quantity: 0,
        isActive: true,
        createdAt: DateTime.now(),
      );

      await repository.createPurchaseProduct(
        product,
      );

      purchaseProducts =
      await repository.getPurchaseProducts();

      emit(_loadedState());
    } catch (e) {
      emit(
        PurchaseError(
          'حدث خطأ أثناء إضافة منتج المشتريات: $e',
        ),
      );
    }
  }

  Future<void> updatePurchaseProduct(
      PurchaseProductModel product,
      ) async {
    try {
      await repository.updatePurchaseProduct(
        product,
      );

      purchaseProducts =
      await repository.getPurchaseProducts();

      emit(_loadedState());
    } catch (e) {
      emit(
        PurchaseError(
          'حدث خطأ أثناء تعديل منتج المشتريات: $e',
        ),
      );
    }
  }

  Future<void> deletePurchaseProduct(
      int productId,
      ) async {
    try {
      await repository.deletePurchaseProduct(
        productId,
      );

      purchaseProducts =
      await repository.getPurchaseProducts();

      // لو المنتج موجود داخل الفاتورة الحالية
      items.removeWhere(
            (item) =>
        item.purchaseProductId == productId,
      );

      emit(_loadedState());
    } catch (e) {
      emit(
        PurchaseError(
          'حدث خطأ أثناء حذف منتج المشتريات: $e',
        ),
      );
    }
  }

  // =========================================================
  // Add Product To Purchase
  // =========================================================

  void addProduct(
      PurchaseProductModel product, {
        int quantity = 1,
        double? costPrice,
      }) {
    if (product.id == null) {
      emit(
        const PurchaseError(
          'منتج المشتريات غير صالح.',
        ),
      );
      return;
    }

    if (quantity <= 0) {
      return;
    }

    final price =
        costPrice ?? product.costPrice;

    final index = items.indexWhere(
          (item) =>
      item.purchaseProductId == product.id,
    );

    // -------------------------------------------------------
    // Product already exists in invoice
    // -------------------------------------------------------

    if (index != -1) {
      final oldItem = items[index];

      final newQuantity =
          oldItem.quantity + quantity;

      items[index] = oldItem.copyWith(
        quantity: newQuantity,
        costPrice: price,
        total: newQuantity * price,
      );
    }

    // -------------------------------------------------------
    // New product
    // -------------------------------------------------------

    else {
      items.add(
        PurchaseItemModel(
          purchaseProductId: product.id!,
          productName: product.name,
          quantity: quantity,
          costPrice: price,
          total: quantity * price,
        ),
      );
    }

    emit(_loadedState());
  }

  // =========================================================
  // Quantity
  // =========================================================

  void updateQuantity(
      int purchaseProductId,
      int quantity,
      ) {
    final index = items.indexWhere(
          (item) =>
      item.purchaseProductId ==
          purchaseProductId,
    );

    if (index == -1) return;

    if (quantity <= 0) {
      items.removeAt(index);
    } else {
      final item = items[index];

      items[index] = item.copyWith(
        quantity: quantity,
        total: quantity * item.costPrice,
      );
    }

    emit(_loadedState());
  }

  void incrementQuantity(
      int purchaseProductId,
      ) {
    final item =
    _findItem(purchaseProductId);

    if (item == null) return;

    updateQuantity(
      purchaseProductId,
      item.quantity + 1,
    );
  }

  void decrementQuantity(
      int purchaseProductId,
      ) {
    final item =
    _findItem(purchaseProductId);

    if (item == null) return;

    updateQuantity(
      purchaseProductId,
      item.quantity - 1,
    );
  }

  // =========================================================
  // Cost Price
  // =========================================================

  void updateCostPrice(
      int purchaseProductId,
      double costPrice,
      ) {
    if (costPrice < 0) return;

    final index = items.indexWhere(
          (item) =>
      item.purchaseProductId ==
          purchaseProductId,
    );

    if (index == -1) return;

    final item = items[index];

    items[index] = item.copyWith(
      costPrice: costPrice,
      total: costPrice * item.quantity,
    );

    emit(_loadedState());
  }

  // =========================================================
  // Remove Item
  // =========================================================

  void removeItem(
      int purchaseProductId,
      ) {
    items.removeWhere(
          (item) =>
      item.purchaseProductId ==
          purchaseProductId,
    );

    emit(_loadedState());
  }

  // =========================================================
  // Discount
  // =========================================================

  void setDiscount(double value) {
    discount = value < 0 ? 0 : value;

    if (discount > subtotal) {
      discount = subtotal;
    }

    emit(_loadedState());
  }

  // =========================================================
  // Payment Method
  // =========================================================

  void setPaymentMethod(String value) {
    paymentMethod = value;

    emit(_loadedState());
  }

  // =========================================================
  // Clear Purchase
  // =========================================================

  void clearPurchase() {
    items.clear();

    selectedSupplierId = null;
    selectedSupplierName = '';

    discount = 0;

    paymentMethod = 'Cash';

    emit(_loadedState());
  }

  // =========================================================
  // Save Purchase
  // =========================================================

  Future<void> savePurchase() async {
    if (selectedSupplierId == null) {
      emit(
        const PurchaseError(
          'من فضلك اختر المورد أولاً.',
        ),
      );
      return;
    }

    if (items.isEmpty) {
      emit(
        const PurchaseError(
          'من فضلك أضف صنف واحد على الأقل.',
        ),
      );
      return;
    }

    if (discount > subtotal) {
      emit(
        const PurchaseError(
          'الخصم لا يمكن أن يكون أكبر من قيمة المشتريات.',
        ),
      );
      return;
    }

    emit(PurchaseSaving());

    try {
      final purchase = PurchaseModel(
        supplierId: selectedSupplierId!,
        supplierName: selectedSupplierName,
        subtotal: subtotal,
        discount: discount,
        total: total,
        paymentMethod: paymentMethod,
        notes: null,
        createdAt: DateTime.now(),
        items: List<PurchaseItemModel>.from(
          items,
        ),
      );

      final id =
      await repository.createPurchase(
        purchase,
      );

      purchases =
      await repository.getPurchases();

      purchaseProducts =
      await repository.getPurchaseProducts();

      emit(PurchaseSaved(id));

      clearPurchase();
    } catch (e) {
      emit(
        PurchaseError(
          'حدث خطأ أثناء حفظ المشتريات: $e',
        ),
      );
    }
  }

  // =========================================================
  // Delete Purchase
  // =========================================================

  Future<void> deletePurchase(
      int purchaseId,
      ) async {
    try {
      await repository.deletePurchase(
        purchaseId,
      );

      purchases =
      await repository.getPurchases();

      purchaseProducts =
      await repository.getPurchaseProducts();

      emit(_loadedState());
    } catch (e) {
      emit(
        PurchaseError(
          'حدث خطأ أثناء حذف فاتورة الشراء: $e',
        ),
      );
    }
  }

  // =========================================================
  // Find Item
  // =========================================================

  PurchaseItemModel? _findItem(
      int purchaseProductId,
      ) {
    try {
      return items.firstWhere(
            (item) =>
        item.purchaseProductId ==
            purchaseProductId,
      );
    } catch (_) {
      return null;
    }
  }

  // =========================================================
  // Financial Calculations
  // =========================================================

  double get subtotal {
    return items.fold(
      0,
          (sum, item) => sum + item.total,
    );
  }

  double get total {
    final value =
        subtotal - discount;

    return value < 0 ? 0 : value;
  }

  // =========================================================
  // Loaded State
  // =========================================================

  PurchaseLoaded _loadedState() {
    return PurchaseLoaded(
      purchases:
      List.unmodifiable(purchases),
      purchaseProducts:
      List.unmodifiable(purchaseProducts),
      suppliers:
      List.unmodifiable(suppliers),
      items:
      List.unmodifiable(items),
      selectedSupplierId:
      selectedSupplierId,
      selectedSupplierName:
      selectedSupplierName,
      discount: discount,
      paymentMethod: paymentMethod,
    );
  }
}