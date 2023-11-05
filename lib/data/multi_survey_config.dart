import 'package:jwt_auth/data/multi_answers.dart';

class MultiSurvey {
  final int? id;
  final List<MultiAnswers>? answers;
  final String? question;
  final String? questionEN;
  final String? type;

  MultiSurvey(
      {required this.id,
      this.answers,
      this.question,
      this.questionEN,
      this.type});

  factory MultiSurvey.fromJson(Map<String, dynamic> json) {
    List<MultiAnswers> parsedAnswers = [];

    if (json['answers'] != null) {
      List<dynamic> answersList = json['answers'];

      parsedAnswers = answersList
          .map((answerJson) => MultiAnswers.fromJson(answerJson))
          .toList();
    }

    return MultiSurvey(
        id: json['id'] as int,
        answers: parsedAnswers,
        question: json['question'],
        questionEN: json['questionEN'],
        type: json['type']);
  }
}
