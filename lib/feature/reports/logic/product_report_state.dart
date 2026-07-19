import '../data/model/product_report.dart';

abstract class ProductReportState {}

class ProductReportInitial extends ProductReportState {}

class ProductReportLoading extends ProductReportState {}

class ProductReportLoaded extends ProductReportState {

  final List<ProductReportModel> products;

  ProductReportLoaded(this.products);

}

class ProductReportError extends ProductReportState {

  final String message;

  ProductReportError(this.message);

}