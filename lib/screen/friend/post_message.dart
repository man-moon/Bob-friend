import 'dart:typed_data';
import 'package:flutter_chat_bubble/bubble_type.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_4.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../Model/dm.dart';
import '../../provider/chat.dart';

class postMessage extends StatefulWidget {
  postMessage(this.ref, this.opponent, {Key? key}) : super(key: key);
  final dynamic ref;
  String? opponent;
  @override
  State<postMessage> createState() => _postMessageState();
}
class _postMessageState extends State<postMessage>{
  List<postModel> postList=[];
  void getDm() async {
    var tmpRef = await (widget.ref).collection('message').orderBy('time',descending: true).get();
    for(int i=0;i<tmpRef.size;i++){
      postModel tmpModel = new postModel();
      tmpModel.sender = tmpRef.docs[i].data()!['sender'];
      tmpModel.date = tmpRef.docs[i].data()!['time'];
      tmpModel.text = tmpRef.docs[i].data()!['text'];
      postList.add(tmpModel);
    }
    setState(() {
      postList = postList;
    });
  }
  String formatTimestamp(DateTime timestamp){
    DateTime now = DateTime.now();
    DateFormat formatter = DateFormat('yyyy-MM-dd');
    String strNow = formatter.format(now);
    String strTime = formatter.format(timestamp);
    return strTime;
  }
  @override
  void initState() {
    getDm();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        bottomOpacity: 0.0,
        elevation: 0.0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: (){
            Navigator.pop(context);
          },
        ),
        title: Text(widget.opponent!),
        actions: [
          IconButton(onPressed: (){},
              icon: const Icon(Icons.send)
          )
        ],
      ),
      body: ListView.builder(
          itemCount: postList.length,
          itemBuilder: (BuildContext context, int index){
            return Card(
              child: ListTile(
                title: Text(postList[index].sender!),
                trailing: Text(formatTimestamp(postList[index].date!.toDate())),
                subtitle: Text(postList[index].text!),
              ),
            );
          })
    );
  }
}
