class League {
  final int id;
  final String name;
  final int adminId;

  League({required this.id, required this.name, required this.adminId});

  factory League.fromJson(Map<String, dynamic> json) {
    return League(
      id: json['id'] as int,
      name: json['name'] as String,
      adminId: json['adminId'] as int,
    );
  }
}
