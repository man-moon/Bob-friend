import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BobFriend',
      theme: ThemeData(
          colorScheme: ColorScheme.fromSwatch().copyWith(
            brightness: Brightness.dark,
            primary: Colors.black26,
            secondary: Colors.black12,
          )
      ),
      home: const DefaultTabController(
        length: 4,
        child: Scaffold(
          body: TabBarView(
            physics: NeverScrollableScrollPhysics(),
            children: [
              Icon(Icons.wechat_rounded),
              Icon(Icons.format_list_bulleted_rounded),
              Icon(Icons.people),
              Icon(Icons.person),
            ],
          ),
          bottomNavigationBar: TabBar(
              tabs: [
                Tab(icon: Icon(Icons.wechat_rounded)),
                Tab(icon: Icon(Icons.format_list_bulleted_rounded)),
                Tab(icon: Icon(Icons.people)),
                Tab(icon: Icon(Icons.person)),
              ]),
        ),
      ),
    );
  }
}