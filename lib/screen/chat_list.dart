import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

//지역 변경시에 다시 로드되어야하므로 stateful
class ChatListScreen extends StatefulWidget {
  const ChatListScreen({Key? key}) : super(key: key);

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  Object _value = '1';

  void _createRoom(String personnel, String roomTitle) async {
    final user = FirebaseAuth.instance.currentUser;
    final userData = await FirebaseFirestore.instance.collection('user').doc(user!.uid).get();

    FirebaseFirestore.instance.collection('room').add({
      'time': Timestamp.now(),
      'owner': user!.uid,
      'personnel': personnel,
    });
    FirebaseFirestore.instance.collection('room').add({
      'time': Timestamp.now(),
      'userId': user.uid,
      'userNickname': userData.data()!['userNickname'],
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            DropdownButton(
                icon: const Icon(Icons.keyboard_arrow_down_rounded),
                underline: Container(),
                value: _value,
                items: const [
                  DropdownMenuItem(
                    value: '1',
                    child: Text(
                      '아주대',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  DropdownMenuItem(
                    value: '2',
                    child: Text(
                      '인하대',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    _value = value!;
                  });
                })
          ],
        ),
      ),
        body: Container(
        child: Column(
          children: [
            if(_value == '1')
              //firebase 구조 (ajou, inha(collection) -> 방제(doc) -> 채팅기록(collection) -> 채팅메시지, 로그(field)
              Expanded(child: Text('ajou')),
            if(_value == '2')
              Expanded(child: Text('inha')),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          //입력폼 띄우고
          //폼 입력을 모두 받은 후, 버튼을 누르면 _createRoom(var personnel, String roomTitle)
        },
        backgroundColor: Colors.lightBlueAccent[150],
        child: const Icon(Icons.add),
      ),
    );
  }
}
