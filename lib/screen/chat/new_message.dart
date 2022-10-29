import 'dart:async';

import 'package:bobfriend/screen/login/login_signup.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:bobfriend/my_app.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

import '../../config/msg_config.dart';

late StreamSubscription<bool> keyboardSubscription;


class NewMessage extends StatefulWidget {
  const NewMessage(this.ref, {Key? key}) : super(key: key);

  final dynamic ref;
  @override
  State<NewMessage> createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> with WidgetsBindingObserver {
  final _controller = TextEditingController();
  var _userEnterMessage = '';
  late final FocusNode focusNode;

  void _sendMessage() async {
    final userData = await FirebaseFirestore.instance.collection('user').doc(FirebaseAuth.instance.currentUser!.uid).get();

    (widget.ref).collection('chat').add({
      'text': _userEnterMessage,
      'time': Timestamp.now(),
      'userId': FirebaseAuth.instance.currentUser!.uid,
      'nickname': userData.data()!['nickname'],
      'type': MessageType.normal.toString(),
      'action': MessageAction.none.toString(),
      'restaurant': '',
    });

    setState(() {
      _userEnterMessage = '';
    });
    _controller.clear();
  }

  @override
  void initState() {
    super.initState();
    focusNode = FocusNode();
    var keyboardVisibilityController = KeyboardVisibilityController();
    keyboardSubscription = keyboardVisibilityController.onChange.listen((bool visible) {
      if(!visible){
        focusNode.unfocus();
      }
    });
  }

  @override
  void dispose() {
    keyboardSubscription.cancel();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(10, 0, 0, 12),
      child: Row(
        children: [
          IconButton(onPressed: (){
            focusNode.requestFocus();
          },
              icon: const Icon(Icons.add_rounded)
          ),
          Expanded(
            child: TextField(
              cursorColor: Colors.black,
              focusNode: focusNode,
              maxLines: null,
              controller: _controller,
              decoration: const InputDecoration(
                labelStyle: TextStyle(color: Colors.black),
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
            icon: const Icon(Icons.send_rounded), color: Colors.orangeAccent,)
        ],
      ),
    );
  }
}
