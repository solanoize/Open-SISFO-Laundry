import 'package:flutter/material.dart';
import 'package:open_sisfo_laundry/models/barang_model.dart';
import 'package:open_sisfo_laundry/models/item_model.dart';

class ItemProvider extends ChangeNotifier {
  final List<ItemModel> _items = <ItemModel>[];

  void add(BarangModel barang, int count) {
    if (_isDuplicate(barang.barangId)) {
      // get item
      int index =
          _items.indexWhere((value) => value.barangId == barang.barangId);

      if (_items[index].jumlah + count <= 0) {
        _items.removeAt(index);
      } else {
        _items[index].jumlah += count;
      }
    } else {
      ItemModel newItem = ItemModel(
        itemId: 0,
        barangId: barang.barangId,
        terimaId: 0,
        nama: barang.nama,
        jumlah: 1,
      );
      _items.add(newItem);
    }

    notifyListeners();
  }

  int getTotal(int barangId) {
    if (_isDuplicate(barangId)) {
      int index = _items.indexWhere((value) => value.barangId == barangId);
      return _items[index].jumlah;
    }

    return 0;
  }

  bool get isValidCart => _items.isNotEmpty;

  bool _isDuplicate(int barangId) {
    return _items.any((ItemModel value) => value.barangId == barangId);
  }
}
