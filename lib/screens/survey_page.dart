import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:jwt_auth/data/ticket_config.dart';
import 'package:jwt_auth/screens/home.dart';

class SurveyPage extends StatefulWidget {
  final Ticket? ticket;
  const SurveyPage({Key? key, this.ticket}) : super(key: key);

  @override
  _SurveyPageState createState() => _SurveyPageState();
}

class _SurveyPageState extends State<SurveyPage> {
  int selectedRating = 0;
  Map<int, int> questionRatings = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.language),
            onPressed: () {
              _showLanguagePicker(context);
            },
          ),
        ],
        title: const Text('Survey Page'),
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            for (int i = 1; i <= 5; i++)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Question $i:',
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Row(
                    children: [
                      buildRadio(i, 0),
                      buildRadio(i, 1),
                      buildRadio(i, 2),
                      buildRadio(i, 3),
                    ],
                  ),
                ],
              ),
            const SizedBox(height: 20.0),
            const Text(
              'Overall Rating:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Center(
              child: RatingBar.builder(
                initialRating: selectedRating.toDouble(),
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: false,
                itemCount: 5,
                itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
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
            const SizedBox(height: 20.0),
            const Text(
              'Comments:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            TextFormField(
              maxLines: 4,
              decoration: const InputDecoration(
                hintText: 'Enter your comments...',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.all(12.0),
              ),
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.all(16.0),
              ),
              onPressed: () {
                widget.ticket!.enable = false;
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const HomeScreen(),
                  ),
                );
              },
              child: const Text(
                'Submit',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
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
        Text(getRatingText(value), style: const TextStyle(fontSize: 16)),
      ],
    );
  }

  String getRatingText(int value) {
    switch (value) {
      case 0:
        return 'Bad';
      case 1:
        return 'OK';
      case 2:
        return 'Good';
      case 3:
        return 'Excellent';
      default:
        return 'N/A';
    }
  }

  // Function to show a language picker dialog
  void _showLanguagePicker(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Language').tr(),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                title: const Text('English').tr(),
                onTap: () {
                  context
                      .setLocale(const Locale('en', 'US')); // Switch to English
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('عربى').tr(),
                onTap: () {
                  context
                      .setLocale(const Locale('ar', 'SA')); // Switch to Arabic
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
