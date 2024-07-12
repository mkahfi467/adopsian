class PopPropose {
  final int id;
  int user_id;
  int offer_id;
  String pesan;
  int status;

  PopPropose({
    required this.id,
    required this.user_id,
    required this.offer_id,
    required this.pesan,
    required this.status,
  });

  factory PopPropose.fromJson(Map<String, dynamic> json) {
    return PopPropose(
      id: json['id'] as int,
      user_id: json['user_id'] as int,
      offer_id: json['offer_id'] as int,
      pesan: json['pesan'] as String,
      status: json['status'] as int,
    );
  }
}
