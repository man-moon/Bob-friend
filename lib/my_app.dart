import 'package:bobfriend/screen/chat.dart';
import 'package:bobfriend/screen/chat_list.dart';
import 'package:bobfriend/screen/home.dart';
import 'package:bobfriend/screen/login_signup.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:form_builder_validators/form_builder_validators.dart';


class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
        title: 'BobFriend',
        supportedLocales: const<Locale>[
          Locale('ko'),
          Locale('en')
        ],
        localizationsDelegates: [
          FormBuilderLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
        ],
        theme: ThemeData(
          colorScheme: ColorScheme.fromSwatch().copyWith(
            brightness: Brightness.light,
            primary: Colors.lightBlueAccent,
            secondary: Colors.lightBlueAccent,
          ),
          fontFamily: 'BM',
        ),
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot){
            //session이 유지되어 있으면 홈스크린으로
            if(snapshot.hasData) {
              //return ChatScreen();
              return HomeScreen();
            }
            //아니면 로그인 스크린으로
            print('==test==');
            print('LoginSignUpScreen');
            return LoginSignUpScreen();
          },
        ),
      );
  }




}
