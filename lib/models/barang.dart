class Barang {
  int barangId;
  String nama;
  String deskripsi;

  Barang({
    required this.barangId,
    required this.nama,
    required this.deskripsi,
  });

  factory Barang.fromMap(Map<String, Object?> map) {
    return Barang(
      barangId: map['barangId'] as int,
      nama: map['nama'] as String,
      deskripsi: map['deskripsi'] as String,
    );
  }
}
