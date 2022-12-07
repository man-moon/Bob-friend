import 'package:bobfriend/provider/chat.dart';
import 'package:bobfriend/provider/my_catalog.dart';
import 'package:bobfriend/provider/user.dart';
import 'package:bobfriend/screen/chat/create_room_form.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:bobfriend/screen/chat/chat.dart';
import 'package:provider/provider.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

///채팅방 목록 스크린
///
/// + 참여중인 채팅방 구분 탭, 기존의 채팅목록에 표시
///

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({Key? key}) : super(key: key);

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {

  late ChatProvider chatProvider;
  late Object _value;
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

    if(mounted) {
      setState(() {
      showSpinner = false;
      _chatList = _chatList;
    });
    }
  }
  void showPopup() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            actionsAlignment: MainAxisAlignment.end,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            //Dialog Main Title
            title: Column(
              children: const <Widget>[
                Text('채팅방 설정'),
              ],
            ),
            actions: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: TextButton(
                      child: const Text('취소'),
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
                      child: const Text('나가기'),
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
  Future<DocumentReference<Map<String, dynamic>>> getChatInfo(int index) async{
    final chatRef = FirebaseFirestore.instance
        .collection('chats').doc(_chatList[index][1].toString());

    chatProvider = Provider.of<ChatProvider>(context, listen: false);

    await chatRef.get().then((DocumentSnapshot ds){
      List<dynamic> tempUsersList = ds.get('users');
      List<Map<String, dynamic>> usersList = [];
      for (var u in tempUsersList) {
        usersList.add(u);
      }

      chatProvider.users = usersList;
      chatProvider.docId = _chatList[index][1].toString();
      chatProvider.roomName = ds.get('roomName');
      chatProvider.date = ds.get('date');
      chatProvider.foodType = ds.get('foodType');
      chatProvider.gender = ds.get('gender');
      chatProvider.maxPersonnel = ds.get('maxPersonnel');
      chatProvider.nowPersonnel = ds.get('nowPersonnel');
      chatProvider.owner = ds.get('owner');
      chatProvider.univ = ds.get('univ');
      chatProvider.state = ds.get('state');
      chatProvider.meetingPlace = ds.get('meetingPlace');
    });

    return chatRef;
  }
  void tryJoin(dynamic chatRef, int index) async{
    chatProvider = Provider.of<ChatProvider>(context, listen: false);
    final maxPersonnel = chatProvider.maxPersonnel;
    final nowPersonnel = chatProvider.nowPersonnel;
    final users = chatProvider.users;

    bool joined = false;

    //* case1: already joined*/
    for (var u in users) {
      if(u.containsKey(FirebaseAuth.instance.currentUser!.uid) == true){
        joined = true;
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ChatScreen(chatRef)
            )
        ).then((value) {
          loadChatList();
        });
      }
    }

    if(joined == false){
      //* case2: not joined, overcapacity*/
      if(maxPersonnel! <= nowPersonnel!){
        //if(!mounted) return;
        showTopSnackBar(
          context,
          const CustomSnackBar.error(message: '방이 가득찼어요'),
          animationDuration: const Duration(milliseconds: 1200),
          displayDuration: const Duration(milliseconds: 0),
          reverseAnimationDuration: const Duration(milliseconds: 800),
        );
      }

      //* case3: joining */
      else{
        updateChatRoom(chatRef, users, nowPersonnel, maxPersonnel);
        if(!mounted) return;
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ChatScreen(chatRef)
            )
        ).then((value) {
          loadChatList();
        });
      }
    }
  }
  void updateChatRoom(final chatRef, final users, final nowPersonnel, final maxPersonnel) async{
    UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);
    users.add({FirebaseAuth.instance.currentUser!.uid: userProvider.nickname});
    await chatRef.update({'nowPersonnel': nowPersonnel + 1});
    await chatRef.update({'users': users});
  }

  final GlobalKey<RefreshIndicatorState>
  _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
    loadChatList();
    _value = (context.read<UserProvider>().univ == 'ajou') ? '1' : '2';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Colors.white,
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
        backgroundColor: Colors.greenAccent,
        strokeWidth: 4.0,
        onRefresh: () async {
          // Replace this delay with the code to be executed during refresh
          // and return a Future when code finishes execution.
          loadChatList();
          return Future<void>.delayed(const Duration(seconds: 1));
        },
          child: ListView.builder(
            itemCount: _chatList.length,
            itemBuilder: (BuildContext context, int index) {
              return Card(
                elevation: 0,
                child: ListTile(
                  onLongPress: () {
                    showPopup();
                  },
                  onTap: () async {
                    try{
                      await getChatInfo(index).then((chatRef){
                        tryJoin(chatRef, index);
                      });
                    } catch(e){
                      debugPrint(e.toString());
                    }
                  },
                  title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(_chatList[index][0]['roomName']),
                        Text('${_chatList[index][0]['nowPersonnel']}/${_chatList[index][0]['maxPersonnel']}')
                      ]),
                  subtitle: Text(_chatList[index][0]['foodType'].toString()),
                ),
              );
            },
          ),
      ),


      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        heroTag: 'chat_list',
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
        backgroundColor: Colors.greenAccent,
        child: const Icon(Icons.add),
      ),
    );
  }
}
