import 'package:bobfriend/Model/order.dart';
import 'package:bobfriend/provider/my_delivery.dart';
import 'package:bobfriend/screen/rider/delivery_detail.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';

class RiderOrderDeliveryStatusScreen extends StatefulWidget {
  const RiderOrderDeliveryStatusScreen({Key? key}) : super(key: key);

  @override
  State<RiderOrderDeliveryStatusScreen> createState() => _RiderOrderDeliveryStatusScreenState();
}

class _RiderOrderDeliveryStatusScreenState extends State<RiderOrderDeliveryStatusScreen> {

  late MyDeliveryProvider myDeliveryProvider;
  Order? order;

  @override
  Widget build(BuildContext context) {

    myDeliveryProvider = Provider.of<MyDeliveryProvider>(context, listen: false);
    order = Order(
      restaurantName: myDeliveryProvider.restaurantName.toString(),
      riderId: myDeliveryProvider.riderId.toString(),
      chatId: myDeliveryProvider.orderId,
      menu: myDeliveryProvider.menu,
      price: myDeliveryProvider.price,
      count: myDeliveryProvider.count,
      deliveryLocation: myDeliveryProvider.deliveryLocation.toString(),
      status: myDeliveryProvider.status.toString(),
      orderTime: myDeliveryProvider.orderTime as DateTime,
    );

    if(mounted) {
      setState(() {
      order = order;
      });
    }

    return Scaffold(
        appBar: AppBar(
          title: const Text('주문/배달 상세정보', style: TextStyle(color: Colors.black),),
          centerTitle: true,
        ),
        body: (order == null) ? const Center(child: CircularProgressIndicator(color: Colors.grey,),) : ListView(
          children: [
            buildRestaurantInfo(context, order!),
            buildProgressStatusBar(context, order!),
            buildCatalog(context, order!),
            buildDeliveryLocation(order!.deliveryLocation),
          ],
        )

    );
  }
}


Widget buildProgressStatusBar(BuildContext context, Order order) {
  String status = order.status;

  return Card(
    margin: const EdgeInsets.only(top: 15, left: 5, right: 5),
    elevation: 0,
    child: Container(
      padding: const EdgeInsets.all(13),
      child: Column(
          children: [
            Row(children: const [
              Text('주문 상태', style: TextStyle(color: Colors.grey, fontSize: 20))
            ]),
            const SizedBox(height: 20,),
            Padding(
              padding: const EdgeInsets.only(top: 0),
              child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                LinearPercentIndicator(
                  width: MediaQuery.of(context).size.width * 0.9,
                  lineHeight: 15.0,
                  percent: calculatePercent(order.status),
                  backgroundColor: Colors.grey[340],
                  progressColor: Colors.greenAccent,
                  animation: true,
                  animationDuration: 1000,
                  barRadius: const Radius.circular(5),
                ),
              ]),
            ),
            const SizedBox(height: 15,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if(status == 'waiting')
                  const Text('가게에서 주문을 확인 중이에요')
              ],
            ),
            const SizedBox(height: 5,),
          ]),
    ),
  );
}

double calculatePercent(String status) {
  if(status == 'waiting') return 0.2;
  if(status == 'cooking') return 0.4;
  if(status == 'deliveryStart') return 0.6;
  if(status == 'deliveryArrival') return 0.8;
  if(status == 'deliveryCompletion') return 1;
  return 1;
}

Widget buildRestaurantInfo(BuildContext context, Order order) {
  final restaurantName = order.restaurantName;
  final orderTime = dateParser(order.orderTime);

  return Card(

    margin: const EdgeInsets.only(top: 15, left: 5, right: 5),
    elevation: 0,
    child: Container(
      padding: const EdgeInsets.all(13),
      child: Column(
        children: [
          Row(
              children: [
                Text.rich(
                    TextSpan(
                        children: <TextSpan>[
                          const TextSpan(text: '픽업가게  ', style: TextStyle(color: Colors.grey, fontSize: 20)),
                          TextSpan(text: restaurantName, style: const TextStyle(color: Colors.black, fontSize: 20),),
                        ]
                    )
                ),
              ]
          ),
          const SizedBox(height: 20,),
          Row(
            children: [
              Text.rich(
                  TextSpan(
                      children: <TextSpan>[
                        const TextSpan(text: '주문일시  ', style: TextStyle(color: Colors.grey, fontSize: 15)),
                        TextSpan(text: orderTime, style: const TextStyle(color: Colors.black, fontSize: 15),),
                      ]
                  )
              )

            ],)
        ],
      ),
    ),
  );
}

Widget buildCatalog(BuildContext context, Order order) {
  List<String> menu = [];
  List<int> count = [];
  List<int> price = [];
  num totalPrice = 0;

  for(int i = 0 ; i < order.count.length; i++) {
    int cnt = order.count[i];
    if(cnt != 0) {
      menu.add(order.menu[i]);
      count.add(order.count[i]);
      price.add(order.price[i]);

      if(order.price[i] != null && order.count[i] != null) {
        totalPrice += (order.price[i] * order.count[i]);
      }

    }
  }

  return Card(
    margin: const EdgeInsets.only(top: 15, left: 5, right: 5),
    elevation: 0,
    child: Container(
      padding: const EdgeInsets.all(13),
      child: Column(
        children: [
          Row(
              children: const [
                Text('주문 내역', style: TextStyle(color: Colors.grey, fontSize: 20))
              ]
          ),
          const SizedBox(height: 20,),
          for(int i = 0; i < menu.length; i++)
            buildOrderList(menu[i], price[i], count[i]),

          const Divider(),
          const SizedBox(height: 15,),
          Row(
            children: [
              Text.rich(
                  TextSpan(
                      children: <TextSpan>[
                        const TextSpan(text: '합계  ', style: TextStyle(color: Colors.grey, fontSize: 17)),
                        TextSpan(text: '$totalPrice원', style: const TextStyle(color: Colors.black, fontSize: 17),),
                      ]
                  )
              )
            ],
          ),
        ],
      ),
    ),
  );
}
