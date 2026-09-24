import '../../../../core/service/audit_log_service.dart';
import '../datasorce/UserLocalDataSource.dart';
import '../datasorce/local_data.dart';
import '../model/settings_model.dart';
import '../model/users_model.dart';

class SettingsRepository {
  final SettingsLocalDataSource localDataSource;

  SettingsRepository(this.localDataSource);

  Future<SettingsModel> getSettings() {
    return localDataSource.getSettings();
  }

  Future<void> save(SettingsModel settings) async {
    await localDataSource.saveSettings(settings);

    // 📝 تسجيل حركة تحديث إعدادات النظام
    await AuditLogService.instance.log(
      userId: 1,
      userName: 'مشرف النظام',
      action: 'UPDATE',
      module: 'الإعدادات',
      entityType: 'Settings',
      entityId: '1',
      description: 'تم تحديث إعدادات النظام واسم المتجر أو الطابعة',
    );
  }
}


class UserRepository {
  final UserLocalDataSource _localDataSource;

  UserRepository(this._localDataSource);

  Future<List<UserModel>> getUsers() async {
    return await _localDataSource.getUsers();
  }

  Future<UserModel?> getUserById(int id) async {
    return await _localDataSource.getUserById(id);
  }

  Future<UserModel?> getUserByUsername(String username) async {
    return await _localDataSource.getUserByUsername(username);
  }

  Future<void> addUser(UserModel user) async {
    await _localDataSource.addUser(user);

    // 📝 تسجيل حركة إضافة مستخدم جديد
    await AuditLogService.instance.log(
      userId: user.id ?? 1,
      userName: user.username ?? 'مشرف',
      action: 'CREATE',
      module: 'المستخدمين والصلاحيات',
      entityType: 'User',
      entityId: user.id?.toString() ?? '',
      description: 'تم إضافة مستخدم جديد: ${user.username ?? ""}',
    );
  }

  Future<void> updateUser(UserModel user) async {
    await _localDataSource.updateUser(user);

    // 📝 تسجيل حركة تعديل بيانات مستخدم
    await AuditLogService.instance.log(
      userId: user.id ?? 1,
      userName: user.username ?? 'مشرف',
      action: 'UPDATE',
      module: 'المستخدمين والصلاحيات',
      entityType: 'User',
      entityId: user.id?.toString() ?? '',
      description: 'تم تحديث بيانات المستخدم: ${user.username ?? ""}',
    );
  }

  Future<void> deleteUser(int id) async {
    await _localDataSource.deleteUser(id);

    // 📝 تسجيل حركة حذف مستخدم
    await AuditLogService.instance.log(
      userId: 1,
      userName: 'مشرف النظام',
      action: 'DELETE',
      module: 'المستخدمين والصلاحيات',
      entityType: 'User',
      entityId: id.toString(),
      description: 'تم حذف المستخدم برقم: $id',
    );
  }

  Future<UserModel?> login(
      String username,
      String password,
      ) async {
    final user = await _localDataSource.login(username, password);

    if (user != null) {
      // 📝 تسجيل حركة تسجيل الدخول بنجاح
      await AuditLogService.instance.log(
        userId: user.id ?? 1,
        userName: user.username ?? username,
        action: 'LOGIN',
        module: 'تسجيل الدخول',
        entityType: 'User',
        entityId: user.id?.toString() ?? '',
        description: 'تم تسجيل الدخول بنظام الـ POS بنجاح',
      );
    }

    return user;
  }
}