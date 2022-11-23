import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
class RestaurantModel{
  String? name;
  List<dynamic>? menu;
  List<dynamic>? price;
  DocumentReference? reference;
  RestaurantModel({
    this.name,
    this.menu,
    this.price,
    this.reference,
  });
  RestaurantModel.fromJson(dynamic json, this.reference){
    name = json['name'];
    menu = json['menu'];
    price = json['price'];
  }
  RestaurantModel.fromSnapShot(DocumentSnapshot<Map<String, dynamic>> snapshot)
      : this.fromJson(snapshot.data(), snapshot.reference);
  RestaurantModel.fromQuerySnapshot(
      QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      :this.fromJson(snapshot.data(), snapshot.reference);
  Map<String, dynamic> toJson(){
    final map = <String, dynamic>{};
    map['name']=name;
    map['menu']=menu;
    map['price']=price;

    return map;
  }
  /*
  String? get name => _name;
  List<dynamic> get menu => _menu;
  List<dynamic> get price => _price;
  set name(String? value){
    _name = value;
    notifyListeners();
  }
  set menu(List<dynamic> value){
    _menu = value;
    notifyListeners();
  }
  set price(List<dynamic> value){
    _price = value;
    notifyListeners();
  }*/
}