import 'dart:async';

import 'package:bobfriend/provider/user.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bobfriend/Model/board.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:provider/provider.dart';

late StreamSubscription<bool> keyboardSubscription;


class BoardWriteScreen extends StatefulWidget {
  BoardWriteScreen({super.key});

  @override
  _BoardWriteScreenState createState() => _BoardWriteScreenState();
}

class _BoardWriteScreenState extends State<BoardWriteScreen> {
  String inputContent = "";
  bool isAnonymous = false;
  UserProvider userProvider = new UserProvider();
  TextEditingController inputController = TextEditingController();
  BoardModel _boardModel = new BoardModel();
  late final FocusNode focusNode;

  void writeBoard() async {
    String? _author = isAnonymous ? "익명" : userProvider.nickname;
    FirebaseFirestore.instance.collection('board').add(
        {
          'author': _author,
          'userId':FirebaseAuth.instance.currentUser!.uid,
          'content': inputController.text,
          'date': Timestamp.now(),
          'likeCnt': [],
          'commentCnt': 0
        }
    );
  }

  @override
  void initState() {
    userProvider = Provider.of<UserProvider>(context, listen: false);
    focusNode = FocusNode();
    var keyboardVisibilityController = KeyboardVisibilityController();
    keyboardSubscription =
        keyboardVisibilityController.onChange.listen((bool visible) {
      if (!visible) {
        focusNode.unfocus();
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    keyboardSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("게시판 글쓰기"),
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.close),
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              if (inputContent.trim().isEmpty) {
                null;
              } else {
                writeBoard();
                Navigator.pop(context);
              }
            },
            child: Text('작성하기'),
            style: TextButton.styleFrom(
              backgroundColor: Colors.deepOrange,
              shape: StadiumBorder(),
            ),
          )
        ],
      ),
      body: Center(
        child: Form(
          child: Column(
            children: [
              Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                  child: TextField(
                    focusNode: focusNode,
                    maxLines: 50,
                    minLines: 1,
                    controller: inputController,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        hintText: '내용을 입력해주세요.'),
                    onChanged: (value) {
                      setState(() {
                        inputContent = value;
                      });
                    },
                  ))
            ],
          ),
        ),
      ),
      bottomSheet: SafeArea(
        child: Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                flex: 1,
                child: IconButton(
                    onPressed: () {}, icon: Icon(Icons.camera_enhance)),
              ),
              Expanded(
                  flex: 2,
                  child: Container(
                    width: 1,
                    height: 1,
                  )),
              Expanded(
                flex: 1,
                child: Row(children: [
                  Checkbox(
                    value: isAnonymous,
                    onChanged: (value) {
                      setState(() {
                        isAnonymous = value!;
                      });
                    },
                  ),
                  const Text("익명"),
                ]),
              )
            ],
          ),
        ),
      ),
    );
  }
}
