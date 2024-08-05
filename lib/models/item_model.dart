class ItemModel {
  int itemId;
  int barangId;
  int terimaId;
  String nama;
  int jumlah;

  ItemModel({
    required this.itemId,
    required this.barangId,
    required this.terimaId,
    required this.nama,
    required this.jumlah,
  });

  factory ItemModel.fromMap(Map<String, Object?> map) {
    return ItemModel(
      itemId: map['itemId'] as int,
      barangId: map['barangId'] as int,
      terimaId: map['terimaId'] as int,
      nama: map['nama'] as String,
      jumlah: map['jumlah'] as int,
    );
  }
}
