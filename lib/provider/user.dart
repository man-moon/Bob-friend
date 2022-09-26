import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier{
  String? _nickname;
  String? _email;
  String? _profileImageLink;
  String? _univ;
  List<dynamic> _friends = [];
  double? _temperature;

  String? get nickname => _nickname;
  String? get email => _email;
  String? get profileImageLink => _profileImageLink;
  String? get univ => _univ;
  List<dynamic> get friends => _friends;
  double? get temperature => _temperature;

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
  void addFriends(dynamic value) {
    friends.add(value);
    notifyListeners();
  }
  set friends(List<dynamic> value) {
    _friends = value;
    notifyListeners();
  }
  set temperature(double? value) {
    _temperature = value;
    notifyListeners();
  }

  void clear() {
    _nickname = null;
    _email = null;
    _profileImageLink = null;
    _univ = null;
    _friends = [];
    _temperature = null;
    debugPrint('User info Cleared!');
  }
}