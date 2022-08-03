import 'package:flutter/material.dart';

//지역 변경시에 다시 로드되어야하므로 stateful
class ChatListScreen extends StatefulWidget {
  const ChatListScreen({Key? key}) : super(key: key);

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      //DB에서 데이터를 가져오고 보여주는 과정이 필요함
    );
  }
}

//지역 변경 시 상단 지역 이름이 바뀌어야 하므로 stateful
class TopBar extends StatefulWidget {
  const TopBar({Key? key}) : super(key: key);

  @override
  State<TopBar> createState() => _TopBarState();
}

class _TopBarState extends State<TopBar> {
  @override
  Widget build(BuildContext context) {
    return Container(

    );
  }
}
