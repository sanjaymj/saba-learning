import 'package:flutter/material.dart';

class UserAuthenticationBloc extends ChangeNotifier {                                      
  String _userName;
  String _password;

  set userName(String userName) {
    notifyListeners();
    this._userName = userName;
  }

  set password(String password) {
    this._password = password;
    notifyListeners();
  }

  get userName {
    return this._userName;
  }

  get password {
    return this._password;
  }
}