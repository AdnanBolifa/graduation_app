class MultiAnswers {
  final int id;
  final String text;

  MultiAnswers({required this.id, required this.text});

  factory MultiAnswers.fromJson(Map<String, dynamic> json) {
    return MultiAnswers(
      id: json['id'] as int,
      text: json['text'],
    );
  }
}
