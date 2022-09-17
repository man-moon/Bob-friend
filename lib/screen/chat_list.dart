import 'package:bobfriend/screen/create_room_form.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:bobfriend/screen/chat.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

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

    final tmpRef = FirebaseFirestore.instance.collection('chats').get();
    await tmpRef.then((QuerySnapshot querySnapshot) =>{
      querySnapshot.docs.forEach((doc) {
        if(_value == '1'){
          if(doc.get('univ') == '1'){
            _chatList.add([doc.data(), doc.id]);
          }
        }
        if(_value == '2'){
          if(doc.get('univ') == '2'){
            _chatList.add([doc.data(), doc.id]);
          }
        }
      })
    });

    // await tmpRef.then((snapshot) {
    //   _chatListCount = snapshot.docs.length;
    // });

    setState(() {
      showSpinner = false;
      _chatList = _chatList;
    });
  }

  void showPopup() {
    showDialog(
        context: context,
        //barrierDismissible - Dialog를 제외한 다른 화면 터치 x
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            actionsAlignment: MainAxisAlignment.end,
            // RoundedRectangleBorder - Dialog 화면 모서리 둥글게 조절
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            //Dialog Main Title
            title: Column(
              children: <Widget>[
                Text('채팅방 설정'),
              ],
            ),
            actions: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: TextButton(
                      child: Text('취소'),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: TextButton(
                      child: Text('나가기'),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ],
              ),
            ],
          );
        }
      );
  }

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
  GlobalKey<RefreshIndicatorState>();

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

      body:
          RefreshIndicator(
          key: _refreshIndicatorKey,
          color: Colors.white,
          backgroundColor: Colors.blue,
          strokeWidth: 4.0,
          onRefresh: () async {
            // Replace this delay with the code to be executed during refresh
            // and return a Future when code finishs execution.
            loadChatList();

            return Future<void>.delayed(const Duration(seconds: 1));
          },
          // Pull from top to show refresh indicator.
          child: ListView.builder(
            itemCount: _chatList.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                onLongPress: () {
                  showPopup();
                },
                onTap: () async {
                  final ref = FirebaseFirestore.instance
                      .collection('chats').doc(_chatList[index][1].toString());

                  final user = FirebaseAuth.instance.currentUser;

                  int max = 0;
                  int now = 0;
                  List<dynamic> users = [];

                  await ref.get().then((DocumentSnapshot ds){
                    max = ds.get('maxPersonnel');
                    now = ds.get('nowPersonnel');
                    users = ds.get('users');
                  });


                  if(users.contains(user!.uid)){
                    if(!mounted) return;
                    Navigator.push(context, MaterialPageRoute(builder: (context) {
                      return ChatScreen(ref);
                    })).then((value) {
                      loadChatList();
                    });
                  }

                  else if(max <= now){
                    if(!mounted) return;
                    showTopSnackBar(
                      context,
                      const CustomSnackBar.error(message: '방이 가득찼어요'),
                      animationDuration: const Duration(milliseconds: 1200),
                      displayDuration: const Duration(milliseconds: 0),
                      reverseAnimationDuration: const Duration(milliseconds: 800),
                    );
                  }
                  else{
                    users.add(user.uid);
                    await ref.update({'nowPersonnel': now + 1});
                    await ref.update({'users': users});
                    if(!mounted) return;
                    Navigator.push(context, MaterialPageRoute(builder: (context) {
                      return ChatScreen(ref);
                    })).then((value) {
                      loadChatList();
                    });
                  }
                },
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(_chatList[index][0]['roomName']),
                      Text('${_chatList[index][0]['nowPersonnel']}/${_chatList[index][0]['maxPersonnel']}')
                    ]),
              );
            },
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
          ).then((value){
              loadChatList();
          });
        },
        backgroundColor: Colors.lightBlueAccent[150],
        child: const Icon(Icons.add),
      ),
    );
  }
}
