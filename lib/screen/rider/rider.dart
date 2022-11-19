import 'package:bobfriend/order_delivery_status.dart';
import 'package:bobfriend/provider/my_delivery.dart';
import 'package:bobfriend/provider/user.dart';
import 'package:bobfriend/screen/rider/rider_order_delivery_status.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'rider_description.dart';
import 'matching.dart';

class RiderScreen extends StatefulWidget {
  const RiderScreen({Key? key}) : super(key: key);

  @override
  State<RiderScreen> createState() => _RiderScreenState();
}

class _RiderScreenState extends State<RiderScreen> {
  late UserProvider userProvider;
  late MyDeliveryProvider myDeliveryProvider;

  @override
  Widget build(BuildContext context) {

    userProvider = Provider.of<UserProvider>(context, listen: true);
    myDeliveryProvider = Provider.of<MyDeliveryProvider>(context, listen: true);

    return userProvider.isRider == null ?
      const CircularProgressIndicator() :
        (userProvider.isRider == false ?
          const RiderDescriptionScreen() :
            (myDeliveryProvider.orderId != '') ?
            //const RiderOrderDeliveryStatusScreen()
            OrderDeliveryStatusScreen(orderId: myDeliveryProvider.orderId)
                : const MatchingScreen());
  }
}
