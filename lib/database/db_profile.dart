// ignore_for_file: non_constant_identifier_names

import 'package:chatetan_duit/model/anggaran.dart';
import 'package:chatetan_duit/model/profil.dart';
import 'package:chatetan_duit/model/tagihan.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:path/path.dart';

import '../model/jurnal.dart';

class DbProfile {
  static final DbProfile _instance = DbProfile._internal();
  static Database? _database;

  // inisiasi variabel
  // table profile
  final String tableName = 'tabelProfile';
  final String columnId = 'id';
  final String columnName = 'name';
  // table jurnal
  final String tableNameJurnal = 'tabelJurnal';
  final String columnTipe = 'tipe';
  final String columnJumlah = 'jumlah';
  final String columnDeskripsi = 'deskripsi';
  final String columnTanggal = 'tanggal';
  // table anggaran
  final String tableNameAnggaran = 'tableAnggaran';
  final String columnAnggaranId = 'anggaranid';
  final String columnAnggBulan = 'bulan';
  final String columnAnggTahun = 'tahun';
  final String columnAnggJumlah = 'jumlah';
  final String columnAnggJumlahPakai = 'jumlahpakai';
  final String columnAnggDate = 'tanggal';
  // table tagihan
  final String tableNameTagihan = 'tableTagihan';
  final String columnTagihTanggal = 'tanggal';
  final String columnTagihDeskripsi = 'deskripsi';
  final String columnTagihPeringatan = 'peringatan';
  final String columnTagihJumlah = 'jumlah';

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
        "$columnTanggal DATE,"
        "$columnAnggaranId INTEGER,"
        "FOREIGN KEY ($columnAnggaranId) REFERENCES $tableNameAnggaran($columnId))";

    var sqlAnggaran =
        "CREATE TABLE $tableNameAnggaran($columnId INTEGER PRIMARY KEY,"
        "$columnAnggBulan INTEGER,"
        "$columnAnggTahun INTEGER,"
        "$columnAnggJumlah INTEGER,"
        "$columnAnggDate DATE,"
        "$columnAnggJumlahPakai INTEGER DEFAULT 0)";

    var sqlTagihan =
        "CREATE TABLE $tableNameTagihan($columnId INTEGER PRIMARY KEY,"
        "$columnTagihDeskripsi TEXT,"
        "$columnTagihPeringatan INTEGER,"
        "$columnTagihJumlah INTEGER,"
        "$columnTagihTanggal INTEGER)";

    await db.execute(sqlJurnal);
    await db.execute(sql);
    await db.execute(sqlAnggaran);
    await db.execute(sqlTagihan);
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

  // save jurnal
  Future<int?> saveJurnal(Jurnal jurnal) async {
    var dbClient = await _db;
    return await dbClient!.insert(tableNameJurnal, jurnal.toMap());
  }

  // save anggaran
  Future<int?> saveAnggaran(Anggaran anggaran) async {
    var dbClient = await _db;
    return await dbClient!.insert(tableNameAnggaran, anggaran.toMap());
  }

  // save tagihan
  Future<int?> saveTagihan(Tagihan tagihan) async {
    var dbClient = await _db;
    return await dbClient!.insert(tableNameTagihan, tagihan.toMap());
  }

  // get data jurnal
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

  // get data anggaran
  Future<dynamic> getCurrAnggJumlah() async {
    var dt = DateTime.now();
    int tahun = dt.year;
    int bulan = dt.month;
    var dbClient = await _db;
    var currData = Sqflite.firstIntValue(await dbClient!.rawQuery(
        'SELECT jumlah FROM $tableNameAnggaran WHERE bulan=? and tahun=?',
        [bulan, tahun]));
    return currData;
  }

  Future<dynamic> getCurrAnggJump() async {
    var dt = DateTime.now();
    int tahun = dt.year;
    int bulan = dt.month;
    var dbClient = await _db;
    var currData = Sqflite.firstIntValue(await dbClient!.rawQuery(
        'SELECT jumlahpakai FROM $tableNameAnggaran WHERE bulan=? and tahun=?',
        [bulan, tahun]));
    return currData;
  }

  // get data tagihan
  Future<List?> getAllTagihan() async {
    var dbClient = await _db;
    var result = await dbClient!.query(tableNameTagihan, columns: [
      columnId,
      columnTagihDeskripsi,
      columnTagihJumlah,
      columnTagihPeringatan,
      columnTagihPeringatan
    ]);
    return result.toList();
  }

  // get data pemasukan
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

  // update data
  // update data jurnal
  Future<int?> updateJurnal(Jurnal jurnal) async {
    var dbClient = await _db;
    return await dbClient!.update(tableNameJurnal, jurnal.toMap(),
        where: '$columnId = ?', whereArgs: [jurnal.id]);
  }

  // update data anggaran
  Future<int?> updateAnggaran(Anggaran anggaran) async {
    var dbClient = await _db;
    return await dbClient!.update(tableNameAnggaran, anggaran.toMap(),
        where: '$columnId = ?', whereArgs: [anggaran.id]);
  }

  // update data tagihan
  Future<int?> updateTagihan(Tagihan tagihan) async {
    var dbClient = await _db;
    return await dbClient!.update(tableNameTagihan, tagihan.toMap(),
        where: '$columnId = ?', whereArgs: [tagihan.id]);
  }

  // delete data
  // delete data jurnal
  Future<int?> deleteJurnal(int id) async {
    var dbClient = await _db;
    return await dbClient!
        .delete(tableNameJurnal, where: '$columnId = ?', whereArgs: [id]);
  }

  // delete data anggaran
  Future<int?> deleteAnggaran(int id) async {
    var dbClient = await _db;
    return await dbClient!
        .delete(tableNameAnggaran, where: '$columnId = ?', whereArgs: [id]);
  }

  // delete data tagihan
  Future<int?> deleteTagihan(int id) async {
    var dbClient = await _db;
    return await dbClient!
        .delete(tableNameTagihan, where: '$columnId = ?', whereArgs: [id]);
  }
}
