import '../data/model/users_model.dart';


abstract class UserState {}


class UserInitial extends UserState {}

class UserLoading extends UserState {}


class UsersLoaded extends UserState {

  final List<UserModel> users;

  UsersLoaded(this.users);

}


class UserAdded extends UserState {}

class UserUpdated extends UserState {}

class UserDeleted extends UserState {}


class UserError extends UserState {

  final String message;

  UserError(this.message);

}