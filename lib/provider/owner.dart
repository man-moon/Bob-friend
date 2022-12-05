import 'package:bobfriend/Model/product.dart';
import 'package:flutter/material.dart';

class OwnerProvider extends ChangeNotifier {

  String _name = '3대 맛집';
  String _imageLink = '';
  String _address = '경기도 수원시 월드컵로 206';
  String _callNumber = '031-433-9812';
  List<Product> _menu = [
    Product('제육볶음', 7500),
    Product('돼지국밥', 7000),
    Product('등심돈까스', 8000),
    Product('콜라', 1500),
    Product('사이다', 1500),
  ];
  bool _isOpen = true;


  bool get isOpen => _isOpen;

  set isOpen(bool value) {
    _isOpen = value;
    notifyListeners();
  }

  String get name => _name;

  set name(String value) {
    _name = value;
    notifyListeners();
  }

  String get imageLink => _imageLink;

  set imageLink(String value) {
    _imageLink = value;
    notifyListeners();
  }

  String get address => _address;

  set address(String value) {
    _address = value;
    notifyListeners();
  }

  String get callNumber => _callNumber;

  set callNumber(String value) {
    _callNumber = value;
    notifyListeners();
  }

  List<Product> get menu => _menu;

  set menu(List<Product> value) {
    _menu = value;
    notifyListeners();
  }
}