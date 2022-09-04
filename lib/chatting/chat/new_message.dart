import 'package:bobfriend/screen/login_signup.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NewMessage extends StatefulWidget {
  const NewMessage(this.ref, {Key? key}) : super(key: key);

  final dynamic ref;
  @override
  State<NewMessage> createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {

  final _controller = TextEditingController();
  var _userEnterMessage = '';

  void _sendMessage() async {
    final userData = await FirebaseFirestore.instance.collection('user').doc(currentUser!.user!.uid).get();

    (widget.ref).collection('chat').add({
      'text': _userEnterMessage,
      'time': Timestamp.now(),
      'userId': currentUser!.user!.uid,
      'nickname': userData.data()!['nickname'],
    });

    setState(() {
      _userEnterMessage = '';
    });
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      //margin: EdgeInsets.only(top: 30),
      padding: EdgeInsets.fromLTRB(10, 0, 0, 12),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              maxLines: null,
              controller: _controller,
              decoration: InputDecoration(
                labelText: '메세지 전송'
              ),
              onChanged: (value){
                setState(() {
                  _userEnterMessage = value;
                });
              },
            ),
          ),
          IconButton(
            onPressed: _userEnterMessage.trim().isEmpty ? null : _sendMessage,
            icon: Icon(Icons.send_rounded), color: Colors.blue,)
        ],
      ),
    );
  }
}
