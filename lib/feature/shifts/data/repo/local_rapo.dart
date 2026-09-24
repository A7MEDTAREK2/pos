import 'package:dartz/dartz.dart';

import '../data_source/local_data_source.dart';
import '../model/CashTransactionModel.dart';
import '../model/shifts.dart';
import 'failure.dart';

abstract class ShiftRepository {
  Future<Either<Failure, ShiftModel?>> getCurrentActiveShift();

  Future<Either<Failure, int>> openShift({
    required int userId,
    required double openingCash,
  });

  Future<Either<Failure, void>> addCashTransaction({
    required CashTransactionModel transaction,
  });

  Future<Either<Failure, List<CashTransactionModel>>>
  getShiftTransactions(int shiftId);

  Future<Either<Failure, void>> closeShift({
    required int shiftId,
    required double actualCash,
    required double expectedCash,
    required String? closingNote,
    required int userId,
    required String userName,
  });
}

class ShiftRepositoryImpl implements ShiftRepository {
  final ShiftsLocalDataSource localDataSource;

  ShiftRepositoryImpl({
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, ShiftModel?>>
  getCurrentActiveShift() async {
    try {
      final shift =
      await localDataSource.getCurrentActiveShift();

      return Right(shift);
    } catch (e) {
      return Left(
        DatabaseFailure(e.toString()),
      );
    }
  }

  @override
  Future<Either<Failure, int>> openShift({
    required int userId,
    required double openingCash,
  }) async {
    try {
      final shiftId =
      await localDataSource.openShift(
        userId: userId,
        openingCash: openingCash,
      );

      return Right(shiftId);
    } catch (e) {
      return Left(
        DatabaseFailure(e.toString()),
      );
    }
  }

  @override
  Future<Either<Failure, void>> addCashTransaction({
    required CashTransactionModel transaction,
  }) async {
    try {
      await localDataSource.addCashTransaction(
        transaction,
      );

      return const Right(null);
    } catch (e) {
      return Left(
        DatabaseFailure(e.toString()),
      );
    }
  }

  @override
  Future<Either<Failure, List<CashTransactionModel>>>
  getShiftTransactions(
      int shiftId,
      ) async {
    try {
      final transactions =
      await localDataSource.getShiftTransactions(
        shiftId,
      );

      return Right(transactions);
    } catch (e) {
      return Left(
        DatabaseFailure(e.toString()),
      );
    }
  }

  @override
  Future<Either<Failure, void>> closeShift({
    required int shiftId,
    required double actualCash,
    required double expectedCash,
    required String? closingNote,
    required int userId,
    required String userName,
  }) async {
    try {
      await localDataSource.closeShift(
        shiftId: shiftId,
        actualCash: actualCash,
        expectedCash: expectedCash,
        closingNote: closingNote,
        userId: userId,
        userName: userName,
      );

      return const Right(null);
    } catch (e) {
      return Left(
        DatabaseFailure(e.toString()),
      );
    }
  }
}