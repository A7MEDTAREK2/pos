import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/model/category_model.dart';
import '../data/repo/local_rapo.dart';
import 'category_state.dart';

class CategoryCubit extends Cubit<CategoryState> {
  final CategoryRepository _repository;

  CategoryCubit(this._repository) : super(CategoryInitial());

  // 1. جلب جميع الأقسام من الداتا بيز
  Future<void> loadCategories() async {
    emit(CategoryLoading());
    try {
      final categories = await _repository.getCategories();
      emit(CategorySuccess(categories));
    } catch (e) {
      emit(CategoryError("فشل في تحميل الأقسام: ${e.toString()}"));
    }
  }

  // 2. إضافة قسم جديد
  Future<void> addNewCategory(String name) async {
    if (name.trim().isEmpty) {
      emit(CategoryError("اسم القسم لا يمكن أن يكون فارغاً"));
      return;
    }

    try {
      final newCategory = CategoryModel(name: name.trim());
      final isSuccess = await _repository.addCategory(newCategory);

      if (isSuccess) {
        // بعد الإضافة الناجحة، بنعمل إعادة تحميل للأقسام عشان الشاشة تتحدث تلقائياً
        await loadCategories();
      } else {
        emit(CategoryError("لم يتم حفظ القسم، حاول مرة أخرى"));
      }
    } catch (e) {
      emit(CategoryError("حدث خطأ أثناء إضافة القسم: ${e.toString()}"));
    }
  }

  // 3. حذف قسم
  Future<void> deleteCategory(int id) async {
    try {
      final isSuccess = await _repository.removeCategory(id);
      if (isSuccess) {
        // إعادة تحميل القائمة بعد الحذف
        await loadCategories();
      } else {
        emit(CategoryError("فشل في حذف القسم"));
      }
    } catch (e) {
      emit(CategoryError("حدث خطأ أثناء الحذف: ${e.toString()}"));
    }
  }


  // دالة تعديل قسم
  Future<void> updateExistingCategory(CategoryModel category) async {
    try {
      final isSuccess = await _repository.updateCategory(category);
      if (isSuccess) {
        await loadCategories(); // إعادة تحميل الأقسام عشان الشاشة تتحدث تلقائياً
      } else {
        emit(CategoryError("فشل في تعديل القسم"));
      }
    } catch (e) {
      emit(CategoryError("حدث خطأ أثناء التعديل: ${e.toString()}"));
    }
  }

  // دالة حذف قسم (تأكد إنها موجودة عندك)

}