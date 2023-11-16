import 'package:flutter/material.dart';

class ErrorDialog extends StatelessWidget {
  final String line1;
  final String? line2;
  final String? line3;

  const ErrorDialog({super.key, required this.line1, this.line2, this.line3});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('رسالة الخطأ'),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(line1),
          Text(line2 ?? ''),
          Text(line3 ?? ''),
        ],
      ),
      actions: [
        TextButton(
          child: const Text('حسنا'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
