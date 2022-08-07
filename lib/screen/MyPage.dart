import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MyPageScreen extends StatefulWidget {
  const MyPageScreen({Key? key}) : super(key: key);

  @override
  State<MyPageScreen> createState() => _MyPageScreenState();
}

class _MyPageScreenState extends State<MyPageScreen> {
  final _authentication = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: IconButton(
          onPressed: (){
            _authentication.signOut();
            //Navigator.pop(context);
          },
          icon: Icon(
            Icons.exit_to_app_rounded,
            color: Colors.black26,
          )
      ),
    );
  }
}
