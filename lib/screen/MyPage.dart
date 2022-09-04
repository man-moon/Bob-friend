import 'package:bobfriend/screen/login_signup.dart';
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
      margin: EdgeInsets.only(bottom: 10),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            const Text(
              '로그아웃',
              //style: TextStyle(color: Palette.textColor1),
            ),
            IconButton(
                onPressed: () {
                  currentUser = null;
                  _authentication.signOut();
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => LoginSignupScreen(),
                  ));
                },
                icon: Icon(
                  Icons.logout_rounded,
                  //color: Palette.textColor1,
                )
            ),
          ]
      ),
    );
  }
}
