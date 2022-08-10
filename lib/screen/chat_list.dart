import 'package:bobfriend/screen/create_room_form.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

//지역 변경시에 다시 로드되어야하므로 stateful
class ChatListScreen extends StatefulWidget {
  const ChatListScreen({Key? key}) : super(key: key);

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  Object _value = '1';
  var _chatList = [];
  bool showSpinner = true;

  void loadChatList() async{
    _chatList = [];
    var result = await FirebaseFirestore.instance.collection('chats').get().then((QuerySnapshot querySnapshot) =>{
      querySnapshot.docs.forEach((doc) {
        _chatList.add(doc.data());
      })
    });
    setState(() {
      showSpinner = false;
      _chatList = _chatList;
    });
  }

  @override
  void initState() {
    super.initState();
    loadChatList();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            DropdownButton(
                icon: const Icon(Icons.keyboard_arrow_down_rounded),
                underline: Container(),
                value: _value,
                items: const [
                  DropdownMenuItem(
                    value: '1',
                    child: Text(
                      '아주대',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  DropdownMenuItem(
                    value: '2',
                    child: Text(
                      '인하대',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ],
                onChanged: (value) {
                  showSpinner = true;
                  setState(() {
                    _value = value!;
                    debugPrint(_chatList.toString());
                  });
                  loadChatList();
                  //showSpinner = false;
                })
          ],
        ),
      ),
        body: ModalProgressHUD(
          inAsyncCall: showSpinner,
          child: Container(
          child: Column(
            children: [
              Center(
                child: Center(
                  child: Text(_chatList.toString()),
                )
              )
            ],
          ),
      ),
        ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          //입력폼
          Navigator.push(
              context,
              MaterialPageRoute(builder: (context){
                return CreateRoomFormScreen(univ: _value.toString(),);
              })
          );
          //폼 입력을 모두 받은 후, 버튼을 누르면 _createRoom(var personnel, String roomTitle)
        },
        backgroundColor: Colors.lightBlueAccent[150],
        child: const Icon(Icons.add),
      ),
    );
  }
}
