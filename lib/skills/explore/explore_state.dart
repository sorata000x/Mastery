import 'package:flutter/material.dart';

class ExploreState with ChangeNotifier {
  int _selected = 0;
  List _categories = [
    'Core',
    'Professional',
    'Social',
    'Other'
  ];
  List _rarities = ['Mythic', 'Legendary', 'Rare', 'Uncommon', 'Common'];

  int get selected => _selected;
  List get categories => _categories;
  List get rarities => _rarities;

  void setSelected(value) {
    _selected = value;
    notifyListeners();
  }
}
