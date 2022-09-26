import 'package:bobfriend/my_app.dart';
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

  void initUserInfo(final dynamic userInfo) async {
    userProvider.nickname = userInfo.data()!['nickname'];
    userProvider.email = userInfo.data()!['email'];
    userProvider.profileImageLink = userInfo.data()!['profile_image'];
    userProvider.univ = userInfo.data()!['univ'];
    userProvider.temperature = userInfo.data()!['temperature'];
    userProvider.friends = userInfo.data()!['friends'];

    debugPrint('==========init test==========');
    debugPrint('nickname: ${userProvider.nickname}');
    debugPrint('email: ${userProvider.email}');
    debugPrint('univ: ${userProvider.univ}');
    debugPrint('temperature: ${userProvider.temperature}');
    debugPrint('profileUrl: ${userProvider.profileImageLink}');
    debugPrint('==========finish test==========');

  }
  @override
  Widget build(BuildContext context) {
    userProvider = Provider.of<UserProvider>(context, listen: false);
    if(mounted){
      FirebaseFirestore.instance.collection('user').
      doc(FirebaseAuth.instance.currentUser!.uid).get().then(
              (value) => initUserInfo(value)).then(
              (value) =>
              Navigator.pushAndRemoveUntil(context,
                  MaterialPageRoute(builder: (BuildContext context) =>
                  const HomeScreen()), (route) => false
              )
      );
    }

    return Image.asset(
      'image/load.gif',
    );
  }
}
