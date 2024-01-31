// import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'dart:io' as io;
import 'dart:io' show Platform;
import 'package:shop_app/model/cart_model.dart';

class DBHelper {
  static Database? _database;

  Future<Database?> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await initDatabase();
    return null;
  }

  initDatabase() async {
    // Get the current platform
    if(Platform.isWindows || Platform.isLinux){
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    }
    io.Directory directory = await getApplicationDocumentsDirectory();
    String path = p.join(directory.path, 'cart.db');
    var db = await openDatabase(path, version: 2, onCreate: _onCreate, onUpgrade: _onUpgrade);
    return db;
  }

  _onCreate(Database db, int version) async {
    await db.execute(
        'CREATE TABLE cart(id INTEGER PRIMARY KEY, productId VARCHAR, productName TEXT, initialPrice INTEGER, productPrice INTEGER, quantity INTEGER, unitTag TEXT, image TEXT)');
  }

  _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // Drop the existing table
      await db.execute('DROP TABLE IF EXISTS cart');

      // Create the new table
      await db.execute('CREATE TABLE cart(id INTEGER PRIMARY KEY, productId VARCHAR, productName TEXT, initialPrice INTEGER, productPrice INTEGER, quantity INTEGER, unitTag TEXT, image TEXT)');
    }
  }

  Future<Cart> insert(Cart cart) async {
    var dbClient = await database;
    await dbClient!.insert('cart', cart.toMap());
    return cart;
  }

  Future<List<Cart>> getCartList() async {
    var dbClient = await database;
    if (dbClient == null) {
      // Handle the case where the database is null, e.g., return an empty list.
      return [];
    } else {
      final List<Map<String, Object?>> queryResult =
      await dbClient.query('cart');
      return queryResult.map((result) => Cart.fromMap(result)).toList();
    }

  }

  Future<int> deleteCartItem(int id) async {
    var dbClient = await database;
    return await dbClient!.delete('cart', where: 'id = ?', whereArgs: [id]);
  }

   Future<int> deleteCart() async {
    var dbClient = await database;
    return await dbClient!.delete('cart');
  }

  Future<int> updateQuantity(Cart cart) async {
    var dbClient = await database;
    return await dbClient!.update('cart', cart.quantityMap(),
        where: "productId = ?", whereArgs: [cart.productId]);
  }

  Future<List<Cart>> getCartId(int id) async {
    var dbClient = await database;
    final List<Map<String, Object?>> queryIdResult =
        await dbClient!.query('cart', where: 'id = ?', whereArgs: [id]);
    return queryIdResult.map((e) => Cart.fromMap(e)).toList();
  }
}
