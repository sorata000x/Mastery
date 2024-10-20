import 'package:flutter/material.dart';

class ExploreState with ChangeNotifier {
  int _selected = 0;
  List _allCategories = [
    'Top Picks',
    'My Skills', 
    'Core',
    'Professional',
    'Social',
    'Other'
  ];
  List _selectableCategories = [
    'Core',
    'Professional',
    'Social',
    'Other'
  ];
  List _rarities = ['Mythic', 'Legendary', 'Rare', 'Uncommon', 'Common'];

  int get selected => _selected;
  List get allCategories => _allCategories;
  List get selectableCategories => _selectableCategories;
  List get rarities => _rarities;

  void setSelected(value) {
    _selected = value;
    notifyListeners();
  }
}
