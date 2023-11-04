import 'package:jwt_auth/data/multi_answers.dart';

class MultiSurvey {
  final int? id;
  final List<MultiAnswers>? answers;
  final String? question;
  final String? questionEN;

  MultiSurvey({
    required this.id,
    this.answers,
    this.question,
    this.questionEN,
  });

  factory MultiSurvey.fromJson(Map<String, dynamic> json) {
    return MultiSurvey(
      id: json['ticket'] as int,
      question: json['question'],
      questionEN: json['questionEN'],
    );
  }
}
