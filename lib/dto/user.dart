import 'package:flutter/cupertino.dart';

class UserProvider extends ChangeNotifier{
  String? _nickname;
  String? _email;
  String? _profileImageLink;

  String? get nickname => _nickname;
  String? get email => _email;
  String? get profileImageLink => _profileImageLink;

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
}