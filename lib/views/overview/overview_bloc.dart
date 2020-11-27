import 'package:flutter/material.dart';

class OverviewBloc extends ChangeNotifier {
  var _filters = [];

  var _values = [];

  get filters {
    return _filters;
  }

  set filters(newFilter) {
    _filters = newFilter;
    notifyListeners();
  }

  get values {
    return _values;
  }

  set values(newValues) {
    _values = newValues;
    notifyListeners();
  }
}
