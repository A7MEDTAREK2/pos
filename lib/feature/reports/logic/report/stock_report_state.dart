import '../../data/model/stock.dart';

abstract class StockReportState {}

class StockReportInitial extends StockReportState {}

class StockReportLoading extends StockReportState {}

class StockReportLoaded extends StockReportState {
  final List<StockReportModel> products;

  StockReportLoaded(this.products);
}

class StockReportError extends StockReportState {
  final String message;

  StockReportError(this.message);
}