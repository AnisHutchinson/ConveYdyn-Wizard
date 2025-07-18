import 'package:flutter/material.dart';

class PageManager extends ChangeNotifier {
  int _currentPage = 0;
  int _straightPage = 0;
  int _curvedPage = 0;
  static bool back = false;
  static bool backHome = false;
  static bool Fromstraight = false;

  int get currentPage => _currentPage;
  int get straightPage => _straightPage;
  int get curvedPage => _curvedPage;
  //ool get backHome => _backHome;

  void updatePage(int index) {
    _currentPage = index;
    notifyListeners(); // Dit aux widgets : "Hey, j’ai changé !"
  }

  void updateStraightPage(int index) {
    _straightPage = index;
    notifyListeners(); // Dit aux widgets : "Hey, j’ai changé !"
  }

  void updateCurvedPage(int index) {
    _curvedPage = index;
    notifyListeners(); // Dit aux widgets : "Hey, j’ai changé !"
  }

  void InitStraightPage() {
    _straightPage = 0;
    notifyListeners();
  }
}
