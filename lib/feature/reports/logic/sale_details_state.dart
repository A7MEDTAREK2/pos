import '../data/model/sale_detail_report.dart';

abstract class SaleDetailssState {}

class SaleDetailsInitial extends SaleDetailssState {}

class SaleDetailsLoading extends SaleDetailssState {}

class SaleDetailsLoaded extends SaleDetailssState {
  final SaleDetailsModel sale;

  SaleDetailsLoaded(this.sale);
}

class SaleDetailsError extends SaleDetailssState {
  final String message;

  SaleDetailsError(this.message);
}