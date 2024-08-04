class Terima {
  int terimaId;
  String nomorTerima;
  DateTime tanggal;
  String status;
  String namaPelanggan;
  String teleponPelanggan;
  String alamatPelanggan;
  int berat;
  int hargaPerKg;
  int total;
  int dibayar;
  int kembali;
  int sisa;
  String statusPembayaran;

  static const String dicuci = 'Dicuci';
  static const String selesai = 'Selesai';
  static const String diambil = 'Diambil';

  static const String lunas = 'Lunas';
  static const String downPayment = 'Down Payment';

  Terima({
    required this.terimaId,
    required this.nomorTerima,
    required this.tanggal,
    required this.status,
    required this.namaPelanggan,
    required this.teleponPelanggan,
    required this.alamatPelanggan,
    required this.berat,
    required this.hargaPerKg,
    required this.total,
    required this.dibayar,
    required this.kembali,
    required this.sisa,
    required this.statusPembayaran,
  });

  factory Terima.fromMap(Map<String, Object?> map) {
    return Terima(
      terimaId: map['terimaId'] as int,
      nomorTerima: map['nomorTerima'] as String,
      tanggal: map['tanggal'] as DateTime,
      status: map['status'] as String,
      namaPelanggan: map['namaPelanggan'] as String,
      teleponPelanggan: map['teleponPelanggan'] as String,
      alamatPelanggan: map['alamatPelanggan'] as String,
      berat: map['berat'] as int,
      hargaPerKg: map['hargaPerKg'] as int,
      total: map['total'] as int,
      dibayar: map['dibayar'] as int,
      kembali: map['kembali'] as int,
      sisa: map['sisa'] as int,
      statusPembayaran: map['statusPembayaran'] as String,
    );
  }
}
