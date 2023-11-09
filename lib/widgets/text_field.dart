import 'package:flutter/material.dart';

Widget textReports(
  String label,
  String hint,
  String value,
  TextEditingController controller,
  void Function(String) onChangedCallback,
) {
  return Column(
    children: [
      Directionality(
        textDirection: TextDirection.rtl,
        child: TextField(
          controller: controller,
          textDirection: TextDirection.rtl,
          textAlign: TextAlign.right,
          decoration: InputDecoration(
            hintTextDirection: TextDirection.rtl,
            labelText: label,
            hintText: hint,
            labelStyle: const TextStyle(fontSize: 16, color: Colors.grey),
            hintStyle: const TextStyle(fontSize: 14, color: Colors.grey),
            contentPadding: const EdgeInsets.all(16.0),
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.grey, width: 1.0),
              borderRadius: BorderRadius.circular(5.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.blue, width: 2.0),
              borderRadius: BorderRadius.circular(5.0),
            ),
          ),
          onChanged: onChangedCallback,
        ),
      ),
      const SizedBox(height: 16.0),
    ],
  );
}

Widget textField(
    String label, String hint, TextEditingController onChangedCallback,
    {double? width, double? height, bool? isHide}) {
  return Column(
    children: [
      Directionality(
        textDirection: TextDirection.rtl,
        child: SizedBox(
          width: width,
          height: height,
          child: TextField(
            obscureText: isHide ?? false,
            controller: onChangedCallback,
            decoration: InputDecoration(
              labelText: label,
              hintStyle: const TextStyle(fontSize: 14, color: Colors.grey),
              hintText: hint,
              border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(5)),
              ),
            ),
          ),
        ),
      ),
      const SizedBox(height: 10.0), // Add a SizedBox for spacing
    ],
  );
}
