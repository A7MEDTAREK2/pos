import '../../category/data/model/category_model.dart';
import '../data/model/product_model.dart'; // استيراد موديل الأقسام للربط

abstract class ProductState {}

// الحالة المبدئية
class ProductInitial extends ProductState {}

// حالة التحميل (الـ Loading)
class ProductLoading extends ProductState {}

// حالة النجاح: وبنرجع معاها لستة المنتجات، ولستة الأقسام عشان الـ Dropdown
class ProductSuccess extends ProductState {
  final List<ProductModel> products;
  final List<CategoryModel> categories; // مضافة هنا عشان تخدم شاشة الإضافة والفلترة
  final int? selectedCategoryId; // لمعرفة القسم الحالي اللي بنفلتر بيه (لو موجود)

  ProductSuccess({
    required this.products,
    required this.categories,
    this.selectedCategoryId,
  });
}

// حالة حدوث خطأ
class ProductError extends ProductState {
  final String message;
  ProductError(this.message);
}