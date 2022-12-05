import 'package:bobfriend/Model/delivery.dart';
import 'package:bobfriend/screen/rider/delivery_detail.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MatchingScreen extends StatefulWidget {
  const MatchingScreen({Key? key}) : super(key: key);

  @override
  State<MatchingScreen> createState() => _MatchingScreenState();
}

class _MatchingScreenState extends State<MatchingScreen> {

  @override
  Widget build(BuildContext context) {
    final deliveryRef = FirebaseFirestore.instance.collection('delivery');

    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        title: const Text('배달'),
        centerTitle: true,
      ),
      body:
        StreamBuilder(
          stream: deliveryRef.snapshots(),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if(snapshot.hasData){
              return snapshot.data.docs.length > 0 ?
              showDelivery(snapshot!.data.docs) : notFound();
            }
            else{
              return notFound();
            }
          },
        )
    );
  }
}

Widget showDelivery(final dynamic data) {
  List<Delivery> deliveryList = [];

  data.forEach((doc) {
    if(doc['isMatched'] == false){
      debugPrint(doc.id);
      Delivery delivery = Delivery(
        restaurantName: doc['name'],
        chatId: doc.id,
        menu: doc['menu'],
        price: doc['price'],
        count: doc['count'],
        isMatched: false,
        deliveryLocation: doc['deliveryLocation'],
        orderTime: doc['orderTime'].toDate(),
      );
      deliveryList.add(delivery);
    }
  });

  return (deliveryList.isEmpty) ? notFound() : ListView.builder(
    itemCount: deliveryList.length,
    cacheExtent: 10,
    itemBuilder: (BuildContext context, int index){

      final Delivery delivery = deliveryList[index];
      final String restaurantName = delivery.restaurantName;
      final String orderTimeBefore = formatTimestamp(delivery.orderTime);
      final String deliveryLocation = delivery.deliveryLocation;

      return Card(
        elevation: 0,
        child: ListTile(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => DeliveryDetailScreen(delivery: delivery)));
          },
          title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text.rich(
                  TextSpan(
                    children: <TextSpan>[
                      const TextSpan(text: '픽업가게  ', style: TextStyle(color: Colors.grey)),
                      TextSpan(text: restaurantName, style: const TextStyle(color: Colors.black),),
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
Widget notFound() {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        Icon(Icons.search_off, size: 80, color: Colors.grey,),
        Text('아직 배달 요청이 없어요', style: TextStyle(fontSize: 20),),
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
