import 'package:flutter/material.dart';

class MyCatalogProvider extends ChangeNotifier {
  //menu, price, count를 각각의 list로 관리해서 index별로 뽑아오기 쉽도록.
  var _menu = <String?>[];
  var _price = <int>[];
  var _count = <int>[];
  var _totalPrice = 0;

  List<String?> get menu => _menu;
  List<int> get price => _price;
  List<int> get count => _count;
  get totalPrice => _totalPrice;

  void addTotalPrice(int price) {
    _totalPrice += price;
    notifyListeners();
  }

  void subTotalPrice(int price) {
    _totalPrice -= price;
    notifyListeners();
  }

  void addMenu(String? menuName) {
    _menu.add(menuName);
  }

  void setPrice(int price) {
    _price.add(price);
  }

  void setCount() {
    _count.add(0);
  }


  void addCount(int idx) {
    _count[idx]++;
    notifyListeners();
  }

  void subtractCount(int idx) {
    _count[idx]--;
    notifyListeners();
  }

  void softReset() {
    _count = [];
    _price = [];
    _menu = [];
    _totalPrice = 0;

    notifyListeners();
  }

  void hardReset() {
    _menu = [];
    _price = [];
    _count = [];
    _totalPrice = 0;

    notifyListeners();
  }
}