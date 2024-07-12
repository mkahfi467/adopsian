class PopOffer {
  final int id;
  int user_id;
  String nama_binatang;
  String jenis_hewan;
  String keterangan;

  PopOffer({
    required this.id,
    required this.user_id,
    required this.nama_binatang,
    required this.jenis_hewan,
    required this.keterangan,
  });

  factory PopOffer.fromJson(Map<String, dynamic> json) {
    return PopOffer(
      id: json['id'] as int,
      user_id: json['user_id'] as int,
      nama_binatang: json['nama_binatang'] as String,
      jenis_hewan: json['jenis_hewan'] as String,
      keterangan: json['keterangan'] as String,
    );
  }
}
