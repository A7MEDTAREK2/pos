import '../../feature/setting/data/model/users_model.dart';

class UserSession {
  UserSession._();

  static UserModel? currentUser;

  static bool get isLoggedIn => currentUser != null;

  static bool get isRootAdmin => currentUser?.id == 1;

  static void login(UserModel user) {
    currentUser = user;
  }

  static void logout() {
    currentUser = null;
  }

  static void refresh(UserModel user) {
    currentUser = user;
  }
}