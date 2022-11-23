class Order {
  String restaurantName = '';
  String riderId = '';
  List<dynamic> menu = [];
  List<dynamic> price = [];
  List<dynamic> count = [];
  String deliveryLocation = '';
  String status = '';
  DateTime orderTime;


  Order({required this.restaurantName, required this.riderId,
    required this.menu, required this.price, required this.count,
    required this.deliveryLocation, required this.status, required this.orderTime});
}