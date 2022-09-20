import 'package:bobfriend/chatting/chat/new_message.dart';
import 'package:bobfriend/screen/board.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bobfriend/chatting/chat/message.dart';
import 'package:form_builder_validators/localization/intl/messages_ar.dart';
import 'package:bobfriend/dto/board.dart';

class FireService{
  //싱글톤 패턴
  static final FireService _fireService = FireService._internal();
  factory FireService() => _fireService;
  FireService._internal();
  //create
  Future createBoard(Map<String,dynamic> json) async {
    await FirebaseFirestore.instance.collection("board").add(json);
  }
}
class BoardWriteScreen extends StatefulWidget {

  @override
  _BoardWriteScreenState createState() => _BoardWriteScreenState();
}

class _BoardWriteScreenState extends State<BoardWriteScreen> {
  String inputContent="";
  TextEditingController inputController = TextEditingController();
  @override

  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("게시판 글쓰기"),
        centerTitle: true,
        elevation: 0.0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.close),
        ),
        actions: [
          ElevatedButton(
            onPressed: () async{
              BoardModel _boardModel = BoardModel(
                author: '익명',
                content: inputController.text,
                date: Timestamp.now());
              await FireService().createBoard(_boardModel.toJson());
              Navigator.pop(context);
            },
            child: Text('작성하기'),
            style: TextButton.styleFrom(
              primary: Colors.black,
              backgroundColor: Colors.deepOrange,
              shape: StadiumBorder(),
            ),
          )
        ],
      ),
      body: Center(
        child: Form(
          child: Column(
            children:[
              Text('$inputContent'),
              Padding(

                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                  child: TextFormField(

                    keyboardType: TextInputType.multiline,
                    maxLines: 50,
                    minLines: 1,
                    controller: inputController,
                    decoration: InputDecoration(

                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        hintText: '내용을 입력해주세요.'),
                    textInputAction: TextInputAction.next,

                  )
              )
            ],
          ),
        ),
      ),
      bottomSheet: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Container(
              width: 50,

              child: IconButton(
                  onPressed: (){ },
                  icon: Icon(Icons.camera_enhance)
              )
          ),
        ),
      ),

    );
  }
}
