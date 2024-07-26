import 'package:flutter/material.dart';

class SettingsProvider extends InheritedWidget {
  final String selectedDataset;

  const SettingsProvider({
    Key? key,
    required this.selectedDataset,
    required Widget child,
  }) : super(key: key, child: child);

  static SettingsProvider? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<SettingsProvider>();
  }

  @override
  bool updateShouldNotify(SettingsProvider oldWidget) {
    return oldWidget.selectedDataset != selectedDataset;
  }
}
