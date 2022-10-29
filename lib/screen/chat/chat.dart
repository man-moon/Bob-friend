import 'package:bobfriend/screen/chat/new_message.dart';
import 'package:bobfriend/config/palette.dart';
import 'package:bobfriend/provider/chat.dart';
import 'package:bobfriend/screen/profile/profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bobfriend/screen/chat/message.dart';
import 'package:bobfriend/my_app.dart';
import 'package:provider/provider.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../config/chat_config.dart';
import '../../config/msg_config.dart';
import '../../provider/user.dart';

/// 채팅방 스크린

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
  final userUid = FirebaseAuth.instance.currentUser!.uid;
  late ChatProvider chatProvider;

  Future<void> getRoomInfo() async {
    await widget.ref.get().then((DocumentSnapshot ds) {
      setState(() {
        roomName = ds.get('roomName');
        now = ds.get('nowPersonnel');
        //users = ds.get('users');
        owner = ds.get('owner');
      });
    });
    for (var e in users) {
      var userData = await FirebaseFirestore.instance
          .collection('user')
          .doc(e.toString())
          .get();
      usersNickname.add(userData.data()![0]['nickname']);
    }
    setState(() {
      usersNickname = usersNickname;
    });
  }

  void showOutPopup() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            //Dialog Main Title
            title: Column(
              children: const <Widget>[
                Text('알림'),
              ],
            ),
            //
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const <Widget>[
                Text(
                  '정말로 나가시겠습니까?',
                ),
              ],
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('취소'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              TextButton(
                child: const Text('나가기'),
                onPressed: () {
                  users.remove(userUid);
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
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            //Dialog Main Title
            title: Column(
              children: const <Widget>[
                Text('알림'),
              ],
            ),
            //
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const <Widget>[
                Text(
                  '방장은 퇴장할 수 없습니다. 방을 삭제하시겠습니까?',
                ),
              ],
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('취소'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              TextButton(
                child: const Text('삭제'),
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

  void showDeletePopup() {
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
              children: const <Widget>[
                Text('알림'),
              ],
            ),
            //
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const <Widget>[
                Text(
                  '방을 삭제하시겠습니까?',
                ),
              ],
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('취소'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              TextButton(
                child: const Text('삭제'),
                onPressed: () {
                  users.remove(userUid);
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

  void showReportPopup() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            //Dialog Main Title
            title: Column(
              children: const <Widget>[
                Text('신고'),
              ],
            ),
            //
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const <Widget>[
                Text(
                  '신고 내용 업데이트 필요',
                ),
              ],
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('취소'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              TextButton(
                child: const Text('신고'),
                onPressed: () {
                  showTopSnackBar(
                    context,
                    const CustomSnackBar.success(message: '신고가 접수되었어요'),
                    animationDuration: const Duration(milliseconds: 1200),
                    displayDuration: const Duration(milliseconds: 0),
                    reverseAnimationDuration: const Duration(milliseconds: 800),
                  );
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }

  void showStartPopup() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            //Dialog Main Title
            title: Column(
              children: const <Widget>[
                Text('안내'),
              ],
            ),
            //
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const <Widget>[
                Text(
                  '주문 프로세스를 시작할까요?',
                ),
              ],
            ),
            actions: <Widget>[
              TextButton(
                child: const Text(
                  '취소',
                  style: TextStyle(color: Colors.black),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              TextButton(
                child: const Text(
                  '시작',
                  style: TextStyle(color: Colors.black),
                ),
                onPressed: () async {
                  Navigator.pop(context);
                  var doc = FirebaseFirestore.instance.collection('chats').doc(chatProvider.docId);

                  await doc.update({'state': ChatState.selectRestaurant.toString()});

                  await doc.collection('chat').doc('selectRestaurant').set({
                    'text': '가게 선정을 시작합니다!\n어떤 맛집이 있을까요~?',
                    'time': Timestamp.now(),
                    'userId': 'admin',
                    'nickname': '밥친구',
                    'type': MessageType.action.toString(),
                    'action': MessageAction.selectRestaurant.toString(),
                    'restaurant': '',
                  });
                },
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    chatProvider = Provider.of<ChatProvider>(context, listen: false);
    var doc = FirebaseFirestore.instance.collection('chats').doc(chatProvider.docId);

    return Scaffold(
      appBar: AppBar(
          foregroundColor: Colors.black,
          title: Text(
            roomName,
            style: const TextStyle(
              color: Colors.black,
            ),
          ),
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.arrow_back_rounded,
                color: Colors.black,
              ))),
      endDrawer: Drawer(
        backgroundColor: Colors.white,
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  /** 서랍 헤더 */
                  const SizedBox(
                    height: 85,
                    child: DrawerHeader(
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        color: Colors.orangeAccent,
                      ),
                      child: Text(
                        '채팅방 서랍',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                  /** 참여자 */
                  const SizedBox(
                    height: 20,
                    child: Padding(
                        padding: EdgeInsets.only(left: 18),
                        child: Text(
                          '참여자',
                          style: TextStyle(fontSize: 15),
                        )),
                  ),
                  /** 참여자 목록 */
                  StreamBuilder(
                      stream: widget.ref.snapshots(),
                      builder: (context,
                          AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>>
                              snapshot) {
                        if (snapshot!.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        final docRef = snapshot.data!;

                        return ListView.builder(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemCount: docRef.data()!['users'].length,
                            itemBuilder: (BuildContext context, int index) {
                              String userNickname = docRef
                                  .data()!['users'][index]
                                  .values
                                  .toString();
                              String tmpUid = docRef
                                  .data()!['users'][index]
                                  .keys
                                  .toString();
                              userNickname = userNickname.substring(
                                  1, userNickname.length - 1);
                              tmpUid =
                                  tmpUid.substring(1, tmpUid.length - 1);
                              return ListTile(
                                onTap: () {
                                  if (userUid ==
                                      tmpUid) {
                                    debugPrint('마이페이지');
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const ProfileScreen()));
                                  } else {
                                    debugPrint('다른사람페이지');
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => ProfileScreen(
                                                  uid: tmpUid,
                                                )));
                                  }
                                },
                                title: Text(userNickname),
                                leading:
                                    const Icon(Icons.account_circle_rounded),
                              );
                            });
                      }),
                  const Divider(),
                ],
              ),
            ),
            /**
             * drawer 하단
             */
            Container(
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      /**
                       * 채팅방 설정
                       */
                      IconButton(
                          onPressed: () {
                            //설정
                          },
                          icon: const Icon(
                            Icons.settings,
                            color: Colors.black,
                          ))
                    ],
                  ),

                  /**
                   * 채팅방 퇴장
                   */
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      //Text('방 나가기'),
                      IconButton(
                          onPressed: () {
                            if (chatProvider.owner !=
                                userUid) {
                              showOutPopup();
                            } else if (chatProvider.owner ==
                                userUid) {
                              showOwnerOutPopup();
                            }
                          },
                          icon: const Icon(
                            Icons.exit_to_app_rounded,
                            color: Colors.black,
                          )),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(child: Message(widget.ref)),
          Container(
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                  //Radius.circular(40),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    blurRadius: 15.0,
                    spreadRadius: 1.0,
                  ),
                ],
              ),
              child: Column(children: [
                TextButton(
                  onPressed: () {
                    if (chatProvider.owner != userUid) {
                      if (chatProvider.state == ChatState.none.toString()) {
                        showTopSnackBar(
                          context,
                          const CustomSnackBar.info(
                              message: '아직 친구들을 기다리는 중이에요. 잠시만 기다려주세요!'),
                          animationDuration: const Duration(milliseconds: 2300),
                          displayDuration: const Duration(milliseconds: 0),
                          reverseAnimationDuration:
                              const Duration(milliseconds: 800),
                        );
                      }

                      if (chatProvider.state ==
                          ChatState.selectRestaurant.toString()) {
                        showTopSnackBar(
                          context,
                          const CustomSnackBar.info(
                              message: '방장님이 가게를 확정할 때까지 기다려주세요!'),
                          animationDuration: const Duration(milliseconds: 2300),
                          displayDuration: const Duration(milliseconds: 0),
                          reverseAnimationDuration:
                              const Duration(milliseconds: 800),
                        );
                      }

                      if (chatProvider.state ==
                          ChatState.selectMenu.toString()) {
                        showTopSnackBar(
                          context,
                          const CustomSnackBar.info(
                              message: '아직 메뉴를 확정하지 못한 친구가 있어요. 잠시만 기다려주세요!'),
                          animationDuration: const Duration(milliseconds: 2300),
                          displayDuration: const Duration(milliseconds: 0),
                          reverseAnimationDuration:
                              const Duration(milliseconds: 800),
                        );
                      }
                    }
                    else if (chatProvider.owner == userUid) {
                      if (chatProvider.state == ChatState.none.toString()) {
                        showStartPopup();
                      }
                      else if (chatProvider.state ==
                          ChatState.selectRestaurant.toString()) {
                        FirebaseFirestore.instance
                            .collection('chats')
                            .doc(chatProvider.docId)
                            .update({'state': ChatState.selectMenu.toString()});

                        doc.collection('chat').doc('selectMenu').set({
                          'text': '각자 먹고싶은 메뉴를 골라주세요!\n',
                          'time': Timestamp.now(),
                          'userId': 'admin',
                          'nickname': '밥친구',
                          'type': MessageType.action.toString(),
                          'action': MessageAction.selectMenu.toString(),
                          'restaurant': '',
                        });
                      }
                      else if (chatProvider.state ==
                          ChatState.selectMenu.toString()) {
                        FirebaseFirestore.instance
                            .collection('chats')
                            .doc(chatProvider.docId)
                            .update({'state': ChatState.none.toString()});
                      }
                    }
                  },
                  style: ButtonStyle(
                      padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                          EdgeInsets.symmetric(horizontal: 22.0)),
                      backgroundColor:
                          MaterialStatePropertyAll<Color>(Colors.grey),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ))),
                  child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('chats')
                        .doc(chatProvider.docId)
                        .snapshots(),
                    builder: (context, AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
                      if (snapshot.hasData) {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          chatProvider.state =
                              snapshot.data!['state'].toString();
                        });
                        if (snapshot.data!['state'].toString() ==
                            ChatState.none.toString()) {
                          if (chatProvider.owner ==
                              userUid) {
                            return const Text('지금있는 친구들이랑 먹을래요');
                          } else if (chatProvider.owner !=
                              userUid) {
                            return const Text('친구들을 기다리는 중이에요');
                          }
                        }

                        if (snapshot.data!['state'].toString() ==
                            ChatState.selectRestaurant.toString()) {
                          if (chatProvider.owner ==
                              userUid) {
                            return const Text('가게를 확정할게요!');
                          } else if (chatProvider.owner !=
                              userUid) {
                            return const Text('어느 가게에서 먹을지 고르는 중이에요');
                          }
                        }

                        if (snapshot.data!['state'].toString() ==
                            ChatState.selectMenu.toString()) {
                          if (chatProvider.owner ==
                              userUid) {
                            return const Text('메뉴를 확정할게요!');
                          } else if (chatProvider.owner !=
                              userUid) {
                            return const Text('아직 메뉴를 고르지 못한 친구가 있어요');
                          }
                        }
                      } else {
                        return const Text('');
                      }
                      return const Text('');
                    },
                  ),
                ),
                NewMessage(widget.ref),
              ])),
        ],
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getRoomInfo();
  }
}
