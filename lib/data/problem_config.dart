class Problem {
  final int id;
  final String name;

  Problem({required this.id, required this.name});

  factory Problem.fromJson(Map<String, dynamic> json) {
    return Problem(
      id: json['id'] as int,
      name: json['name'],
    );
  }
}
