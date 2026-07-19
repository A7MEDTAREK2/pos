import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/repo/local_rapo.dart';
import 'sale_details_state.dart';

class SaleDetailsCubit extends Cubit<SaleDetailsState> {
  final SalesHistoryRepository repository;

  SaleDetailsCubit({
    required this.repository,
  }) : super(SaleDetailsInitial());

  Future<void> loadDetails(int saleId) async {
    emit(SaleDetailsLoading());

    try {
      final sale = await repository.getSaleById(saleId);

      if (sale == null) {
        emit(
          const SaleDetailsError(
            "الفاتورة غير موجودة",
          ),
        );
        return;
      }

      final items = await repository.getSaleItems(saleId);

      emit(
        SaleDetailsSuccess(
          sale: sale,
          items: items,
        ),
      );
    } catch (e) {
      emit(
        SaleDetailsError(
          e.toString(),
        ),
      );
    }
  }
}