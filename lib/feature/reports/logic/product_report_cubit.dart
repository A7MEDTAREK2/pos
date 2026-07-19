import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path/path.dart';

import '../../../core/service/export/report_export_model.dart';
import '../data/model/product_report.dart';
import '../data/repo/local_rapo.dart';
import 'product_report_state.dart';

class ProductReportCubit extends Cubit<ProductReportState> {

  final ProductReportRepository repository;

  ProductReportCubit(this.repository)
      : super(ProductReportInitial());

  DateTime from = DateTime.now().subtract(const Duration(days: 7));

  DateTime to = DateTime.now();

  String search='';

  int page=0;

  int limit=20;

  int totalCount=0;

  int get totalPages =>
      (totalCount/limit).ceil();

  List<ProductReportModel> products=[];

  Future<void> loadReport() async{

    emit(ProductReportLoading());

    try{

      totalCount =
      await repository.getProductReportCount(
        from: from,
        to: to,
        search: search,
      );

      products=
      await repository.getProductReport(
        from: from,
        to: to,
        search: search,
        limit: limit,
        offset: page*limit,
      );

      emit(ProductReportLoaded(products));

    }catch(e){

      emit(ProductReportError(e.toString()));

    }

  }

  Future<void> searchReport(String value) async{

    search=value;

    page=0;

    await loadReport();

  }

  Future<void> changeDateRange({
    required DateTime from,
    required DateTime to,
  }) async{

    this.from=from;

    this.to=to;

    page=0;

    await loadReport();

  }

  Future<void> nextPage() async{

    if(page>=totalPages-1)return;

    page++;

    await loadReport();

  }

  Future<void> previousPage() async{

    if(page==0)return;

    page--;

    await loadReport();

  }


}