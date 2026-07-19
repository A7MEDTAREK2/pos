
import '../data/model/category_model.dart';

abstract class CategoryState {}

// الحالة الابتدائية
class CategoryInitial extends CategoryState {}

// حالة التحميل (Loading) أثناء جلب أو إضافة الأقسام
class CategoryLoading extends CategoryState {}

// حالة النجاح (Success) وبترجع معاها قائمة الأقسام الحالية
class CategorySuccess extends CategoryState {
  final List<CategoryModel> categories;
  CategorySuccess(this.categories);
}

// حالة الخطأ (Error) وبترجع معاها رسالة توضح المشكلة
class CategoryError extends CategoryState {
  final String message;
  CategoryError(this.message);
}