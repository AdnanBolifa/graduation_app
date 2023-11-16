class Sector {
  final int id;
  String name;
  final int tower;
  Sector({required this.id, required this.name, required this.tower});

  factory Sector.fromJson(Map<String, dynamic> json) {
    return Sector(
      id: json['id'] as int,
      name: json['name'],
      tower: json['tower'],
    );
  }
}
