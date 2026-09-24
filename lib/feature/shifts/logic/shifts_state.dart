
import '../data/model/CashTransactionModel.dart';
import '../data/model/shifts.dart';

abstract class ShiftState {}

class ShiftInitial extends ShiftState {}

class ShiftLoading extends ShiftState {}

class ShiftLoaded extends ShiftState {
  final ShiftModel? activeShift;
  final List<CashTransactionModel> transactions;

  ShiftLoaded({this.activeShift, required this.transactions});
}

class ShiftOperationSuccess extends ShiftState {
  final String message;
  ShiftOperationSuccess(this.message);
}

class ShiftError extends ShiftState {
  final String message;
  ShiftError(this.message);
}