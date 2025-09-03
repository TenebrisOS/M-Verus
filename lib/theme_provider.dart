import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  bool isDark = false;
  MaterialColor seedColor = Colors.green;
  String vrscAddress = '';

  ThemeMode get themeMode => isDark ? ThemeMode.dark : ThemeMode.light;

  ThemeData get theme => ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: seedColor,
      brightness: isDark ? Brightness.dark : Brightness.light,
    ),
    useMaterial3: true,
  );

  void toggleDark(bool value) {
    isDark = value;
    notifyListeners();
  }

  void setSeedColor(MaterialColor color) {
    seedColor = color;
    notifyListeners();
  }

  void setVRSCAddress(String address) {
    vrscAddress = address;
    notifyListeners();
  }
}
