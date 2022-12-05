import 'package:bobfriend/Model/product.dart';
import 'package:flutter/material.dart';

class OwnerProvider extends ChangeNotifier {

  String _name = '3대맛집';
  String _imageLink = '';
  String _address = '경기도 수원시 월드컵로 206';
  String _callNumber = '031-433-9812';
  List<Product> _menu = [
    Product(name: '제육볶음', price: 7500, isAvailable: true),
    Product(name: '돼지국밥', price: 7000, isAvailable: true),
    Product(name: '등심돈까스', price: 8000, isAvailable: true),
    Product(name: '콜라', price: 1500, isAvailable: true),
    Product(name: '사이다', price: 1500, isAvailable: true),
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