import 'package:cloud_firestore/cloud_firestore.dart';

import '../Model/restaurant.dart';

class RestaurantFireService {
  List<RestaurantModel> list = [];

  Future<List<RestaurantModel>> getDocs() async {
    QuerySnapshot querySnapshot =
    await FirebaseFirestore.instance.collection('restaurant').get();
    for (int i = 0; i < querySnapshot.docs.length; i++) {
      var Middle_datainfo = querySnapshot.docs[i].data() as Map<String, dynamic>;
      String name = '';
      List<dynamic> menu = [];
      List<dynamic> price = [];
      name = Middle_datainfo['name'];
      menu.addAll(List.from(Middle_datainfo['menu']));
      price.addAll(List.from(Middle_datainfo['price']));
      RestaurantModel r = RestaurantModel(name: name, menu: menu, price: price);
      list.add(r);
    }
    return list;
  }
}