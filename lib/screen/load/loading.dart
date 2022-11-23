import 'package:bobfriend/provider/my_delivery.dart';
import 'package:bobfriend/screen/home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider/user.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({Key? key}) : super(key: key);

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  late UserProvider userProvider;
  late MyDeliveryProvider myDeliveryProvider;

  void initUserInfo(final dynamic userInfo) async {
    userProvider.nickname = userInfo.data()!['nickname'];
    userProvider.email = userInfo.data()!['email'];
    userProvider.profileImageLink = userInfo.data()!['profile_image'];
    userProvider.univ = userInfo.data()!['univ'];
    userProvider.temperature = userInfo.data()!['temperature'];
    userProvider.friends = userInfo.data()!['friends'];
    userProvider.isRider = userInfo.data()!['isRider'];
    userProvider.isDelivering = userInfo.data()!['isDelivering'];
  }
  void initMyDeliveryInfo(final dynamic myDeliveryInfo) {
    myDeliveryProvider.count = myDeliveryInfo.data()!['count'];
    myDeliveryProvider.price = myDeliveryInfo.data()!['price'];
    myDeliveryProvider.menu = myDeliveryInfo.data()!['menu'];
    myDeliveryProvider.restaurantName = myDeliveryInfo.data()!['restaurantName'];
    myDeliveryProvider.orderTime = myDeliveryInfo.data()!['orderTime'].toDate();
    myDeliveryProvider.deliveryLocation = myDeliveryInfo.data()!['deliveryLocation'];
    myDeliveryProvider.status = myDeliveryInfo.data()!['status'];
    myDeliveryProvider.riderId = myDeliveryInfo.data()!['riderId'];
    myDeliveryProvider.orderId = myDeliveryInfo.data()!['orderId'];
  }
  @override
  Widget build(BuildContext context) {
    userProvider = Provider.of<UserProvider>(context, listen: false);
    myDeliveryProvider = Provider.of<MyDeliveryProvider>(context, listen: false);

    if(mounted){
      FirebaseFirestore.instance.collection('user').
      doc(FirebaseAuth.instance.currentUser!.uid).get().then(
              (value) => initUserInfo(value)).then(
              (value) => FirebaseFirestore.instance.collection('user')
                  .doc(FirebaseAuth.instance.currentUser!.uid)
                  .collection('myDelivery').doc('myDelivery').get().then(
                  (value) => initMyDeliveryInfo(value))
                  .then((value) {Navigator.pushAndRemoveUntil(context,
                  MaterialPageRoute(builder: (BuildContext context) =>
                  const HomeScreen()), (route) => false
              );})

      );
    }

    return Image.asset(
      'image/load.gif',
    );
  }
}


