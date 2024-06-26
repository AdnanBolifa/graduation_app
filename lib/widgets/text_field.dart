import 'package:flutter/material.dart';

Widget textReports(String label, String hint, String value, TextEditingController controller, void Function(String) onChangedCallback,
    {bool? readOnly}) {
  return Column(
    children: [
      Directionality(
        textDirection: TextDirection.rtl,
        child: TextField(
          readOnly: readOnly ?? false,
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
      const SizedBox(height: 10.0),
    ],
  );
}

Widget textField(String label, String hint, TextEditingController onChangedCallback,
    {double? width, double? height, bool isHide = false, bool isRight = false}) {
  return Column(
    children: [
      Directionality(
        textDirection: isRight == true && isRight != false ? TextDirection.rtl : TextDirection.ltr,
        child: SizedBox(
          width: width,
          height: height,
          child: TextField(
            obscureText: isHide,
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
