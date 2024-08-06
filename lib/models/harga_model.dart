class HargaModel {
  int hargaId;
  int hargaPerKg;

  HargaModel({required this.hargaId, required this.hargaPerKg});

  factory HargaModel.fromMap(Map<String, Object?> map) {
    return HargaModel(
      hargaId: map['hargaId'] as int,
      hargaPerKg: map['hargaPerKg'] as int,
    );
  }
}
