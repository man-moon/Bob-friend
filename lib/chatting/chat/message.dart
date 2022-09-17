import 'package:bobfriend/chatting/chat/chat_bubble.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bobfriend/my_app.dart';

import '../../screen/login_signup.dart';

class Message extends StatelessWidget {
  const Message(this.ref, {Key? key}) : super(key: key);

  final dynamic ref;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: ref.collection('chat').orderBy('time', descending: true).snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot){
        if(snapshot.connectionState == ConnectionState.waiting){
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        final chatDocs = snapshot.data!.docs;

        return ListView.builder(
          padding: EdgeInsets.fromLTRB(0, 0, 0, 12),
          reverse: true,
          itemCount: chatDocs.length,
          itemBuilder: (context, index) {
            return ChatBubbles(
                chatDocs[index]['text'],
                chatDocs[index]['userId'].toString() == currentUser!.uid,
                chatDocs[index]['nickname']
            );
          },
        );
      },
    );
  }
}
