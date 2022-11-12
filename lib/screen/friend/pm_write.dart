import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Model/dm.dart';
import '../../provider/user.dart';

class pmWriteScreen extends StatefulWidget {
  pmWriteScreen(this.ref,{Key? key}) : super(key: key);
  final dynamic ref;
  @override
  _pmScreenState createState() => _pmScreenState();
}

class _pmScreenState extends State<pmWriteScreen> {
  late UserProvider userProvider;
  void initState() {
    userProvider = Provider.of<UserProvider>(context, listen: false);
    super.initState();
  }
  String inputContent="";
  TextEditingController inputController = TextEditingController();
  @override

  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("쪽지 보내기"),
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
              postModel _postModel = postModel(
                  sender: userProvider.nickname,
                  text: inputController.text,
                  date: Timestamp.now(),
                  userId: FirebaseAuth.instance.currentUser!.uid);
              await (widget.ref).collection('message').add({
                'sender':_postModel.sender,
                'text':_postModel.text,
                'date':_postModel.date,
                'userId':_postModel.userId
              });

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