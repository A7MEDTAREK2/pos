import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/repo/local_rapo.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final HomeRepository _repository;

  HomeCubit(this._repository) : super(HomeInitial());

  void loadDashboardData() async {
    emit(HomeLoading());
    try {
      final metrics = await _repository.getHomeMetrics();
      emit(HomeSuccess(metrics));
    } catch (e) {
      emit(HomeError(e.toString()));
    }
  }

  // 🎯 استدعِ هذه الدالة فوراً بعد حفظ فاتورة جديدة أو إضافة منتج لتتحدث الكروت في ساعتها
  Future<void> refreshDashboard() async {
    try {
      final metrics = await _repository.getHomeMetrics();
      // إذا كانت الحالة الحالية ناجحة، نقوم بتحديثها بالبيانات الجديدة مباشرة
      emit(HomeSuccess(metrics));
    } catch (e) {
      // لا نقوم بإرسال HomeError هنا حتى لا نقطع تجربة المستخدم إذا فشل التحديث الصامت
    }
  }
}