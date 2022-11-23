import 'package:bobfriend/Model/order.dart';
import 'package:bobfriend/screen/rider/delivery_detail.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class OrderDeliveryStatusScreen extends StatefulWidget {
  const OrderDeliveryStatusScreen({Key? key, required this.orderId}) : super(key: key);
  final String orderId;

  @override
  State<OrderDeliveryStatusScreen> createState() => _OrderDeliveryStatusScreenState();
}

class _OrderDeliveryStatusScreenState extends State<OrderDeliveryStatusScreen> {

  String statusFAB = 'waiting';

  @override
  Widget build(BuildContext context) {
    final orderRef = FirebaseFirestore.instance.collection('order').doc(widget.orderId);

    return Scaffold(
      appBar: AppBar(
        title: const Text('주문/배달 상세정보', style: TextStyle(color: Colors.black),),
        centerTitle: true,
      ),
      body: StreamBuilder(
        stream: orderRef.snapshots(),
        builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if(snapshot.connectionState == ConnectionState.active){
            Order order = Order(
              restaurantName: snapshot.data!.get('restaurantName'),
              riderId: snapshot.data!.get('riderId'),
              menu: snapshot.data!.get('menu'),
              price: snapshot.data!.get('price'),
              count: snapshot.data!.get('count'),
              deliveryLocation: snapshot.data!.get('deliveryLocation'),
              status: snapshot.data!.get('status'),
              orderTime: snapshot.data!.get('orderTime').toDate(),
            );
            return ListView(
              children: [
                buildRestaurantInfo(context, order!),
                buildProgressStatusBar(context, order!),
                buildCatalog(context, order!),
                buildDeliveryLocation(order!.deliveryLocation),
              ],
            );
          }
          else{
            return const CircularProgressIndicator(color: Colors.grey,);
          }
        },
      ),
      floatingActionButton: buildFloatingActionButton(context, statusFAB),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,

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
                const Text('가게에서 주문을 확인 중이에요'),
              if(status == 'cooking')
                const Text('가게에서 주문을 확인했어요'),
              if(status == 'pickup')
                const Text('조리가 완료되었어요. 픽업대기 중이에요.'),
              if(status == 'deliveryStart')
                const Text('라이더에게 전달을 완료했어요. 곧 도착합니다!'),
              if(status == 'deliveryArrival')
                const Text('배달이 도착했어요! 픽업을 위해 나와주세요'),
              if(status == 'deliveryComplete')
                const Text('배달이 완료되었어요.'),
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

Widget buildDeliveryLocation(String? deliveryLocation) {
  return Card(

    margin: const EdgeInsets.only(top: 15, left: 5, right: 5),
    elevation: 0,
    child: Container(
      padding: const EdgeInsets.all(13),
      child: Column(
        children: [
          Row(
            children: const [
              Text('배달 주소', style: TextStyle(fontSize: 20, color: Colors.grey),),
            ],
          ),
          const SizedBox(height: 20, ),
          Row(
            children: [
              Text(deliveryLocation!, style: const TextStyle(fontSize: 17, color: Colors.black),),
            ],
          ),
          const SizedBox(height: 80,),
        ],
      ),
    ),
  );

}

Widget buildFloatingActionButton(BuildContext context, String statusFAB) {
  return Container(
    decoration: const BoxDecoration(
      shape: BoxShape.rectangle,
    ),
    width: MediaQuery.of(context).size.width * 0.9,
    child: FloatingActionButton.extended(
      backgroundColor: buildFABColor(statusFAB),

      onPressed: () {
      },
      isExtended: true,
      elevation: 5,
      label: buildFABText(statusFAB),
    ),
  );
}

Widget buildFABText(String statusFAB) {
  if(statusFAB == 'waiting' || statusFAB == 'checked' || statusFAB == 'pickup') {
    return const Text('배달이 시작되면 활성화돼요', style: TextStyle(fontSize: 18),);
  }
  if(statusFAB == 'deliveryStart') {
    return const Text('배달 도착 알림을 보낼게요', style: TextStyle(fontSize: 18),);
  }
  if(statusFAB == 'deliveryArrival') {
    return const Text('배달을 완료했어요', style: TextStyle(fontSize: 18),);
  }
  return const Text('완료된 배달입니다');
}

ColorSwatch<int> buildFABColor(String statusFAB) {
  if(statusFAB == 'waiting' || statusFAB == 'checked' || statusFAB == 'pickup') {
    return Colors.grey;
  }

  return Colors.greenAccent;
}