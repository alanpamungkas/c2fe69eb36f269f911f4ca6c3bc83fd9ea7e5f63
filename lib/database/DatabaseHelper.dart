import 'dart:async';
import 'package:kulinapreliminarytest/models/Product.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io' show Directory;
import 'package:path_provider/path_provider.dart' show getApplicationDocumentsDirectory;

class DatabaseHelper {

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database _database;
  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  static final _databaseName = "ProductsDB.db";
  static final _databaseVersion = 1;

  static final tableName = 'products';

  static final columnId = 'id';
  static final columnName = 'name';
  static final columnImage = 'image_url';
  static final columnBrand = 'brand_name';
  static final columnPackage = 'package_name';
  static final columnPrice = 'price';
  static final columnRating = 'rating';
  static final columnQty = 'qty';
  static final columnDate = 'date';

  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);

    return await openDatabase(path,
        version: _databaseVersion,
        onCreate: (db, version) {
          return db.execute(
            "CREATE TABLE IF NOT EXISTS $tableName($columnId INTEGER PRIMARY KEY, $columnName TEXT,"
                "$columnImage TEXT, $columnBrand TEXT, $columnPackage TEXT, $columnDate TEXT DEFAULT '0',"
                " $columnPrice INTEGER, $columnRating DOUBLE, $columnQty INTEGER DEFAULT '0')",
          );
        },
    );
  }

  Future<List<Product>> getAll() async {
    final Database db = await database;

    final List<Map<String, dynamic>> maps = await db.query(tableName, orderBy: '$columnDate ASC, $columnId ASC');

    return List.generate(maps.length, (index) {
      return Product.fromJson(maps[index]);
    });
  }

  Future<int> getProductQty(int id) async {
    final Database db = await database;

    List<String> columnsToSelect = [
      DatabaseHelper.columnId,
      DatabaseHelper.columnName,
      DatabaseHelper.columnImage,
      DatabaseHelper.columnBrand,
      DatabaseHelper.columnPackage,
      DatabaseHelper.columnPrice,
      DatabaseHelper.columnRating,
      DatabaseHelper.columnQty,
    ];

    String whereString = '$columnId = ?';

    List<dynamic> whereArguments = [id];

    List<Map> result = await db.query(
        '$tableName',
        columns: columnsToSelect,
        where: whereString,
        whereArgs: whereArguments);

    if(result.isEmpty)
      return 0;
    else
      return Product.fromJson(result[0]).qty;
  }

  Future<List<int>> getTotalQty() async {
    final Database db = await database;

    List<Map> result = await db.query(tableName);

    int sumQty = 0;
    int sumPrice = 0;

    result.forEach((row) => sumQty += Product.fromJson(row).qty);
    result.forEach((row) => sumPrice += (Product.fromJson(row).price * Product.fromJson(row).qty));

    List<int> list = List();
    list.add(sumQty);
    list.add(sumPrice);

    return list;
  }

  Future<void> deleteAll() async {
    final Database db = await database;

    await db.delete(tableName);
  }

  Future<void> insertDB(Product product) async {
    final Database db = await database;

    await db.insert(
      '$tableName',
      product.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateDB(Product product) async {
    final db = await database;

    await db.update(
      '$tableName',
      product.toJson(),

      where: "id = ?",
      whereArgs: [product.id],
    );
  }

  Future<void> deleteDB(int id) async {
    final db = await database;

    await db.delete(
      '$tableName',

      where: "id = ?",
      whereArgs: [id],
    );
  }
}