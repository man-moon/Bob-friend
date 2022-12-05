import 'package:flutter/material.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';

class BottomBar extends StatelessWidget {
  const BottomBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ConvexAppBar(
      elevation: 0,
      color: Colors.grey,
      activeColor: Colors.black,
      backgroundColor: Colors.white,
      style: TabStyle.react,
      top: -13,
      curveSize: 100,
      items: const [
        TabItem(title: '채팅', icon: Icon(Icons.wechat_rounded, color: Colors.greenAccent),),
        TabItem(title: '배달', icon: Icon(Icons.delivery_dining, color: Colors.greenAccent),),
        TabItem(title: '커뮤니티', icon: Icon(Icons.format_list_bulleted_rounded, color: Colors.greenAccent)),
        TabItem(title: '친구', icon: Icon(Icons.people, color: Colors.greenAccent)),
        TabItem(title: '마이페이', icon: Icon(Icons.person, color: Colors.greenAccent)),
        TabItem(title: '내 가게', icon: Icon(Icons.restaurant, color: Colors.greenAccent)),
        TabItem(title: '주문', icon: Icon(Icons.list, color: Colors.greenAccent)),
      ],
    );
  }
}
