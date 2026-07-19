import 'package:equatable/equatable.dart';

import '../data/model/sale_model.dart';

abstract class SaleDetailsState extends Equatable {
  const SaleDetailsState();

  @override
  List<Object?> get props => [];
}

class SaleDetailsInitial extends SaleDetailsState {}

class SaleDetailsLoading extends SaleDetailsState {}

class SaleDetailsSuccess extends SaleDetailsState {
  final SalesHistoryModel sale;
  final List<SaleItemModel> items;

  const SaleDetailsSuccess({
    required this.sale,
    required this.items,
  });

  @override
  List<Object?> get props => [
    sale,
    items,
  ];
}

class SaleDetailsError extends SaleDetailsState {
  final String message;

  const SaleDetailsError(this.message);

  @override
  List<Object?> get props => [message];
}