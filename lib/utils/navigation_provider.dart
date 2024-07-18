import 'package:flutter/material.dart';

class NavigationProvider extends ChangeNotifier {
  String _selectedMenu = '/products';

  String get selectedMenu => _selectedMenu;

  void updateSelectedMenu(String menu) {
    _selectedMenu = menu;
    notifyListeners();
  }
}
