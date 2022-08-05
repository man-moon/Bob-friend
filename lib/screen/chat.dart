import 'package:bobfriend/chatting/chat/new_message.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bobfriend/chatting/chat/message.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _authentication = FirebaseAuth.instance;
  User? loggedUser;

  void getCurrentUser() {
    try{
      final user = _authentication.currentUser;
      if(user != null){
        loggedUser = user;
        print(loggedUser!.email);
      }
    }catch(e){
      print(e);
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //방제로 대체
        title: Text('채팅'),
        actions: [
          IconButton(
              onPressed: (){
                _authentication.signOut();
                //Navigator.pop(context);
              },
              icon: Icon(
                Icons.exit_to_app_rounded,
                color: Colors.black26,
              )
          )
        ],
      ),
      body: Container(
        child: Column(
          children: [
            Expanded(child: Message()),
            //SizedBox(height: 150,),
            NewMessage(),
          ],
        ),
      )
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentUser();
  }
}
