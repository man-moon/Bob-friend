class Delivery {
  String restaurantName = '';
  List<dynamic> menu = [];
  List<dynamic> price = [];
  List<dynamic> count = [];
  bool isMatched = false;
  String deliveryLocation = '';
  DateTime orderTime;


  Delivery({required this.restaurantName, required this.menu, required this.price, required this.count,
      required this.isMatched, required this.deliveryLocation, required this.orderTime});
}