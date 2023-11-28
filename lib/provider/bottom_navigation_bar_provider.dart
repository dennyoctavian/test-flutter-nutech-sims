import 'package:flutter/material.dart';

class BottomNavigationBarProvider with ChangeNotifier {
  int currentIndex = 0;

  setCurrentIndex(int index) {
    currentIndex = index;
    notifyListeners();
  }

  reset() {
    currentIndex = 0;
    notifyListeners();
  }
}
