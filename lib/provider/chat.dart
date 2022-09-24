import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatProvider extends ChangeNotifier{
  String? _docId;
  Timestamp? _date;
  late List<dynamic> _foodType;
  String? _gender;
  int? _maxPersonnel;
  int? _nowPersonnel;
  String? _owner;
  String? _roomName;
  String? _univ;
  late List<dynamic> _users;

  String? get docId => _docId;
  Timestamp? get date => _date;
  List<dynamic> get foodType => _foodType;
  String? get gender => _gender;
  int? get maxPersonnel => _maxPersonnel;
  int? get nowPersonnel => _nowPersonnel;
  String? get owner => _owner;
  String? get roomName => _roomName;
  String? get univ => _univ;
  List<dynamic> get users => _users;

  set docId(String? value) {
    _docId = value;
    notifyListeners();
  }
  set date(Timestamp? value) {
    _date = value;
    notifyListeners();
  }
  set foodType(List<dynamic> value) {
    _foodType = value;
    notifyListeners();
  }
  set gender(String? value) {
    _gender = value;
    notifyListeners();
  }
  set maxPersonnel(int? value) {
    _maxPersonnel = value;
    notifyListeners();
  }
  set nowPersonnel(int? value) {
    _nowPersonnel = value;
    notifyListeners();
  }
  set owner(String? value) {
    _owner = value;
    notifyListeners();
  }
  set roomName(String? value) {
    _roomName = value;
    notifyListeners();
  }
  set univ(String? value) {
    _univ = value;
    notifyListeners();
  }
  set users(List<dynamic> value) {
    _users = value;
    notifyListeners();
  }
}