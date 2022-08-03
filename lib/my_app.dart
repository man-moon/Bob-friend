import 'package:bobfriend/screen/chat.dart';
import 'package:bobfriend/screen/home.dart';
import 'package:bobfriend/screen/login_signup.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //로그인 되어 있지 않다면 초기 로그인/회원가입 화면 보여줌
    //로그인 되어 있다면 바로 홈스크린으로
    bool session = false;

    if (session) {
      return HomeScreen();
    } else return MaterialApp(
        title: 'BobFriend',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSwatch().copyWith(
            brightness: Brightness.dark,
            primary: Colors.black26,
            secondary: Colors.black12,
          ),
          fontFamily: 'BM',
        ),
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot){
            if(snapshot.hasData){
              return ChatScreen();
            }
            return LoginSignUpScreen();
          },
        ),
      );
  }
}
