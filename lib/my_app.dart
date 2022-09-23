import 'package:bobfriend/provider/chat.dart';
import 'package:bobfriend/provider/joined_chatrooms_list.dart';
import 'package:bobfriend/provider/user.dart';
import 'package:bobfriend/screen/home.dart';
import 'package:bobfriend/screen/login/login_signup.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:provider/provider.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BobFriend',
      supportedLocales: const <Locale>[Locale('ko'), Locale('en')],
      localizationsDelegates: const [
        FormBuilderLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
      ],
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch().copyWith(
          brightness: Brightness.light,
          primary: Colors.deepOrangeAccent,
          secondary: Colors.deepOrangeAccent,
        ),
        fontFamily: 'BM',
      ),
      home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return const HomeScreen();
            }
            return LoginSignupScreen();
          },
        ),
    );
  }
}
