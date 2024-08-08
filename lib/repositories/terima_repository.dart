import 'package:open_sisfo_laundry/helpers/database.dart';
import 'package:open_sisfo_laundry/providers/item_provider.dart';
import 'package:open_sisfo_laundry/providers/terima_provider.dart';
import 'package:open_sisfo_laundry/repositories/item_repository.dart';
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

  static Future<bool> isUniqueNomorTerima({required String nomorTerima}) async {
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

  static Future<String> generateNomorterima() async {
    return Future<String>.delayed(const Duration(seconds: timeDuration),
        () async {
      Database db = await DatabaseHelper.initDB();
      String sql = 'SELECT COUNT(*) + 1 as count FROM $table;';
      List<Map<String, Object?>> map = await db.rawQuery(sql);
      return "TR${map.first['count'].toString().padLeft(3, "0")}";
    });
  }

  static Future<void> createTransaction(
    TerimaProvider terimaProvider,
    ItemProvider itemProvider,
  ) async {
    return Future<void>.delayed(const Duration(seconds: timeDuration),
        () async {
      try {
        final terima = terimaProvider.terima;
        final daftarItem = itemProvider.items;
        Database db = await DatabaseHelper.initDB();
        await db.transaction((transaction) async {
          int terimaId = await transaction.insert(table, {
            fieldNomorTerima: terima.nomorTerima,
            fieldTanggal: terima.tanggal.toIso8601String(),
            fieldStatus: terima.status,
            fieldNamaPelanggan: terima.namaPelanggan,
            fieldTeleponPelanggan: terima.teleponPelanggan,
            fieldAlamatPelanggan: terima.alamatPelanggan,
            fieldBerat: terima.berat,
            fieldHargaPerKg: terima.hargaPerKg,
            fieldTotal: terima.total,
            fieldDibayar: terima.dibayar,
            fieldKembali: terima.kembali,
            fieldSisa: terima.sisa,
            fieldStatusPembayaran: terima.statusPembayaran
          });
          await ItemRepository.createTransaction(
            transaction,
            terimaId,
            daftarItem,
          );
        });
        itemProvider.clear();
        terimaProvider.clear();
      } on Exception catch (e) {
        throw Exception(e);
      }
    });
  }
}
