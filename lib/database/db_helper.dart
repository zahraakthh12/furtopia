import 'package:furtopia/model/pet_model.dart';
import 'package:furtopia/model/user_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:path/path.dart';

class DBHelper {
  static const tableUser = 'users';
  static const tablePet = 'pet';
  static Future<Database> db() async {
    final dbPath = await getDatabasesPath();
    return openDatabase(
      join(dbPath, 'furtopia_user_database.db'),
      onCreate: (db, version) async {
        return db.execute(
          "CREATE TABLE $tableUser (id INTEGER PRIMARY KEY AUTOINCREMENT, fullname TEXT, email TEXT, phone TEXT, password TEXT)",
        );
      },

      onUpgrade: (db, oldVersion, newVersion) async {
        if (newVersion == 2) {
          await db.execute(
            "CREATE TABLE $tablePet(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, type TEXT, gender TEXT, age TEXT, color TEXT, weight TEXT, length TEXT)",
          );
        }
      },

      version: 1,
    );
  }

  // REGISTER USER
  static Future<void> registerUser(UserModel user) async {
    final dbs = await db();
    await dbs.insert(
      tableUser,
      user.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    print(user.toMap());
  }

  // LOGIN USER
  static Future<UserModel?> loginUser({
    required String email,
    required String password,
  }) async {
    final dbs = await db();
    //query adalah fungsi untuk menampilkan data (READ)
    final List<Map<String, dynamic>> results = await dbs.query(
      tableUser,
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );
    if (results.isNotEmpty) {
      return UserModel.fromMap(results.first);
    }
    return null;
  }

  // MENDAPATKAN DATA USER
  static Future<List<UserModel>> getAllUser() async {
    final dbs = await db();
    final List<Map<String, dynamic>> results = await dbs.query(tableUser);
    print(results.map((e) => UserModel.fromMap(e)).toList());
    return results.map((e) => UserModel.fromMap(e)).toList();
  }

    //UPDATE USER
  static Future<void> updateUser(UserModel user) async {
    final dbs = await db();
    //Insert adalah fungsi untuk menambahkan data (CREATE)
    await dbs.update(
      tableUser,
      user.toMap(),
      where: "id = ?",
      whereArgs: [user.id],
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    print(user.toMap());
  }

  //DELETE USER
  static Future<void> deleteUser(int id) async {
    final dbs = await db();
    //Insert adalah fungsi untuk menambahkan data (CREATE)
    await dbs.delete(tableUser, where: "id = ?", whereArgs: [id]);
  }


  // MENAMBAHKAN HEWAN
  static Future<void> createPet(PetModel pet) async {
    final dbs = await db();
    await dbs.insert(
      tablePet,
      pet.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    print(pet.toMap());
  }

  // MENDAPATKAN DATA HEWAN
  static Future<List<PetModel>> getAllPet() async {
    final dbs = await db();
    final List<Map<String, dynamic>> results = await dbs.query(tablePet);
    print(results.map((e) => PetModel.fromMap(e)).toList());
    return results.map((e) => PetModel.fromMap(e)).toList();
  }

    //UPDATE Pet
  static Future<void> updatePet(PetModel pet) async {
    final dbs = await db();
    //Insert adalah fungsi untuk menambahkan data (CREATE)
    await dbs.update(
      tablePet,
      pet.toMap(),
      where: "id = ?",
      whereArgs: [pet.id],
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    print(pet.toMap());
  }

  //DELETE Pet
  static Future<void> deletePet(int id) async {
    final dbs = await db();
    //Insert adalah fungsi untuk menambahkan data (CREATE)
    await dbs.delete(tablePet, where: "id = ?", whereArgs: [id]);
  }
}