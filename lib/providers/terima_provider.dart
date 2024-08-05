import 'package:flutter/material.dart';
import 'package:open_sisfo_laundry/models/terima_model.dart';

class TerimaProvider extends ChangeNotifier {
  final TerimaModel _terima = TerimaModel(
    terimaId: 0,
    nomorTerima: "",
    tanggal: DateTime.now(),
    status: TerimaModel.dicuci,
    namaPelanggan: "",
    teleponPelanggan: "",
    alamatPelanggan: "",
    berat: 1,
    hargaPerKg: 0,
    total: 0,
    dibayar: 0,
    kembali: 0,
    sisa: 0,
    statusPembayaran: TerimaModel.inPayment,
  );

  get terima => _terima.nomorTerima;

  void nomorTerima(String nomorTerima) {
    _terima.nomorTerima = nomorTerima;
    notifyListeners();
  }

  void tanggal(DateTime tanggal) {
    _terima.tanggal = tanggal;
    notifyListeners();
  }

  void berat(int berat) {
    _terima.berat = berat;
    notifyListeners();
  }
}
