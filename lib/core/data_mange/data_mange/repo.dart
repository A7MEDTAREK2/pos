
import 'local_mange.dart';
import 'model.dart';

class MaintenanceRepository {
  final MaintenanceLocalDataSource local;

  MaintenanceRepository(this.local);

  Future<MaintenanceModel> backupDatabase() async {
    try {
      final path = await local.backupDatabase();

      return MaintenanceModel.success(
        "تم إنشاء النسخة الاحتياطية\n$path",
      );
    } catch (e) {
      return MaintenanceModel.error(e.toString());
    }
  }

  Future<MaintenanceModel> restoreDatabase() async {
    try {
      await local.restoreDatabase();

      return MaintenanceModel.success(
        "تم استرجاع النسخة الاحتياطية بنجاح",
      );
    } catch (e) {
      return MaintenanceModel.error(e.toString());
    }
  }

  Future<MaintenanceModel> deleteSales() async {
    try {
      await local.deleteSales();

      return MaintenanceModel.success(
        "تم حذف جميع المبيعات",
      );
    } catch (e) {
      return MaintenanceModel.error(e.toString());
    }
  }

  Future<MaintenanceModel> deleteCustomers() async {
    try {
      await local.deleteCustomers();

      return MaintenanceModel.success(
        "تم حذف جميع العملاء",
      );
    } catch (e) {
      return MaintenanceModel.error(e.toString());
    }
  }

  Future<MaintenanceModel> deleteAllData() async {
    try {
      await local.deleteAllData();

      return MaintenanceModel.success(
        "تم حذف جميع البيانات",
      );
    } catch (e) {
      return MaintenanceModel.error(e.toString());
    }
  }

  Future<MaintenanceModel> restartShift() async {
    try {
      await local.restartShift();

      return MaintenanceModel.success(
        "تم بدء وردية جديدة",
      );
    } catch (e) {
      return MaintenanceModel.error(e.toString());
    }
  }

  Future<void> closeDatabase() async {
    await local.closeDatabase();
  }
}