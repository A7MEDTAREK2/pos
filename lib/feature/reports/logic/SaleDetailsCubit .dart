

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home/feature/reports/logic/sale_details_state.dart';

import '../data/repo/local_rapo.dart';

class SaleDetailssCubit extends Cubit<SaleDetailssState> {
  final ReportsRepository repository;

  SaleDetailssCubit(this.repository)
      : super(SaleDetailsInitial());

  Future<void> loadSale(int saleId) async {
    emit(SaleDetailsLoading());

    try {
      final sale = await repository.getSaleDetails(saleId);

      if (sale == null) {
        emit(SaleDetailsError("الفاتورة غير موجودة"));
        return;
      }

      emit(SaleDetailsLoaded(sale));
    } catch (e) {
      emit(SaleDetailsError(e.toString()));
    }
  }
}