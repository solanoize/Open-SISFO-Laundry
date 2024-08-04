import 'package:open_sisfo_laundry/helpers/database.dart';
import 'package:open_sisfo_laundry/models/Barang.dart';
import 'package:sqflite/sqflite.dart';

class BarangRepository {
  static const table = "Barang";
  static const fieldBarangId = "barangId";
  static const fieldNama = "nama";
  static const fieldDeskripsi = "deskripsi";

  static Future<Barang> read({required int barangId}) async {
    Database db = await DatabaseHelper.initDB();
    String sql = 'SELECT * FROM $table WHERE $fieldBarangId=?';
    List<Map<String, Object?>> map = await db.rawQuery(sql, [barangId]);

    if (map.isEmpty) {
      throw Exception("Barang tidak ditemukan");
    }

    db.close();
    return Barang.fromMap(map.first);
  }

  static Future<List<Barang>> reads() async {
    Database db = await DatabaseHelper.initDB();
    String sql = 'SELECT * FROM $table ORDER BY $fieldBarangId DESC LIMIT 10;';
    List<Map<String, Object?>> map = await db.rawQuery(sql);

    // db.close();

    return [
      for (final {
            'barangId': barangId as int,
            'nama': nama as String,
            'deskripsi': deskripsi as String
          } in map)
        Barang(
          barangId: barangId,
          nama: nama,
          deskripsi: deskripsi,
        )
    ];
  }

  static Future<Barang> create({
    required String nama,
    required String deskripsi,
  }) async {
    Database db = await DatabaseHelper.initDB();
    String sql = '''INSERT INTO 
      Barang ($fieldNama, $fieldDeskripsi) 
      VALUES(?, ?);
    ''';
    int barangId = await db.rawInsert(sql, [nama, deskripsi]);

    if (barangId == 0) {
      throw Exception("Barang tidak dapat disimpan");
    }

    Barang barang = await read(barangId: barangId);

    db.close();
    return barang;
  }

  static Future<List<Barang>> filterByNama({required String nama}) async {
    Database db = await DatabaseHelper.initDB();
    String sql =
        'SELECT * FROM $table WHERE nama LIKE ? ORDER BY $fieldBarangId DESC LIMIT 10;';
    List<Map<String, Object?>> map = await db.rawQuery(sql);

    db.close();

    return [
      for (final {
            'barangId': barangId as int,
            'nama': nama as String,
            'deskripsi': deskripsi as String
          } in map)
        Barang(
          barangId: barangId,
          nama: nama,
          deskripsi: deskripsi,
        )
    ];
  }
}
