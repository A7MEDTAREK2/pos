import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../setting/data/model/users_model.dart';
import '../data/repo/local_rapo.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {

  final AuthRepository repository;

  AuthCubit(this.repository) : super(AuthInitial());


  Future<void> login(
      String username,
      String password,
      ) async {

    emit(AuthLoading());


    final UserModel? user = await repository.login(
      username,
      password,
    );


    if (user != null) {
      emit(AuthSuccess(user));
    } else {
      emit(
        AuthError(
          "Invalid username or password",
        ),
      );
    }
  }
}