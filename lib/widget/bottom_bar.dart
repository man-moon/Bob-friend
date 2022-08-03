import 'package:flutter/material.dart';

class BottomBar extends StatelessWidget {
  const BottomBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const TabBar(
        tabs: [
          Tab(icon: Icon(Icons.wechat_rounded)),
          Tab(icon: Icon(Icons.format_list_bulleted_rounded)),
          Tab(icon: Icon(Icons.people)),
          Tab(icon: Icon(Icons.person)),
        ]);
  }
}
