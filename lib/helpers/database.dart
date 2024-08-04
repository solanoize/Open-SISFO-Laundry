import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static void initTableBarang(Database db) {
    String sql = '''CREATE TABLE Barang (
      barangId INTEGER PRIMARY KEY AUTOINCREMENT,
      nama VARCHAR NOT NULL,
      deskripsi TEXT NOT NULL
    );''';

    db.execute(sql);
  }

  static void initTableHarga(Database db) {
    String sql = '''CREATE TABLE Harga (
      hargaId INTEGER PRIMARY KEY AUTOINCREMENT,
      hargaPerKg INTEGER NOT NULL
    );''';

    db.execute(sql);
  }

  static void initTableTerima(Database db) {
    String sql = '''CREATE TABLE Terima (
      terimaId INTEGER PRIMARY KEY AUTOINCREMENT,
      nomorTerima VARCHAR UNIQUE NOT NULL,
      tanggal DATE NOT NULL,
      status VARCHAR NOT NULL,
      namaPelanggan VARCHAR NOT NULL,
      teleponPelanggan VARCHAR NOT NULL,
      alamatPelanggan VARCHAR NOT NULL,
      berat INTEGER NOT NULL,
      hargaPerKg INTEGER NOT NULL,
      total INTEGER NOT NULL,
      dibayar INTEGER NOT NULL,
      kembali INTEGER NOT NULL,
      sisa INTEGER NOT NULL,
      statusPembayaran VARCHAR NOT NULL
    );''';

    db.execute(sql);
  }

  static void initTableItem(Database db) {
    String sql = '''CREATE TABLE Item (
      itemId INTEGER PRIMARY KEY AUTOINCREMENT,
      barangId INTEGER NOT NULL,
      terimaId INTEGER NOT NULL,
      nama VARCHAR NOT NULL,
      jumlah INTEGER NOT NULL,
      CONSTRAINT fk_item_barang FOREIGN KEY (barangId) REFERENCES Barang(barangId),
      CONSTRAINT fk_item_terima FOREIGN KEY (terimaId) REFERENCES Terima(terimaId)
    );''';

    db.execute(sql);
  }

  static void initDataHarga(Database db) {
    db.rawInsert("""INSERT INTO Harga (hargaPerKg) VALUES (10000);""");
  }

  static void initDataBarang(Database db) {
    db.rawInsert(
        "INSERT INTO Barang (nama, deskripsi) VALUES ('Kemeja', 'Layanan pencucian untuk kemeja');");
    db.rawInsert(
        "INSERT INTO Barang (nama, deskripsi) VALUES ('Kaos', 'Layanan pencucian untuk kaos');");
    db.rawInsert(
        "INSERT INTO Barang (nama, deskripsi) VALUES ('Celana', 'Layanan pencucian untuk celana');");
    db.rawInsert(
        "INSERT INTO Barang (nama, deskripsi) VALUES ('Jaket', 'Layanan pencucian untuk jaket');");
    db.rawInsert(
        "INSERT INTO Barang (nama, deskripsi) VALUES ('Sweater', 'Layanan pencucian untuk sweater');");
    db.rawInsert(
        "INSERT INTO Barang (nama, deskripsi) VALUES ('Rok', 'Layanan pencucian untuk rok');");
    db.rawInsert(
        "INSERT INTO Barang (nama, deskripsi) VALUES ('Blouse', 'Layanan pencucian untuk blouse');");
    db.rawInsert(
        "INSERT INTO Barang (nama, deskripsi) VALUES ('Gaun', 'Layanan pencucian untuk gaun');");
    db.rawInsert(
        "INSERT INTO Barang (nama, deskripsi) VALUES ('Piyama', 'Layanan pencucian untuk piyama');");
    db.rawInsert(
        "INSERT INTO Barang (nama, deskripsi) VALUES ('Seragam', 'Layanan pencucian untuk seragam');");
    db.rawInsert(
        "INSERT INTO Barang (nama, deskripsi) VALUES ('Topi', 'Layanan pencucian untuk topi');");
    db.rawInsert(
        "INSERT INTO Barang (nama, deskripsi) VALUES ('Sarung Tangan', 'Layanan pencucian untuk sarung tangan');");
    db.rawInsert(
        "INSERT INTO Barang (nama, deskripsi) VALUES ('Syal', 'Layanan pencucian untuk syal');");
    db.rawInsert(
        "INSERT INTO Barang (nama, deskripsi) VALUES ('Celana Pendek', 'Layanan pencucian untuk celana pendek');");
    db.rawInsert(
        "INSERT INTO Barang (nama, deskripsi) VALUES ('Rompi', 'Layanan pencucian untuk rompi');");
    db.rawInsert(
        "INSERT INTO Barang (nama, deskripsi) VALUES ('Jas', 'Layanan pencucian untuk jas');");
    db.rawInsert(
        "INSERT INTO Barang (nama, deskripsi) VALUES ('Kebaya', 'Layanan pencucian untuk kebaya');");
    db.rawInsert(
        "INSERT INTO Barang (nama, deskripsi) VALUES ('Kain', 'Layanan pencucian untuk kain');");
    db.rawInsert(
        "INSERT INTO Barang (nama, deskripsi) VALUES ('Batik', 'Layanan pencucian untuk batik');");
    db.rawInsert(
        "INSERT INTO Barang (nama, deskripsi) VALUES ('Sarung', 'Layanan pencucian untuk sarung');");
  }

  static Future<Database> initDB() async {
    final db = openDatabase(
      join(await getDatabasesPath(), 'osl.db'),
      onCreate: (db, version) {
        DatabaseHelper.initTableBarang(db);
        DatabaseHelper.initTableHarga(db);
        DatabaseHelper.initTableTerima(db);
        DatabaseHelper.initTableItem(db);
        DatabaseHelper.initDataHarga(db);
        DatabaseHelper.initDataBarang(db);
      },
      version: 1,
    );
    return db;
  }
}
