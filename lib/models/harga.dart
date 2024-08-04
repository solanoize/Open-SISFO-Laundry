class Harga {
  int hargaId;
  int hargaPerKg;

  Harga({required this.hargaId, required this.hargaPerKg});

  factory Harga.fromMap(Map<String, Object?> map) {
    return Harga(
      hargaId: map['hargaId'] as int,
      hargaPerKg: map['hargaPerKg'] as int,
    );
  }
}
