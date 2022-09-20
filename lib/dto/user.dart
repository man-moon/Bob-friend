import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier{
  String? _nickname;
  String? _email;
  String? _profileImageLink;
  String? _univ;

  String? get nickname => _nickname;
  String? get email => _email;
  String? get profileImageLink => _profileImageLink;
  String? get univ => _univ;

  set nickname(String? value) {
    _nickname = value;
    notifyListeners();
  }
  set profileImageLink(String? value) {
    _profileImageLink = value;
    notifyListeners();
  }
  set email(String? value) {
    _email = value;
    notifyListeners();
  }
  set univ(String? value) {
    _univ = value;
    notifyListeners();
  }
}