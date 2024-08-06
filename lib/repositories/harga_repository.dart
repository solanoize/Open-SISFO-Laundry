import 'package:open_sisfo_laundry/helpers/database.dart';
import 'package:open_sisfo_laundry/models/harga_model.dart';
import 'package:sqflite/sqflite.dart';

class HargaRepository {
  static const timeDuration = 1;
  static const table = "Harga";
  static const fieldHargaId = 'hargaId';
  static const fieldHargaPerKg = 'hargaPerKg';

  static Future<HargaModel> read() async {
    return Future<HargaModel>.delayed(
      const Duration(seconds: timeDuration),
      () async {
        Database db = await DatabaseHelper.initDB();
        String sql = "SELECT * FROM $table";
        List<Map<String, Object?>> map = await db.rawQuery(sql);
        if (map.isEmpty) {
          return HargaModel(hargaId: 0, hargaPerKg: 10000);
        }

        return HargaModel.fromMap(map.first);
      },
    );
  }
}
