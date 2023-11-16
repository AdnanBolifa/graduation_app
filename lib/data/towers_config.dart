import 'package:jwt_auth/data/sectors_config.dart';

class Tower {
  final int id;
  String name;
  List<Sector>? sectors;

  Tower({required this.id, required this.name, this.sectors});

  factory Tower.fromJson(Map<String, dynamic> json) {
    return Tower(
      id: json['id'] as int,
      name: json['name'],
    );
  }
}
