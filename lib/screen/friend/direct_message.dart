import 'dart:typed_data';

import 'package:bobfriend/screen/chat/chat_bubble.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

import '../../provider/chat.dart';

class DirectMessage extends StatefulWidget {
  DirectMessage({Key? key}) : super(key: key);

  @override
  State<DirectMessage> createState() => _DirectMessageState();
}
class _DirectMessageState extends State<DirectMessage>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(

    );
  }
}
