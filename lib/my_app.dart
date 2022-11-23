import 'package:bobfriend/screen/load/loading.dart';
import 'package:bobfriend/screen/newlogin/new_login_signup.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
          title: 'BobFriend',
          supportedLocales: const <Locale>[Locale('ko'), Locale('en')],
          localizationsDelegates: const [
            FormBuilderLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          theme: ThemeData(
            colorScheme: ColorScheme.fromSwatch().copyWith(
              brightness: Brightness.light,
              primary: Colors.white,
              secondary: Colors.deepOrangeAccent,
            ),
            appBarTheme: const AppBarTheme(
              iconTheme: IconThemeData(
                color: Colors.black,
              ),
              titleTextStyle: TextStyle(
                color: Colors.black,
                fontFamily: 'BM',
                fontSize: 20,

              )
            ),
            textSelectionTheme: const TextSelectionThemeData(
                cursorColor: Colors.black
            ),
            fontFamily: 'BM',
          ),
          home: Builder(
            builder: (context) {
              return (FirebaseAuth.instance.currentUser != null) ?
                const LoadingScreen() : const NewLoginSignupScreen();
            },
          ),
        );
  }
}
