import 'package:open_sisfo_laundry/models/item_model.dart';
import 'package:sqflite/sqflite.dart';

class ItemRepository {
  static const timeDuration = 1;
  static const table = 'Item';
  static const fieldBarangId = 'barangId';
  static const fieldTerimaId = 'terimaId';
  static const fieldNama = 'nama';
  static const fieldJumlah = 'jumlah';

  static Future<void> createTransaction(
      Transaction transaction, int terimaId, List<ItemModel> daftarItem) async {
    return Future<void>.delayed(Duration(seconds: timeDuration), () async {
      try {
        for (ItemModel item in daftarItem) {
          await transaction.insert(table, {
            fieldBarangId: item.barangId,
            fieldTerimaId: terimaId,
            fieldNama: item.nama,
            fieldJumlah: item.jumlah
          });
        }
      } on Exception catch (e) {
        throw Exception(e);
      }
    });
  }
}
