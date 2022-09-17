import 'package:bobfriend/chatting/chat/new_message.dart';
import 'package:bobfriend/config/palette.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bobfriend/chatting/chat/message.dart';
import 'package:bobfriend/my_app.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen(this.ref, {Key? key}) : super(key: key);

  final dynamic ref;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  String roomName = '';
  late int now;
  List<dynamic> users = [];
  List<dynamic> usersNickname = [];
  late String owner;
  late final bool isOwner;

  Future<void> getRoomInfo() async {
    await widget.ref.get().then((DocumentSnapshot ds) {
      setState(() {
        roomName = ds.get('roomName');
        now = ds.get('nowPersonnel');
        users = ds.get('users');
        owner = ds.get('owner');
      });
    });

    for (var e in users) {
      var userData = await FirebaseFirestore.instance.collection('user').doc(e.toString()).get();
      usersNickname.add(userData.data()!['nickname']);
    }
    setState(() {
      usersNickname = usersNickname;
      if(owner.compareTo(currentUser!.uid) == 0){
        isOwner = true;
      }
      else{
        isOwner = false;
      }
    });
  }

  void showOutPopup() {
    showDialog(
        context: context,
        //barrierDismissible - Dialog를 제외한 다른 화면 터치 x
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            // RoundedRectangleBorder - Dialog 화면 모서리 둥글게 조절
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            //Dialog Main Title
            title: Column(
              children: <Widget>[
                Text('알림'),
              ],
            ),
            //
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  '정말로 나가시겠습니까?',
                ),
              ],
            ),
            actions: <Widget>[
              TextButton(
                child: Text('취소'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              TextButton(
                child: Text('나가기'),
                onPressed: () {
                  users.remove(currentUser!.uid);
                  widget.ref.update({'nowPersonnel': now - 1});
                  widget.ref.update({'users': users});

                  Navigator.pop(context);
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }
  void showOwnerOutPopup() {
    showDialog(
        context: context,
        //barrierDismissible - Dialog를 제외한 다른 화면 터치 x
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            // RoundedRectangleBorder - Dialog 화면 모서리 둥글게 조절
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            //Dialog Main Title
            title: Column(
              children: <Widget>[
                Text('알림'),
              ],
            ),
            //
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  '방장은 퇴장할 수 없습니다. 방을 삭제하시겠습니까?',
                ),
              ],
            ),
            actions: <Widget>[
              TextButton(
                child: Text('취소'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              TextButton(
                child: Text('삭제'),
                onPressed: () {
                  widget.ref.delete();

                  Navigator.pop(context);
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }
  void showDeletePopup(){
    showDialog(
        context: context,
        //barrierDismissible - Dialog를 제외한 다른 화면 터치 x
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            // RoundedRectangleBorder - Dialog 화면 모서리 둥글게 조절
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            //Dialog Main Title
            title: Column(
              children: <Widget>[
                Text('알림'),
              ],
            ),
            //
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  '방을 삭제하시겠습니까?',
                ),
              ],
            ),
            actions: <Widget>[
              TextButton(
                child: Text('취소'),
                onPressed: () {

                  Navigator.pop(context);
                },
              ),
              TextButton(
                child: Text('삭제'),
                onPressed: () {
                  users.remove(currentUser!.uid);
                  widget.ref.update({'nowPersonnel': now - 1});
                  widget.ref.update({'users': users});

                  Navigator.pop(context);
                  Navigator.pop(context);
                  Navigator.pop(context);

                },
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(roomName),
          leading:
            IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.arrow_back_rounded,
                  color: Colors.white,
                ))
        ),
        endDrawer: Drawer(
          backgroundColor: Colors.white,
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    DrawerHeader(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.lightBlueAccent,
                              Colors.white,
                            ]),
                        color: Colors.blue,
                      ),
                      child: Text(
                        '$roomName',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                        ),
                      ),
                    ),
                    for (int i = 0; i < usersNickname.length; i++)
                      ListTile(
                        leading: Icon(Icons.account_circle),
                        title: Text(usersNickname[i]),
                      )
                  ],
                ),
              ),
              Container(
                color: Palette.textColor1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        IconButton(
                            onPressed: () {
                            },
                            icon: Icon(
                              Icons.settings,
                              color: Colors.white,
                            )
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        //Text('방 나가기'),
                        IconButton(
                          onPressed: () {
                            if(!isOwner) {
                              showOutPopup();
                            }

                            if(isOwner) {
                              showOwnerOutPopup();
                            }
                          },
                          icon: Icon(
                            Icons.exit_to_app_rounded,
                            color: Colors.white,
                          )
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
        body: Container(
          child: Column(
            children: [
              Expanded(child: Message(widget.ref)),
              //SizedBox(height: 150,),
              NewMessage(widget.ref),
            ],
          ),
        ));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getRoomInfo();
  }
}

