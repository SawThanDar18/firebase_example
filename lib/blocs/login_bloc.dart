import 'package:flutter/material.dart';

class LoginBloc extends ChangeNotifier {
  String email = "";
  String password = "";

  void onTapLogin() {}

  void onEmailChanged(String email) {
    this.email = email;
  }

  void onPasswordChanged(String password) {
    this.password = password;
  }
}
