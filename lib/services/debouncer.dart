import 'package:flutter/material.dart';

class Debouncer {
  bool _isButtonDisabled = false;

  Future<void> run(VoidCallback callback) async {
    if (!_isButtonDisabled) {
      _isButtonDisabled = true;
      callback();
      await Future.delayed(
        const Duration(seconds: 2),
      );
      _isButtonDisabled = false;
    }
  }
}
