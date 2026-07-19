import '../../../../setting/data/model/users_model.dart';
import '../../../../setting/data/repo/repo_user.dart';



class AuthRepository {

  final UserRepository userRepository;


  AuthRepository(this.userRepository);



  Future<UserModel?> login(
      String username,
      String password,
      ) {

    return userRepository.login(
      username,
      password,
    );

  }

}