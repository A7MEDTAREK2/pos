import 'package:sqflite/sqflite.dart';

import '../../../../../core/data_base/pos_database.dart';
import '../model/users_model.dart';


class UserLocalDataSource {


  Future<List<UserModel>> getUsers() async {

    final Database db =
    await AppDatabase.instance.database;


    final result = await db.query(
      "users",
      orderBy: "id DESC",
    );


    return result
        .map(
          (e) => UserModel.fromMap(e),
    )
        .toList();
  }



  Future<void> addUser(UserModel user) async {
    final db = await AppDatabase.instance.database;

    print(user.toMap());

    await db.insert(
      "users",
      user.toMap(),
    );

    final users = await db.query("users");

    print(users);
  }



  Future<void> updateUser(UserModel user) async {
    final db = await AppDatabase.instance.database;

    print("UPDATE USER => ${user.toMap()}");
    print("UPDATE ID => ${user.id}");

    final rows = await db.update(
      "users",
      user.toMap(),
      where: "id = ?",
      whereArgs: [user.id],
    );

    print("UPDATED ROWS => $rows");

    final result = await db.query(
      "users",
      where: "id = ?",
      whereArgs: [user.id],
    );

    print("USER AFTER UPDATE => $result");
  }




  Future<void> deleteUser(int id) async {

    final Database db =
    await AppDatabase.instance.database;


    await db.delete(
      "users",
      where: "id = ?",
      whereArgs: [
        id,
      ],
    );
  }



  // ==========================
  // Login
  // ==========================

  Future<UserModel?> login(
      String username,
      String password,
      ) async {

    final Database db =
    await AppDatabase.instance.database;


    print("LOGIN USER => $username");
    print("LOGIN PASS => $password");


    final result = await db.query(
      "users",
      where: "username = ? AND password = ? AND is_active = 1",
      whereArgs: [
        username,
        password,
      ],
    );


    print("LOGIN RESULT => $result");


    if(result.isEmpty){
      return null;
    }


    return UserModel.fromMap(
      result.first,
    );
  }



  // ==========================
  // Get User By Username
  // ==========================

  Future<UserModel?> getUserByUsername(
      String username,
      ) async {

    final Database db =
    await AppDatabase.instance.database;


    final result = await db.query(
      "users",
      where: "username = ?",
      whereArgs: [
        username,
      ],
    );


    if(result.isEmpty){
      return null;
    }


    return UserModel.fromMap(
      result.first,
    );
  }
  Future<UserModel?> getUserById(int id) async {
    final Database db = await AppDatabase.instance.database;

    final result = await db.query(
      "users",
      where: "id = ?",
      whereArgs: [id],
    );

    if (result.isEmpty) {
      return null;
    }

    return UserModel.fromMap(result.first);
  }

}