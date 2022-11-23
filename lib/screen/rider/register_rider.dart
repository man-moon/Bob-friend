import 'package:bobfriend/screen/rider/matching.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider/user.dart';

class RegisterRiderScreen extends StatefulWidget {
  const RegisterRiderScreen({Key? key}) : super(key: key);

  @override
  State<RegisterRiderScreen> createState() => _RegisterRiderScreenState();
}

class _RegisterRiderScreenState extends State<RegisterRiderScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text('배달원 등록'),
        centerTitle: true,
      ),
      body: const Center(child: Text('추후 이용약관이 들어올 페이지'),),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Container(
        decoration: const BoxDecoration(
          shape: BoxShape.rectangle,
        ),
        width: MediaQuery.of(context).size.width * 0.9,
        child: FloatingActionButton.extended(
          backgroundColor: Colors.greenAccent,
          onPressed: () {
            UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);
            
            FirebaseFirestore.instance
                .collection('user')
                .doc(FirebaseAuth.instance.currentUser!.uid)
                .update({'isRider': true})
                .then((value) =>
                    userProvider.isRider = true).then((value) => Navigator.of(context).pop());

          },
          icon: const Icon(
            Icons.delivery_dining,
            color: Colors.white,
          ),
          isExtended: true,
          elevation: 30,
          label: const Text(
            '배달원 등록하기',
            style: TextStyle(fontSize: 17),
          ),
        ),
      ),
    );
  }
}
