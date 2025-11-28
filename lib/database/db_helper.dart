import 'package:furtopia/model/sql/clinic_model.dart';
import 'package:furtopia/model/sql/pet_model.dart';
import 'package:furtopia/model/sql/shop_model.dart';
import 'package:furtopia/model/sql/user_model.dart';
import 'package:furtopia/preferences/preference_handler.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:path/path.dart';

class DBHelper {
  static const tableUser = 'users';
  static const tablePet = 'pet';
  static const tableClinic = 'clinic';
  static const tableShop= 'shop';
  static Future<Database> db() async {
    final dbPath = await getDatabasesPath();
    return openDatabase(
      join(dbPath, 'furtopia_user_database.db'),
      onCreate: (db, version) async {  
          await db.execute(
            "CREATE TABLE $tablePet(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, type TEXT, gender TEXT, age TEXT, color TEXT, weight TEXT, length TEXT, icon TEXT)",
          );
          await db.execute(
            "CREATE TABLE $tableClinic(id INTEGER PRIMARY KEY AUTOINCREMENT, service TEXT, servicetype TEXT, schedule TEXT)",
          );
          await db.execute(
            "CREATE TABLE $tableShop(id INTEGER PRIMARY KEY AUTOINCREMENT, product TEXT, category TEXT, price TEXT, image TEXT)",
          );
          await db.execute(
            "CREATE TABLE $tableUser (id INTEGER PRIMARY KEY AUTOINCREMENT, fullname TEXT, email TEXT, phone TEXT, password TEXT)",
          );
      },

      // onUpgrade: (db, oldVersion, newVersion) async {
      //   if (newVersion == 2) {
      //     await db.execute(
      //       "CREATE TABLE $tablePet(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, type TEXT, gender TEXT, age TEXT, color TEXT, weight TEXT, length TEXT, icon TEXT)",
      //     );
      //   } else     if (newVersion == 3) {
      //     await db.execute(
      //       "CREATE TABLE $tablePet(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, type TEXT, gender TEXT, age TEXT, color TEXT, weight TEXT, length TEXT, icon TEXT)",
      //     );
      //   }
      // },

      version: 4,
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
    final List<Map<String, dynamic>> results = await dbs.query(
      tableUser,
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );
    if (results.isNotEmpty) {
      final data = UserModel.fromMap(results.first);
      PreferenceHandler.saveID(data.id!);
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
    await dbs.delete(tableUser, where: "id = ?", whereArgs: [id]);
  }

  //GET USER ID
  static Future<UserModel?> getUser(int id) async {
    final dbInstance = await db();
    final List<Map<String, dynamic>> results = await dbInstance.query(
      tableUser,
      where: 'id = ?',
      whereArgs: [id],
    );
    print(results);
    if (results.isNotEmpty){
      return UserModel.fromMap(results.first);
    }
    return null;
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
    await dbs.delete(tablePet, where: "id = ?", whereArgs: [id]);
  }


    // MENAMBAHKAN BOOKING
  static Future<void> createBooking(ClinicModel clinic) async {
    final dbs = await db();
    await dbs.insert(
      tableClinic,
      clinic.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    print(clinic.toMap());
  }

  // MENDAPATKAN DATA BOOKING
  static Future<List<ClinicModel>> getAllBooking() async {
    final dbs = await db();
    final List<Map<String, dynamic>> results = await dbs.query(tableClinic);
    print(results.map((e) => ClinicModel.fromMap(e)).toList());
    return results.map((e) => ClinicModel.fromMap(e)).toList();
  }

    //UPDATE BOOKING
  static Future<void> updateBooking(ClinicModel clinic) async {
    final dbs = await db();
    await dbs.update(
      tableClinic,
      clinic.toMap(),
      where: "id = ?",
      whereArgs: [clinic.id],
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    print(clinic.toMap());
  }

  //DELETE BOOKING
  static Future<void> deleteBooking(int id) async {
    final dbs = await db();
    //Insert adalah fungsi untuk menambahkan data (CREATE)
    await dbs.delete(tableClinic, where: "id = ?", whereArgs: [id]);
  }


      // MENAMBAHKAN ORDER
  static Future<void> createOrder(ShopModel shop) async {
    final dbs = await db();
    await dbs.insert(
      tableShop,
      shop.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    print(shop.toMap());
  }

  // MENDAPATKAN DATA BOOKING
  static Future<List<ShopModel>> getAllOrder() async {
    final dbs = await db();
    final List<Map<String, dynamic>> results = await dbs.query(tableShop);
    print(results.map((e) => ShopModel.fromMap(e)).toList());
    return results.map((e) => ShopModel.fromMap(e)).toList();
  }

    //UPDATE BOOKING
  static Future<void> updateOrder(ShopModel shop) async {
    final dbs = await db();
    await dbs.update(
      tableShop,
      shop.toMap(),
      where: "id = ?",
      whereArgs: [shop.id],
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    print(shop.toMap());
  }

  //DELETE BOOKING
  static Future<void> deleteOrder(int id) async {
    final dbs = await db();
    await dbs.delete(tableShop, where: "id = ?", whereArgs: [id]);
  }
}