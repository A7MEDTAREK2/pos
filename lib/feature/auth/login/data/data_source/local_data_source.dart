// import '../../../../../core/data_base/pos_database.dart';
// import '../../../../setting/data/model/users_model.dart';
//
// class AuthLocalDataSource {
//
//   Future<UserModel?> login(
//       String username,
//       String password,
//       ) async {
//
//     final db = await AppDatabase.instance.database;
//
//     print("Database Opened");
//
//     final result = await db.query(
//       'users',
//       where: 'username = ? AND password = ?',
//       whereArgs: [
//         username,
//         password,
//       ],
//     );
//
//     if (result.isNotEmpty) {
//       return UserModel.fromMap(result.first);
//     }
//
//     return null;
//   }
// }