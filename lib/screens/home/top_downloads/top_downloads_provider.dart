import 'package:flutter/material.dart';

class TopDownloadsProvider with ChangeNotifier {
  String _currentButton = '1';
  set setCurrentButton(String id) {
    _currentButton = id;
    notifyListeners();
  }

  Color getButtonColor(String id) =>
      _currentButton == id ? Colors.green[700] : Colors.white;
  Color getButtonTextColor(String id) =>
      _currentButton == id ? Colors.white : Colors.green[900];
}
