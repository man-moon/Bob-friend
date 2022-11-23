import 'dart:typed_data';

import 'package:bobfriend/screen/chat/chat_bubble.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

import '../../provider/chat.dart';

class Message extends StatelessWidget {
  const Message(this.ref, {Key? key}) : super(key: key);
  final dynamic ref;


  @override
  Widget build(BuildContext context) {

    return StreamBuilder(
      stream: ref.collection('chat').orderBy('time', descending: true).snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot){
        if(snapshot.connectionState == ConnectionState.waiting){
          return const Center(
            child: CircularProgressIndicator(color: Colors.black,),
          );
        }

        else{
          final chatDocs = snapshot.data!.docs;
          return
            ListView.builder(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 12),
              reverse: true,
              itemCount: chatDocs.length,
              itemBuilder: (context, index) {
                return ChatBubbles(
                    chatDocs[index]['text'],
                    chatDocs[index]['userId'].toString() == FirebaseAuth.instance.currentUser!.uid,
                    chatDocs[index]['nickname'],
                    chatDocs[index]['action'],
                    chatDocs[index]['restaurant'],
                );
              },
            );
        }
      },
    );
  }
}
