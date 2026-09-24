import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home/feature/shifts/logic/shifts_state.dart';
import '../data/model/shifts.dart';
import '../data/model/CashTransactionModel.dart';
import '../data/repo/local_rapo.dart';


class ShiftCubit extends Cubit<ShiftState> {
  final ShiftRepository shiftRepository;

  ShiftCubit({required this.shiftRepository}) : super(ShiftInitial());

  ShiftModel? activeShift;
  List<CashTransactionModel> transactions = [];

  // التحقق من حالة الوردية الحالية
  Future<void> checkActiveShift() async {
    emit(ShiftLoading());
    final result = await shiftRepository.getCurrentActiveShift();

    result.fold(
          (failure) => emit(ShiftError(failure.message)),
          (shift) async {
        activeShift = shift;
        if (shift != null && shift.id != null) {
          await getTransactions(shift.id!);
        } else {
          transactions = [];
          emit(ShiftLoaded(activeShift: null, transactions: []));
        }
      },
    );
  }

  // فتح وردية جديدة
  Future<void> openShift({required int userId, required double openingCash}) async {
    emit(ShiftLoading());
    final result = await shiftRepository.openShift(
      userId: userId,
      openingCash: openingCash,
    );

    result.fold(
          (failure) => emit(ShiftError(failure.message)),
          (shiftId) async {
        emit(ShiftOperationSuccess('تم فتح الوردية بنجاح!'));
        await checkActiveShift();
      },
    );
  }

  // إضافة حركة نقدية (Cash In / Cash Out)
  Future<void> addCashTransaction({
    required int shiftId,
    required int userId,
    required String type, // 'cash_in' or 'cash_out'
    required double amount,
    required String reason,
  }) async {
    emit(ShiftLoading());

    final transaction = CashTransactionModel(
      shiftId: shiftId,
      userId: userId,
      type: type,
      amount: amount,
      reason: reason,
      createdAt: DateTime.now().toIso8601String(),
    );

    final result = await shiftRepository.addCashTransaction(transaction: transaction);

    result.fold(
          (failure) => emit(ShiftError(failure.message)),
          (_) async {
        emit(ShiftOperationSuccess('تم تسجيل الحركة بنجاح!'));
        await checkActiveShift();
      },
    );
  }

  // جلب حركات الوردية
  Future<void> getTransactions(int shiftId) async {
    final result = await shiftRepository.getShiftTransactions(shiftId);

    result.fold(
          (failure) => emit(ShiftError(failure.message)),
          (txs) {
        transactions = txs;
        emit(ShiftLoaded(activeShift: activeShift, transactions: transactions));
      },
    );
  }

  // إغلاق الوردية
  Future<void> closeShift({
    required int shiftId,
    required double actualCash,
    required double expectedCash,
    required String? closingNote,
    required int userId,
    required String userName,
  }) async {
    emit(ShiftLoading());

    final result = await shiftRepository.closeShift(
      shiftId: shiftId,
      actualCash: actualCash,
      expectedCash: expectedCash,
      closingNote: closingNote,
      userId: userId,
      userName: userName,
    );

    result.fold(
          (failure) => emit(ShiftError(failure.message)),
          (_) {
        activeShift = null;
        transactions = [];
        emit(ShiftOperationSuccess('تم إغلاق الوردية بنجاح!'));
        emit(ShiftLoaded(activeShift: null, transactions: []));
      },
    );
  }
}