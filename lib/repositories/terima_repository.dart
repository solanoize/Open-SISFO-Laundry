import 'package:open_sisfo_laundry/helpers/database.dart';
import 'package:open_sisfo_laundry/models/terima_model.dart';
import 'package:sqflite/sqflite.dart';

class TerimaRepository {
  static const timeDuration = 1;
  static const table = "Terima";
  static const fieldTerimaId = 'terimaId';
  static const fieldNomorTerima = 'nomorTerima';
  static const fieldTanggal = 'tanggal';
  static const fieldStatus = 'status';
  static const fieldNamaPelanggan = 'namaPelanggan';
  static const fieldTeleponPelanggan = 'teleponPelanggan';
  static const fieldAlamatPelanggan = 'alamatPelanggan';
  static const fieldBerat = 'berat';
  static const fieldHargaPerKg = 'hargaPerKg';
  static const fieldTotal = 'total';
  static const fieldDibayar = 'dibayar';
  static const fieldKembali = 'kembali';
  static const fieldSisa = 'sisa';
  static const fieldStatusPembayaran = 'statusPembayaran';

  static Future<bool> isUniqueNomorTerima({required String nomorTerima}) {
    return Future<bool>.delayed(const Duration(seconds: timeDuration),
        () async {
      Database db = await DatabaseHelper.initDB();
      String sql = 'SELECT * FROM $table WHERE $fieldNomorTerima = ?';
      List<Map<String, Object?>> map = await db.rawQuery(sql, [nomorTerima]);
      if (map.isNotEmpty) {
        throw Exception("Nomor terima sudah ada");
      }

      return true;
    });
  }
}
