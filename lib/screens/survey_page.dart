import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:jwt_auth/data/multi_survey_config.dart';
import 'package:jwt_auth/data/ticket_config.dart';
import 'package:jwt_auth/screens/home.dart';
import 'package:jwt_auth/services/api_service.dart';

class SurveyPage extends StatefulWidget {
  final Ticket? ticket;
  const SurveyPage({Key? key, this.ticket}) : super(key: key);

  @override
  _SurveyPageState createState() => _SurveyPageState();
}

class _SurveyPageState extends State<SurveyPage> {
  int selectedRating = 0;
  Map<int, int> questionRatings = {};
  List<String> answers = [];
  List<MultiSurvey> survey = [];
  final notes = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getSurvey();
  }

  Future<void> _getSurvey() async {
    final multi = await ApiService().fetchSurvey();
    setState(() {
      survey = multi;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('الاستبيان'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                for (int i = 0; i < survey.length; i++)
                  Padding(
                    padding: const EdgeInsets.only(left: 8, right: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${survey[i].question}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Wrap(
                          children: [
                            for (int j = 0; j < survey[i].answers!.length; j++)
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  buildRadio(i, j),
                                  Text(
                                    survey[i].answers![j].text,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                          ],
                        ),
                        //todo 2v make all the fields required
                        if (survey[i].type == 'rating')
                          Center(
                            child: RatingBar.builder(
                              initialRating: selectedRating.toDouble(),
                              minRating: 1,
                              direction: Axis.horizontal,
                              allowHalfRating: false,
                              itemCount: 5,
                              itemPadding:
                                  const EdgeInsets.symmetric(horizontal: 4.0),
                              itemBuilder: (context, _) => const Icon(
                                Icons.star,
                                color: Colors.amber,
                              ),
                              onRatingUpdate: (rating) {
                                setState(() {
                                  selectedRating = rating.toInt();
                                });
                              },
                            ),
                          ),
                        const SizedBox(height: 10),
                        if (survey[i].type == 'text')
                          TextFormField(
                            controller: notes,
                            maxLines: 4,
                            decoration: const InputDecoration(
                              hintText: 'اضف ملاحظاتك',
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.all(12.0),
                            ),
                          ),
                      ],
                    ),
                  ),
                const SizedBox(height: 20.0),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.all(16.0),
                  ),
                  onPressed: () async {
                    List<Map<String, dynamic>> answersList = [];

                    for (int i = 0; i < survey.length - 2; i++) {
                      if (questionRatings.containsKey(i)) {
                        int answer = questionRatings[i]!;
                        answersList.add({
                          "question": survey[i].id,
                          "answer": answer,
                        });
                      } else {
                        String answer = answers[i];
                        answersList.add({
                          "question": survey[i].id,
                          "answer": answer,
                        });
                      }
                    }
                    answersList.add({
                      "question": survey[survey.length - 2].id,
                      "answer": selectedRating,
                    });
                    answersList.add({
                      "question": survey[survey.length - 1].id,
                      "answer": notes.text,
                    });
                    await ApiService()
                        .submitSurvey(widget.ticket!.id, answersList);
                    if (context.mounted) {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const HomeScreen()));
                    }
                  },
                  child: const Text(
                    'إرسال',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildRadio(int question, int value) {
    return Row(
      children: [
        Radio(
          value: value,
          groupValue: questionRatings[question] ?? -1,
          onChanged: (int? rating) {
            setState(() {
              questionRatings[question] = rating!;
            });
          },
        ),
      ],
    );
  }
}
