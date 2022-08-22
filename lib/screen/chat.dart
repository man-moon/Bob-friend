import 'package:bobfriend/chatting/chat/new_message.dart';
import 'package:bobfriend/config/palette.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bobfriend/chatting/chat/message.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen(this.ref, {Key? key}) : super(key: key);

  final dynamic ref;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _authentication = FirebaseAuth.instance;
  User? loggedUser;
  String roomName = '';
  late int now;
  List<dynamic> users = [];

  void getCurrentUser() {
    try {
      final user = _authentication.currentUser;
      if (user != null) {
        loggedUser = user;
        print(loggedUser!.email);
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> getRoomInfo() async {
    await widget.ref.get().then((DocumentSnapshot ds) {
      setState(() {
        roomName = ds.get('roomName');
        now = ds.get('nowPersonnel');
        users = ds.get('users');
      });
    });
    //debugPrint(roomName);
  }
  void showPopup() {
    showDialog(
        context: context,
        //barrierDismissible - Dialog를 제외한 다른 화면 터치 x
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            // RoundedRectangleBorder - Dialog 화면 모서리 둥글게 조절
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            //Dialog Main Title
            title: Column(
              children: <Widget>[
                Text('알림'),
              ],
            ),
            //
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  '정말로 나가시겠습니까?',
                ),
              ],
            ),
            actions: <Widget>[

              TextButton(
                child: Text('취소'),
                onPressed: (){
                  Navigator.pop(context);
                },
              ),
              TextButton(
                child: Text('나가기'),
                onPressed: () {
                  users.remove(loggedUser!.uid);
                  widget.ref.update({'nowPersonnel': now - 1});
                  widget.ref.update({'users': users});

                  Navigator.pop(context);
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          //방제로 대체
          title: Text('채팅'),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.exit_to_app_rounded,
                  color: Colors.black26,
                ))
          ],
        ),
        drawer: Drawer(
          backgroundColor: Colors.white,
          child: Column(children: [
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: <Widget>[
                  DrawerHeader(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.lightBlueAccent,
                            Colors.white,
                          ]),
                      color: Colors.blue,
                    ),
                    child: Text(
                      '$roomName',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                      ),
                    ),
                  ),

                  //방 인원
                  ListTile(
                    leading: Icon(Icons.account_circle),
                    title: Text(''),
                  ),
                  ListTile(
                    leading: Icon(Icons.account_circle),
                    title: Text('Profile'),
                  ),
                  ListTile(
                    leading: Icon(Icons.account_circle),
                    title: Text('Settings'),
                  ),
                  ListTile(
                    leading: Icon(Icons.account_circle),
                    title: Text('Settings'),
                  ),
                  ListTile(
                    leading: Icon(Icons.account_circle),
                    title: Text('Settings'),
                  ),
                  ListTile(
                    leading: Icon(Icons.settings),
                    title: Text('Settings'),
                  ),
                ],
              ),
            ),
            Container(
              color: Palette.textColor1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text('방 나가기'),
                  IconButton(
                      onPressed: (){
                        showPopup();
                      },
                      icon: Icon(
                        Icons.exit_to_app_rounded,
                        color: Colors.white,
                      )
                  )
                ],
              ),
            )
          ],
          ),
        ),
        body: Container(
          child: Column(
            children: [
              Expanded(child: Message(widget.ref)),
              //SizedBox(height: 150,),
              NewMessage(widget.ref),
            ],
          ),
        ));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentUser();
    getRoomInfo();
  }
}
