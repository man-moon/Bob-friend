import 'package:bobfriend/Model/order.dart';
import 'package:bobfriend/order_delivery_status.dart';
import 'package:bobfriend/provider/owner.dart';
import 'package:bobfriend/screen/restaurant/owner_order_status.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OwnerOrderScreen extends StatefulWidget {
  const OwnerOrderScreen({Key? key}) : super(key: key);

  @override
  State<OwnerOrderScreen> createState() => _OwnerOrderScreenState();
}

class _OwnerOrderScreenState extends State<OwnerOrderScreen> {

  late OwnerProvider ownerProvider;

  @override
  Widget build(BuildContext context) {
    final orderRef = FirebaseFirestore.instance.collection('order');
    ownerProvider = Provider.of<OwnerProvider>(context, listen: false);

    return Scaffold(
        appBar: AppBar(
          elevation: 1,
          title: const Text('주문'),
          centerTitle: true,
        ),
        body:
        StreamBuilder(
          stream: orderRef.snapshots(),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if(snapshot.hasData) {
              return snapshot.data.docs.length > 0 ?
              showOrder(snapshot!.data.docs) : notFound();
            }
            return notFound();
          },
        )
    );
  }
  Widget showOrder(final dynamic data) {
    List<Order> orderList = [];

    data.forEach((doc) {
      if(doc['restaurantName'] == ownerProvider.name && doc['status'] != 'complete'){
        Order order = Order(
          restaurantName: doc['restaurantName'],
          chatId: doc.id,
          menu: doc['menu'],
          price: doc['price'],
          count: doc['count'],
          status: doc['status'],
          deliveryLocation: doc['deliveryLocation'],
          orderTime: doc['orderTime'].toDate(),
          riderId: doc['riderId'],
        );
        orderList.add(order);
      }
    });


    return (orderList.isEmpty) ? notFound() : ListView.builder(
        itemCount: orderList.length,
        itemBuilder: (BuildContext context, int index){

          final Order order = orderList[index];
          final String restaurantName = order.restaurantName;
          final String orderTimeBefore = formatTimestamp(order.orderTime);
          final String deliveryLocation = order.deliveryLocation;
          final List<dynamic> menu = order.menu;
          int totalPrice = 0;
          int totalCounts = 0;
          String firstMenuName = '';
          for (int i = order.menu.length - 1; i >= 0; i--) {
            if(order.count[i] > 0) {
              firstMenuName = order.menu[i];
              totalPrice += order.price[i] * order.count[i] as int;
              totalCounts++;
            }
          }

          return Card(
            elevation: 0,
            child: ListTile(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => OwnerOrderStatusScreen(orderId: order.chatId,)));
              },
              title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text.rich(
                        TextSpan(
                            children: <TextSpan>[
                              const TextSpan(text: '메뉴  ', style: TextStyle(color: Colors.grey)),
                              TextSpan(text: totalCounts > 1 ? '$firstMenuName 외 ${totalCounts - 1}개($totalPrice원)' : '$firstMenuName($totalPrice원)', style: const TextStyle(color: Colors.black),),
                            ]
                        )
                    ),
                    Text(orderTimeBefore, style: const TextStyle(color: Colors.grey),),
                  ]),
              subtitle: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Text('배달지  ', style: TextStyle(color: Colors.grey),),
                  Text(deliveryLocation, style: const TextStyle(color: Colors.black),)
                ],
              ),


            ),
          );
        }
    );
  }

}

Widget notFound() {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        Icon(Icons.search_off, size: 80, color: Colors.grey,),
        Text('아직 주문 요청이 없어요\n', style: TextStyle(fontSize: 20),),
        Text('주문이 들어오면 바로 알려드릴게요!', style: TextStyle(fontSize: 20),)
      ],
    ),
  );
}

String formatTimestamp(DateTime timestamp) {
  DateTime now = DateTime.now();
  Duration diff = now.difference(timestamp);
  String stdDate = "";
  if (diff.inSeconds < 60) {
    stdDate = "${diff.inSeconds}초 전";
  } else if (diff.inSeconds > 60 && diff.inHours < 1) {
    stdDate = "${(diff.inSeconds / 60).floor()}분 전";
  } else if (diff.inHours < 24) {
    stdDate = "${diff.inHours}시간 전";
  } else if (diff.inDays < 30) {
    stdDate = "${diff.inDays}일 전";
  } else if (diff.inDays < 365) {
    stdDate = "${diff.inDays / 30}달 전";
  } else {
    stdDate = "${diff.inDays / 365}년 전";
  }
  return stdDate;
}
