import '../datasorce/UserLocalDataSource.dart';
import '../model/users_model.dart';

class UserRepository {
  final UserLocalDataSource _localDataSource = UserLocalDataSource();

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
  }

  Future<void> updateUser(UserModel user) async {
    await _localDataSource.updateUser(user);
  }

  Future<void> deleteUser(int id) async {
    await _localDataSource.deleteUser(id);
  }
  Future<UserModel?> login(
      String username,
      String password,
      ) async {
    return await _localDataSource.login(
      username,
      password,
    );
  }
}