import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';

import '../../../core/data_base/pos_database.dart';
import '../../../core/service/user_session.dart';
import '../data/model/users_model.dart';
import '../data/repo/repo_user.dart';
import 'user_state.dart';


class UserCubit extends Cubit<UserState>{

  final UserRepository repository;


  UserCubit(this.repository)
      : super(UserInitial());



  List<UserModel> users = [];



  Future<void> loadUsers() async {

    try{

      emit(UserLoading());

      users = await repository.getUsers();
      print("USERS COUNT => ${users.length}");

      emit(UsersLoaded(users));

    }catch(e){

      emit(
        UserError(
          e.toString(),
        ),
      );

    }

  }




  Future<void> addUser(UserModel user) async {
    try {
      await repository.addUser(user);

      await loadUsers();

      emit(UserAdded());

    } catch (e) {
      emit(
        UserError(
          e.toString(),
        ),
      );
    }
  }


  Future<void> updateUser(UserModel user) async {
    try {
      await repository.updateUser(user);

      // لو المستخدم الحالي هو اللي اتعدل
      if (UserSession.currentUser?.id == user.id) {
        final refreshedUser =
        await repository.getUserById(user.id!);

        if (refreshedUser != null) {
          UserSession.refresh(refreshedUser);
        }
      }

      await loadUsers();

      emit(UserUpdated());
    } catch (e) {
      emit(
        UserError(
          e.toString(),
        ),
      );
    }
  }



  Future<void> deleteUser(int id) async {

    try{

      await repository.deleteUser(id);

      await loadUsers();

      emit(UserDeleted());

    }catch(e){

      emit(
        UserError(
          e.toString(),
        ),
      );

    }

  }




  Future<UserModel?> login(
      String username,
      String password,
      ) async {


    final user =
    await repository.getUserByUsername(username);



    if(user == null){

      return null;

    }



    if(user.password != password){

      return null;

    }



    if(!user.isActive){

      return null;

    }


    return user;

  }



}