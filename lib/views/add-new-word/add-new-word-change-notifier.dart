import 'package:flutter/material.dart';

class AddNewWordChangeNotifier extends ChangeNotifier {
  var _filters = [];

  bool _isAddNewCategory;

  bool _isAutomaticTranslation = true;

  String _newCategory;

  get filters {
    return _filters;
  }

  set filters(newFilter) {
    _filters = newFilter;
    notifyListeners();
  }

  get newCategory {
    return _newCategory;
  }

  set newCategory(item) {
    _newCategory = item;
    notifyListeners();
  }

  get isAddNewCategory {
    if (_isAddNewCategory == null) {
      return false;
    }
    return _isAddNewCategory;
  }

  set isAddNewCategory(newValues) {
    _isAddNewCategory = newValues;
    notifyListeners();
  }

  get isAutomaticTranslation {
    if (_isAutomaticTranslation == null) {
      return false;
    }
    return _isAutomaticTranslation;
  }

  set isAutomaticTranslation(val) {
    _isAutomaticTranslation = val;
    notifyListeners();
  }
}
