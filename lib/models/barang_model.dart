class BarangModel {
  int barangId;
  String nama;
  String deskripsi;

  BarangModel({
    required this.barangId,
    required this.nama,
    required this.deskripsi,
  });

  factory BarangModel.fromMap(Map<String, Object?> map) {
    return BarangModel(
      barangId: map['barangId'] as int,
      nama: map['nama'] as String,
      deskripsi: map['deskripsi'] as String,
    );
  }
}
