import 'package:flutter/material.dart';
import 'package:jwt_auth/data/history_config.dart';

class HistoryCard extends StatefulWidget {
  final History ticket;

  const HistoryCard({Key? key, required this.ticket}) : super(key: key);

  @override
  State<HistoryCard> createState() => _TicketCardState();
}

class _TicketCardState extends State<HistoryCard> {
  String getPredictionText(int predictionResult) {
    return predictionResult == 1
        ? 'Heart Disease Detected'
        : 'No Heart Disease Detected';
  }

  Color getColorForPrediction(int predictionResult) {
    return predictionResult == 1 ? Colors.red : Colors.green;
  }

  @override
  Widget build(BuildContext context) {
    MaterialColor nullFeed = Colors.red;
    MaterialColor closed = Colors.green;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Stack(
        children: [
          Card(
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Container(
              decoration: widget.ticket.status != null
                  ? BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    )
                  : null,
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${widget.ticket.patientName} | ${widget.ticket.age} years old',
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                    textDirection: TextDirection.ltr,
                  ),
                  widget.ticket.sex == 0
                      ? const Text(
                          'Female',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                          textDirection: TextDirection.ltr,
                        )
                      : const Text(
                          'Male',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                          textDirection: TextDirection.ltr,
                        ),
                  const SizedBox(height: 5),
                  Text(
                    getPredictionText(widget.ticket.prediction_result),
                    style: TextStyle(
                      fontSize: 16,
                      color: getColorForPrediction(
                          widget.ticket.prediction_result),
                      fontWeight: FontWeight.bold,
                    ),
                    textDirection: TextDirection.ltr,
                  ),
                  const SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (widget.ticket.status == null)
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: IconButton(
                              onPressed: () {
                                // Handle dismiss action
                              },
                              icon: const Icon(
                                Icons.close,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      if (widget.ticket.status == null)
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: IconButton(
                              onPressed: () {
                                // Handle accept action
                              },
                              icon: const Icon(
                                Icons.check,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 15,
            right: 12,
            child: Container(
              width: 15,
              height: 15,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: widget.ticket.status == null ? nullFeed : closed,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
