// ignore_for_file: non_constant_identifier_names

import 'package:chatetan_duit/model/anggaran.dart';
import 'package:chatetan_duit/model/investasi.dart';
import 'package:chatetan_duit/model/pemasukan.dart';
import 'package:chatetan_duit/model/pengeluaran.dart';
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
  final String tableNameJurnal = 'Pemasukan';
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
  // table pemasukan
  final String tableNamePemasukan = 'tablePemasukan';
  final String columnMasukJumlah = 'jumlah';
  final String columnMasukDeskripsi = 'deskripsi';
  final String columnMasukTanggal = 'tanggal';
  // table pengeluaran
  final String tableNamePengeluaran = 'tablePengeluaran';
  final String columnKeluarJumlah = 'jumlah';
  final String columnKeluarDeskripsi = 'deskripsi';
  final String columnKeluarTanggal = 'tanggal';
  // table investasi
  final String tableNameInvestasi = 'tableInvestasi';
  final String columnInvestPlatfom = 'platfom';
  final String columnInvestJumlah = 'jumlah';
  final String columnInvestPeriodeBagi = 'periodebagi';
  final String columnInvestTanggal = 'tanggal';
  final String columnInvestDeskripsi = 'deskripsi';
  // table utang
  final String tableNameUtang = 'tableUtang';
  final String columnUtangDeskripsi = 'deskripsi';
  final String columnUtangJumlah = 'jumlah';
  final String columnUtangJatuhTempo = 'jatuhtempo';

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

    var sqlPemasukan =
        "CREATE TABLE $tableNamePemasukan($columnId INTEGER PRIMARY KEY,"
        "$columnMasukJumlah INTEGER,"
        "$columnMasukDeskripsi TEXT,"
        "$columnMasukTanggal DATE"
        ")";

    var sqlPengeluaran =
        "CREATE TABLE $tableNamePengeluaran($columnId INTEGER PRIMARY KEY,"
        "$columnKeluarJumlah INTEGER,"
        "$columnKeluarDeskripsi TEXT,"
        "$columnKeluarTanggal DATE,"
        "$columnAnggaranId INTEGER,"
        "FOREIGN KEY ($columnAnggaranId) REFERENCES $tableNameAnggaran($columnId))";

    var sqlInvestasi =
        "CREATE TABLE $tableNameInvestasi($columnId INTEGER PRIMARY KEY,"
        "$columnInvestPlatfom TEXT,"
        "$columnInvestJumlah INTEGER,"
        "$columnInvestPeriodeBagi TEXT,"
        "$columnInvestDeskripsi TEXT,"
        "$columnInvestTanggal DATE)";

    var sqlUtang = "CREATE TABLE $tableNameUtang($columnId INTEGER PRIMARY KEY,"
        "$columnUtangDeskripsi TEXT,"
        "$columnUtangJumlah INTEGER,"
        "$columnUtangJatuhTempo DATE"
        ")";

    await db.execute(sqlJurnal);
    await db.execute(sql);
    await db.execute(sqlAnggaran);
    await db.execute(sqlTagihan);
    await db.execute(sqlPemasukan);
    await db.execute(sqlPengeluaran);
    await db.execute(sqlInvestasi);
    await db.execute(sqlUtang);
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

  // save pemasukan
  Future<int?> savePemasukan(Pemasukan pemasukan) async {
    var dbClient = await _db;
    return await dbClient!.insert(tableNamePemasukan, pemasukan.toMap());
  }

  // save pengeluaran
  Future<int?> savePengeluaran(Pengeluaran pengeluaran) async {
    var dbClient = await _db;
    return await dbClient!.insert(tableNamePengeluaran, pengeluaran.toMap());
  }

  // save investasi
  Future<int?> saveInvestasi(Investasi investasi) async {
    var dbClient = await _db;
    return await dbClient!.insert(tableNameInvestasi, investasi.toMap());
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

  // get id anggaran
  Future<dynamic> getIdAnggaran() async {
    var dt = DateTime.now();
    int tahun = dt.year;
    int bulan = dt.month;
    var dbClient = await _db;
    var curId = Sqflite.firstIntValue(await dbClient!.rawQuery(
        'SELECT $columnId FROM $tableNameAnggaran WHERE bulan=? and tahun=?',
        [bulan, tahun]));
    return curId;
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

  // get data jurnal
  Future<List?> getAnggaran() async {
    var dt = DateTime.now();
    int tahun = dt.year;
    int bulan = dt.month;
    var dbClient = await _db;
    var result = await dbClient!.query(
      tableNameAnggaran,
      columns: [
        columnId,
        columnAnggBulan,
        columnAnggTahun,
        columnAnggJumlah,
        columnAnggDate,
        columnAnggJumlahPakai
      ],
      where: '$columnAnggBulan = ? and $columnAnggTahun = ?',
      whereArgs: [bulan, tahun],
    );
    return result.toList();
  }

  // get data tagihan
  Future<List?> getAllTagihan() async {
    var dbClient = await _db;
    var result = await dbClient!.query(tableNameTagihan, columns: [
      columnId,
      columnTagihDeskripsi,
      columnTagihJumlah,
      columnTagihPeringatan,
      columnTagihPeringatan,
    ]);
    return result.toList();
  }

  // get data pemasukan
  Future<List?> getPemasukan() async {
    var dbClient = await _db;
    var result = await dbClient!.query(tableNamePemasukan, columns: [
      columnId,
      columnMasukJumlah,
      columnMasukDeskripsi,
      columnMasukTanggal,
    ]);
    return result.toList();
  }

  // get data pengeluaran
  Future<List?> getPengeluaran() async {
    var dbClient = await _db;
    var result = await dbClient!.query(tableNamePengeluaran, columns: [
      columnId,
      columnKeluarJumlah,
      columnKeluarDeskripsi,
      columnKeluarTanggal,
      columnAnggaranId,
    ]);
    return result.toList();
  }

  Future<List?> getPengeluaranPerbulan(int idAnggaran) async {
    var dbClient = await _db;
    var result = await dbClient!.query(
      tableNamePengeluaran,
      columns: [
        columnId,
        columnKeluarJumlah,
        columnKeluarDeskripsi,
        columnKeluarTanggal,
        columnAnggaranId,
      ],
      where: '$columnAnggaranId = ?',
      whereArgs: [idAnggaran],
    );
    return result.toList();
  }

  // get data investasi
  Future<List?> getInvestasi() async {
    var dbClient = await _db;
    var result = await dbClient!.query(tableNameInvestasi, columns: [
      columnId,
      columnInvestPlatfom,
      columnInvestJumlah,
      columnInvestPeriodeBagi,
      columnInvestDeskripsi,
      columnInvestTanggal,
    ]);
    return result.toList();
  }

  Future<dynamic> getTotalPemasukan() async {
    var dbClient = await _db;
    var total = Sqflite.firstIntValue(await dbClient!
        .rawQuery('SELECT SUM(jumlah) as total FROM $tableNamePemasukan'));
    total ??= 0;
    return total;
  }

  Future<dynamic> getTotalPengeluaranPerbulan(int idAnggaran) async {
    var dbClient = await _db;
    var total = Sqflite.firstIntValue(await dbClient!.rawQuery(
        'SELECT SUM(jumlah) as total FROM $tableNamePengeluaran WHERE $columnAnggaranId = ?',
        [idAnggaran]));
    total ??= 0;
    return total;
  }

  Future<dynamic> getTotalPengeluaran() async {
    var dbClient = await _db;
    var total = Sqflite.firstIntValue(await dbClient!
        .rawQuery('SELECT SUM(jumlah) as total FROM $tableNamePengeluaran'));
    total ??= 0;
    return total;
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
    return await dbClient!.update(
      tableNameJurnal,
      jurnal.toMap(),
      where: '$columnId = ?',
      whereArgs: [jurnal.id],
    );
  }

  // update data anggaran
  Future<int?> updateAnggaran(Anggaran anggaran) async {
    var dbClient = await _db;
    return await dbClient!.update(
      tableNameAnggaran,
      anggaran.toMap(),
      where: '$columnId = ?',
      whereArgs: [anggaran.id],
    );
  }

  // update data tagihan
  Future<int?> updateTagihan(Tagihan tagihan) async {
    var dbClient = await _db;
    return await dbClient!.update(
      tableNameTagihan,
      tagihan.toMap(),
      where: '$columnId = ?',
      whereArgs: [tagihan.id],
    );
  }

  // update data pemasukan
  Future<int?> updatePemasukan(Pemasukan pemasukan) async {
    var dbClient = await _db;
    return await dbClient!.update(
      tableNamePemasukan,
      pemasukan.toMap(),
      where: '$columnId = ?',
      whereArgs: [pemasukan.id],
    );
  }

  // update data pengeluaran
  Future<int?> updatePengeluaran(Pengeluaran pengeluaran) async {
    var dbClient = await _db;
    return await dbClient!.update(
      tableNamePengeluaran,
      pengeluaran.toMap(),
      where: '$columnId = ?',
      whereArgs: [pengeluaran.id],
    );
  }

  // update data investasi
  Future<int?> updateInvestasi(Investasi investasi) async {
    var dbClient = await _db;
    return await dbClient!.update(
      tableNameInvestasi,
      investasi.toMap(),
      where: '$columnId = ?',
      whereArgs: [investasi.id],
    );
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

  // delete data pemasukan
  Future<int?> deletePemasukan(int id) async {
    var dbClient = await _db;
    return await dbClient!
        .delete(tableNamePemasukan, where: '$columnId = ?', whereArgs: [id]);
  }

  // delete data pengeluaran
  Future<int?> deletePengeluaran(int id) async {
    var dbClient = await _db;
    return await dbClient!
        .delete(tableNamePengeluaran, where: '$columnId = ?', whereArgs: [id]);
  }

  // delete data investasi
  Future<int?> deleteInvestasi(int id) async {
    var dbClient = await _db;
    return await dbClient!
        .delete(tableNameInvestasi, where: '$columnId = ?', whereArgs: [id]);
  }
}
