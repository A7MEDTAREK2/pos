import 'package:flutter_bloc/flutter_bloc.dart';

import '../../feature/product/data/model/product_model.dart';
import '../data_base/pos_database.dart'; // عدل المسار حسب مشروعك

abstract class NotificationState {}

class NotificationInitial extends NotificationState {}

class NotificationLoading extends NotificationState {}

class NotificationLoaded extends NotificationState {
  final List<ProductModel> lowStockProducts;
  NotificationLoaded(this.lowStockProducts);
}

class NotificationError extends NotificationState {
  final String message;
  NotificationError(this.message);
}

class NotificationCubit extends Cubit<NotificationState> {
  NotificationCubit() : super(NotificationInitial());

  // دالة لجلب المنتجات التي وصلت للحد الأدنى وتحديث الواجهة فوراً
  Future<void> checkLowStockProducts() async {
    try {
      // لا نقوم بـ emit(NotificationLoading()) هنا حتى لا يختفي الـ UI أثناء التحديث الخفي
      final db = await AppDatabase.instance.database;

      final result = await db.rawQuery('''
        SELECT * FROM products WHERE quantity <= minimum_stock
      ''');

      final products = result.map((map) => ProductModel.fromMap(map)).toList();
      emit(NotificationLoaded(products));
    } catch (e) {
      emit(NotificationError(e.toString()));
    }
  }
}