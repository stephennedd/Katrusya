import 'package:flutter/material.dart';

class BottomBarProvider with ChangeNotifier {
  int _activePageIndex = 0;
  bool _isTeacherMode = false;

  int get activePageIndex => _activePageIndex;
  bool get isTeacherMode => _isTeacherMode;

  set activePageIndex(int value) {
    _activePageIndex = value;
    notifyListeners();
  }

  set isTeacherMode(bool value) {
    _isTeacherMode = value;
    notifyListeners();
  }
}