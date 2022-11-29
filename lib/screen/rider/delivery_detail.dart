import 'package:bobfriend/config/msg_config.dart';
import 'package:bobfriend/provider/my_delivery.dart';
import 'package:bobfriend/provider/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../Model/delivery.dart';

///배달 세부정보 화면
///배달 장소 -> 나중에 지도까지 제공
///가장 하단에 주문 수락 Extended Floating Action Button
class DeliveryDetailScreen extends StatelessWidget {
  const DeliveryDetailScreen({Key? key, required this.delivery}) : super(key: key);

  final Delivery delivery;


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        centerTitle: true,
        title: const Text('주문 세부정보'),
      ),
      body: ListView(
        children: [
          buildRestaurantInfo(context, delivery),
          buildCatalog(context, delivery),
          buildDeliveryLocation(delivery.deliveryLocation),
        ],
      ),
      floatingActionButton: buildFloatingActionButton(context, delivery.chatId, delivery),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

///가게 정보, 주문 시간,
Widget buildRestaurantInfo(BuildContext context, Delivery delivery) {
  final restaurantName = delivery.restaurantName;
  final orderTime = dateParser(delivery.orderTime);


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


///전체 주문 목록
Widget buildCatalog(BuildContext context, Delivery delivery) {
  List<String> menu = [];
  List<int> count = [];
  List<int> price = [];
  num totalPrice = 0;

  for(int i = 0 ; i < delivery.count.length; i++) {
    int cnt = delivery.count[i];
    if(cnt != 0) {
      menu.add(delivery.menu[i]);
      count.add(delivery.count[i]);
      price.add(delivery.price[i]);

      if(delivery.price[i] != null && delivery.count[i] != null) {
        totalPrice += (delivery.price[i] * delivery.count[i]);
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


///배달 주소
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
          )
        ],
      ),
    ),
  );

}


///Floating Action Button
Widget buildFloatingActionButton(BuildContext context, String docId, Delivery delivery) {
  return Container(
    decoration: const BoxDecoration(
      shape: BoxShape.rectangle,
    ),
    width: MediaQuery.of(context).size.width * 0.9,
    child: FloatingActionButton.extended(
      backgroundColor: Colors.greenAccent,
      onPressed: () {
        Timestamp t = Timestamp.now();

        debugPrint('detail screen1');


        updateDeliveryList(context, docId)
            .then((_) => updateMyDelivery(context, delivery, t))
            .then((_) => createOrder(context, delivery, docId))
            .then((_) => updateMyDeliveryProvider(context, delivery, t))
            .then((_) => Navigator.of(context).pop());

        debugPrint('detail screen2');


        showTopSnackBar(
          context,
          const CustomSnackBar.success(message: '배달을 수락했어요'),
          animationDuration: const Duration(milliseconds: 1200),
          displayDuration: const Duration(milliseconds: 300),
          reverseAnimationDuration: const Duration(milliseconds: 800),
        );
      },
      icon: const Icon(Icons.check, color: Colors.white,),
      isExtended: true,
      elevation: 30,
      label: const Text('배달을 수락할게요', style: TextStyle(fontSize: 18),),
    ),
  );
}

Future<void> createOrder(BuildContext context, Delivery delivery, String docId) async {

  await FirebaseFirestore.instance.collection('order').doc(docId).set({
    'restaurantName': delivery.restaurantName,  //추후 가게 uid(==가게 사장님 uid)로 변경 예정
    'riderId': FirebaseAuth.instance.currentUser!.uid,
    'menu': delivery.menu,
    'price': delivery.price,
    'count': delivery.count,
    'deliveryLocation': delivery.deliveryLocation,
    'status': 'waiting',
    'orderTime': Timestamp.now(),
  });
  debugPrint('Created:: $docId');

  await FirebaseFirestore.instance.collection('chats').doc(docId).collection('chat').doc('order').set({
    'action': MessageAction.viewOrder.toString(),
    'meetingPlace': '',
    'nickname': '밥친구',
    'restaurant': '',
    'text': '주문이 접수되었습니다.\n조금만 기다려주세요!',
    'time': Timestamp.now(),
    'type': MessageType.action.toString(),
    'userId': 'admin',
  });

}

void updateMyDeliveryProvider(BuildContext context, Delivery delivery, Timestamp t) {
  MyDeliveryProvider myDeliveryProvider = Provider.of<MyDeliveryProvider>(context, listen: false);
  UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);
  userProvider.isDelivering = true;

  myDeliveryProvider.riderId = FirebaseAuth.instance.currentUser!.uid;
  myDeliveryProvider.restaurantName = delivery.restaurantName;
  myDeliveryProvider.status = 'waiting';
  myDeliveryProvider.deliveryLocation = delivery.deliveryLocation;
  myDeliveryProvider.menu = delivery.menu;
  myDeliveryProvider.price = delivery.price;
  myDeliveryProvider.count = delivery.count;
  myDeliveryProvider.orderTime = t.toDate();
  myDeliveryProvider.orderId = delivery.chatId;
}

Future<void> updateMyDelivery(BuildContext context, Delivery delivery, Timestamp t) async {

  final userRef = FirebaseFirestore.instance.collection('user').doc(FirebaseAuth.instance.currentUser!.uid);
  final myDeliveryRef = userRef.collection('myDelivery').doc('myDelivery');

  await userRef.update({'isDelivering': true});

  await myDeliveryRef.set({
    'riderId': FirebaseAuth.instance.currentUser!.uid,
    'restaurantName': delivery.restaurantName,
    'status': 'waiting',
    'deliveryLocation': delivery.deliveryLocation,
    'menu': delivery.menu,
    'price': delivery.price,
    'count': delivery.count,
    'orderTime': t,
    'orderId': delivery.chatId,
  });
}

Future<void> updateDeliveryList(BuildContext context, String docId) async {
  final deliveryRef = FirebaseFirestore.instance.collection('delivery').doc(docId);
  try{
    await deliveryRef.update({'isMatched': true});
  } catch(e) {
    showTopSnackBar(
      context,
      const CustomSnackBar.error(message: '이미 수락된 호출입니다.\n다른 배달을 해주세요!'),
      animationDuration: const Duration(milliseconds: 1200),
      displayDuration: const Duration(milliseconds: 0),
      reverseAnimationDuration: const Duration(milliseconds: 800),
    );
  }
}

Widget buildOrderList(String menu, int price, int count) {
  return Column(
    children: [
      Row(
        children: [
          Text('$menu($price원)   ', style: const TextStyle(fontSize: 17, color: Colors.black),),
          Text('$count개', style: const TextStyle(fontSize: 15, color: Colors.grey),)
        ],
      ),
      const SizedBox(height: 10,),
      Row(
        children: [
          Text('${price*count}원', style: const TextStyle(fontSize: 15, color: Colors.grey),)
        ],
      ),
      const SizedBox(height: 20,)
    ],
  );
}

String dateParser(DateTime dateTime) {
  String parsedDate = '';

  parsedDate = '${dateTime.year}년 ${dateTime.month}월 ${dateTime.day}일 ${dateTime.hour}시 ${dateTime.minute}분';


  return parsedDate;
}