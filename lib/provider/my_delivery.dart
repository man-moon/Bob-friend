import 'package:flutter/material.dart';

class MyDeliveryProvider extends ChangeNotifier {
  String _orderId = '';
  String? _restaurantName;
  String? _riderId;
  String? _status;
  String? _deliveryLocation;
  List<dynamic> _menu = [];
  List<dynamic> _price = [];
  List<dynamic> _count = [];
  DateTime? _orderTime;

  void clearAll() {
    _orderId = '';
    _restaurantName = null;
    _riderId = null;
    _status = null;
    _deliveryLocation = null;
    _menu = [];
    _price = [];
    _count = [];
    _orderTime = null;
    notifyListeners();
  }

  String get orderId => _orderId;

  set orderId(String value) {
    _orderId = value;
    notifyListeners();
  }

  String? get restaurantName => _restaurantName;

  set restaurantName(String? value) {
    _restaurantName = value;
    notifyListeners();
  }

  String? get riderId => _riderId;

  set riderId(String? value) {
    _riderId = value;
    notifyListeners();
  }

  String? get status => _status;

  set status(String? value) {
    _status = value;
    notifyListeners();
  }

  String? get deliveryLocation => _deliveryLocation;

  set deliveryLocation(String? value) {
    _deliveryLocation = value;
    notifyListeners();
  }

  DateTime? get orderTime => _orderTime;

  set orderTime(DateTime? value) {
    _orderTime = value;
    notifyListeners();
  }

  List<dynamic> get count => _count;

  set count(List<dynamic> value) {
    _count = value;
    notifyListeners();
  }

  List<dynamic> get price => _price;

  set price(List<dynamic> value) {
    _price = value;
    notifyListeners();
  }

  List<dynamic> get menu => _menu;

  set menu(List<dynamic> value) {
    _menu = value;
    notifyListeners();
  }
}