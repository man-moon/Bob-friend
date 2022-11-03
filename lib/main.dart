import 'package:bobfriend/provider/chat.dart';
import 'package:bobfriend/provider/my_catalog.dart';
import 'package:bobfriend/provider/user.dart';
import 'package:flutter/material.dart';
import 'package:bobfriend/my_app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => ChatProvider()),
        ChangeNotifierProvider(create: (_) => MyCatalogProvider()),
      ],
      child: const MyApp(),
    )
  );
}
