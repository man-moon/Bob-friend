import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatProvider extends ChangeNotifier{
  String? _docId;
  Timestamp? _date;
  late List<String?> _foodType;
  String? _gender;
  int? _maxPersonnel;
  int? _nowPersonnel;
  String? _owner;
  String? _roomName;
  String? _univ;
  late List<String?> _users;

  String? get docId => _docId;

  set docId(String? value) {
    _docId = value;
    notifyListeners();
  }

  Timestamp? get date => _date;

  set date(Timestamp? value) {
    _date = value;
    notifyListeners();
  }

  List<String?> get foodType => _foodType;

  set foodType(List<String?> value) {
    _foodType = value;
    notifyListeners();
  }

  String? get gender => _gender;

  set gender(String? value) {
    _gender = value;
    notifyListeners();
  }

  int? get maxPersonnel => _maxPersonnel;

  set maxPersonnel(int? value) {
    _maxPersonnel = value;
    notifyListeners();
  }

  int? get nowPersonnel => _nowPersonnel;

  set nowPersonnel(int? value) {
    _nowPersonnel = value;
    notifyListeners();
  }

  String? get owner => _owner;

  set owner(String? value) {
    _owner = value;
    notifyListeners();
  }

  String? get roomName => _roomName;

  set roomName(String? value) {
    _roomName = value;
    notifyListeners();
  }

  String? get univ => _univ;

  set univ(String? value) {
    _univ = value;
    notifyListeners();
  }

  List<String?> get users => _users;

  set users(List<String?> value) {
    _users = value;
    notifyListeners();
  }
}