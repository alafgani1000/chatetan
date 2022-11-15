// ignore_for_file: non_constant_identifier_names

import 'package:chatetan_duit/model/profil.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:path/path.dart';

import '../model/jurnal.dart';

class DbProfile {
  static final DbProfile _instance = DbProfile._internal();
  static Database? _database;

  //inisiasi variabel
  final String tableName = 'tabelProfile';
  final String tableNameJurnal = 'tabelJurnal';
  final String columnId = 'id';
  final String columnName = 'name';
  final String columnTipe = 'tipe';
  final String columnJumlah = 'jumlah';
  final String columnDeskripsi = 'deskripsi';
  final String columnTanggal = 'tanggal';

  DbProfile._internal();
  factory DbProfile() => _instance;

  //cek database
  Future<Database?> get _db async {
    if (_database != null) {
      return _database;
    }
    _database = await _initDb();
    return _database;
  }

  Future<Database?> _initDb() async {
    String databasePath = await getDatabasesPath();
    String path = join(databasePath, 'chatetan.db');
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  //membuat tabel dan fieldnya
  Future<void> _onCreate(Database db, int version) async {
    var sql =
        "CREATE TABLE $tableName($columnId INTEGER PRIMARY KEY AUTOINCREMENT,"
        "$columnName TEXT)";

    var sqlJurnal =
        "CREATE TABLE $tableNameJurnal($columnId INTEGER PRIMARY KEY,"
        "$columnTipe TEXT,"
        "$columnJumlah INTEGER,"
        "$columnDeskripsi TEXT,"
        "$columnTanggal DATE)";
    await db.execute(sqlJurnal);
    await db.execute(sql);
  }

  //insert ke databse
  Future<int?> saveProfile(Profil profil) async {
    var dbClient = await _db;
    return await dbClient!.insert(tableName, profil.toMap());
  }

  //read databse
  Future<List?> getProfile() async {
    var dbClient = await _db;
    var result =
        await dbClient!.query(tableName, columns: [columnId, columnName]);

    return result.toList();
  }

  Future<int?> saveJurnal(Jurnal jurnal) async {
    var dbClient = await _db;
    return await dbClient!.insert(tableNameJurnal, jurnal.toMap());
  }

  //read database
  Future<List?> getAllJurnal() async {
    var dbClient = await _db;
    var result = await dbClient!.query(tableNameJurnal, columns: [
      columnId,
      columnTipe,
      columnJumlah,
      columnDeskripsi,
      columnTanggal,
    ]);
    return result.toList();
  }

  //get data pemasukan
  Future<dynamic> getSummaryJurnal() async {
    var dbClient = await _db;
    var pemasukanSummary = Sqflite.firstIntValue(await dbClient!.rawQuery(
        'SELECT SUM(jumlah) as jumlah FROM $tableNameJurnal where tipe=?',
        ['pemasukan']));
    var pengeluaranSummary = Sqflite.firstIntValue(await dbClient.rawQuery(
        'SELECT SUM(jumlah) as jumlah FROM $tableNameJurnal where tipe=?',
        ['pengeluaran']));
    pemasukanSummary ??= 0;
    pengeluaranSummary ??= 0;

    return pemasukanSummary - pengeluaranSummary;
  }

  //update database
  Future<int?> updateJurnal(Jurnal jurnal) async {
    var dbClient = await _db;
    return await dbClient!.update(tableNameJurnal, jurnal.toMap(),
        where: '$columnId = ?', whereArgs: [jurnal.id]);
  }

  Future<int?> deleteJurnal(int id) async {
    var dbClient = await _db;
    return await dbClient!
        .delete(tableNameJurnal, where: '$columnId = ?', whereArgs: [id]);
  }
}
