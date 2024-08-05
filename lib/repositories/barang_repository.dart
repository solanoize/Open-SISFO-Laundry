import 'package:open_sisfo_laundry/helpers/database.dart';
import 'package:open_sisfo_laundry/models/barang_model.dart';
import 'package:sqflite/sqflite.dart';

class BarangRepository {
  static const timeDuration = 1;
  static const table = "Barang";
  static const fieldBarangId = "barangId";
  static const fieldNama = "nama";
  static const fieldDeskripsi = "deskripsi";

  static Future<BarangModel> read({required int barangId}) async {
    return Future<BarangModel>.delayed(const Duration(seconds: timeDuration),
        () async {
      Database db = await DatabaseHelper.initDB();
      String sql = 'SELECT * FROM $table WHERE $fieldBarangId=?';
      List<Map<String, Object?>> map = await db.rawQuery(sql, [barangId]);

      if (map.isEmpty) {
        throw Exception("Barang tidak ditemukan");
      }

      db.close();
      return BarangModel.fromMap(map.first);
    });
  }

  static Future<List<BarangModel>> reads() async {
    return Future<List<BarangModel>>.delayed(
        const Duration(seconds: timeDuration), () async {
      Database db = await DatabaseHelper.initDB();
      String sql =
          'SELECT * FROM $table ORDER BY $fieldBarangId DESC LIMIT 10;';
      List<Map<String, Object?>> map = await db.rawQuery(sql);

      db.close();

      return [
        for (final {
              'barangId': barangId as int,
              'nama': nama as String,
              'deskripsi': deskripsi as String
            } in map)
          BarangModel(
            barangId: barangId,
            nama: nama,
            deskripsi: deskripsi,
          )
      ];
    });
  }

  static Future<BarangModel> create({
    required String nama,
    required String deskripsi,
  }) async {
    return Future<BarangModel>.delayed(const Duration(seconds: timeDuration),
        () async {
      // throw Exception("Barang tidak dapat disimpan");  // For test
      Database db = await DatabaseHelper.initDB();
      String sql = '''INSERT INTO 
        $table ($fieldNama, $fieldDeskripsi) 
        VALUES(?, ?);
      ''';
      int barangId = await db.rawInsert(sql, [nama, deskripsi]);

      if (barangId == 0) {
        throw Exception("Barang tidak dapat disimpan");
      }

      BarangModel barang = await read(barangId: barangId);

      db.close();
      return barang;
    });
  }

  static Future<BarangModel> update({
    required int barangId,
    required String nama,
    required String deskripsi,
  }) async {
    return Future<BarangModel>.delayed(const Duration(seconds: timeDuration),
        () async {
      Database db = await DatabaseHelper.initDB();
      String sql =
          'UPDATE $table SET $fieldNama = ?, $fieldDeskripsi = ? WHERE $fieldBarangId=?';

      int result = await db.rawUpdate(sql, [nama, deskripsi, barangId]);

      if (result == 0) {
        throw Exception("Barang tidak dapat diupdate");
      }

      BarangModel barang = await read(barangId: barangId);

      db.close();
      return barang;
    });
  }

  static Future<bool> delete({required int barangId}) async {
    return Future<bool>.delayed(const Duration(seconds: timeDuration),
        () async {
      Database db = await DatabaseHelper.initDB();
      String sql = 'DELETE FROM $table WHERE $fieldBarangId = ?';
      int result = await db.rawDelete(sql, [barangId]);

      if (result == 0) {
        throw Exception("Barang tidak dapat dihapus");
      }

      db.close();
      return true;
    });
  }

  static Future<List<BarangModel>> filterByNama({required String nama}) async {
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
        BarangModel(
          barangId: barangId,
          nama: nama,
          deskripsi: deskripsi,
        )
    ];
  }
}
