import 'package:bobfriend/screen/chat/chat_addition/additional_chat.dart';
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
  final userUid = FirebaseAuth.instance.currentUser!.uid;
  late ChatProvider chatProvider;

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

                  //필요
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
        elevation: 1,
          foregroundColor: Colors.black,
          title: Text(
            chatProvider.roomName.toString(),
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
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                  //Radius.circular(40),
                ),
                boxShadow: const [
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

                    //참여자
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

                    //방장
                    else if (chatProvider.owner == userUid) {
                      if (chatProvider.state == ChatState.none.toString()) {
                        showStartPopup();
                      }

                      else if (chatProvider.state ==
                          ChatState.selectRestaurant.toString()) {

                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                const AdditionalChatScreen(type: 'confirm',)));


                        //set chatroom state
                        FirebaseFirestore.instance
                            .collection('chats')
                            .doc(chatProvider.docId)
                            .update({'state': ChatState.selectMenu.toString()});

                      }

                      else if (chatProvider.state ==
                        ChatState.selectMenu.toString()) {
                          var ref = FirebaseFirestore.instance
                            .collection('chats')
                            .doc(chatProvider.docId);

                          ref.update({'state': ChatState.selectMeetingPlace.toString()});
                        }

                      else if (chatProvider.state ==
                          ChatState.selectMeetingPlace.toString()) {
                        final controller = TextEditingController();
                        final GlobalKey<FormState> formKey = GlobalKey<FormState>();
                        showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (BuildContext context) {
                              var ref = FirebaseFirestore.instance
                                  .collection('chats')
                                  .doc(chatProvider.docId);
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
                                  children: <Widget>[
                                    const Text(
                                      '어디서 모일지 장소를 공지해주세요!',
                                    ),
                                    Form(
                                      key: formKey,
                                      child: TextFormField(
                                        controller: controller,
                                        validator: (value) {
                                          if(value!.trim().isEmpty) {
                                            return '모임 장소를 입력해주세요';
                                          }
                                          return null;
                                        },
                                        decoration: const InputDecoration(
                                            labelStyle: TextStyle(color: Colors.grey),
                                            labelText: '모임 장소'
                                        ),
                                        maxLength: 10,

                                      ),
                                    ),
                                  ],
                                ),
                                actions: <Widget>[
                                  TextButton(
                                    child: const Text('취소', style: TextStyle(color: Colors.black),),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                  TextButton(
                                    child: const Text('공지', style: TextStyle(color: Colors.black)),
                                    onPressed: () {
                                      if(formKey.currentState!.validate()) {
                                        String meetingPlace = controller.text;
                                        ref.collection("chat")
                                            .doc("selectMeetingPlace")
                                            .set({
                                          'text': meetingPlace,
                                          'time': Timestamp.now(),
                                          'userId': 'admin',
                                          'nickname': '밥친구',
                                          'type': MessageType.action.toString(),
                                          'action': MessageAction.selectMeetingPlace.toString(),
                                          'restaurant': '',
                                        });
                                        Navigator.of(context).pop();

                                        FirebaseFirestore.instance
                                            .collection('chats')
                                            .doc(chatProvider.docId).update({
                                                'state': ChatState.callRider.toString(),
                                                'meetingPlace': controller.text,
                                            });
                                        chatProvider.meetingPlace = controller.text;
                                      }
                                    },
                                  ),
                                ],
                              );
                            });
                      }

                      else if (chatProvider.state ==
                          ChatState.callRider.toString()) {

                        showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (BuildContext context) {
                              var ref = FirebaseFirestore.instance
                                  .collection('chats')
                                  .doc(chatProvider.docId);
                              return AlertDialog(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0)),
                                //Dialog Main Title
                                title: Column(
                                  children: const <Widget>[
                                    Text('배달 서비스 선정'),
                                  ],
                                ),
                                actions: <Widget>[
                                  TextButton(
                                    child: const Text('타 배달앱 이용하기', style: TextStyle(color: Colors.black),),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  TextButton(
                                    child: const Text('밥친구 배달원 이용하기', style: TextStyle(color: Colors.black)),
                                    onPressed: () {

                                      //채팅방 전체 카탈로그 정보 보여주는건 어차피 해야될 일임
                                      //채팅방 카탈로그 불러온 뒤
                                      //가게, 메뉴, 메뉴 별 가격, 총 가격을 파이어베이스 'allCatalogs'에 저장.


                                      //배달 서비스 콜 목록에 뜨게 해야됨
                                      ref.collection('catalog').doc('allCatalogs').get().then(
                                              (value) =>
                                                  FirebaseFirestore.instance.collection('delivery')
                                                      .doc(chatProvider.docId).set({
                                                    'name': chatProvider.restaurantName,
                                                    'menu': value.data()!['menu'],
                                                    'count': value.data()!['count'],
                                                    'price': value.data()!['price'],
                                                    'isMatched': false,
                                                    'deliveryLocation': chatProvider.meetingPlace,
                                                    'orderTime': Timestamp.now(),
                                                  })
                                      );
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            });


                        FirebaseFirestore.instance
                            .collection('chats')
                            .doc(chatProvider.docId).update(
                            {'state': ChatState.notifyDeliveryCompletion.toString()});
                      }

                      else if(chatProvider.state ==
                          ChatState.notifyDeliveryCompletion.toString()) {
                        showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (BuildContext context) {
                              var ref = FirebaseFirestore.instance
                                  .collection('chats')
                                  .doc(chatProvider.docId);
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
                                content:
                                    const Text('친구들에게 배달도착 알림메시지를 전송할까요?',),
                                actions: <Widget>[
                                  TextButton(
                                    child: const Text('취소', style: TextStyle(color: Colors.black),),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                  TextButton(
                                    child: const Text('공지', style: TextStyle(color: Colors.black)),
                                    onPressed: () {
                                        ref.collection("chat")
                                            .doc("notifyDeliveryCompletion")
                                            .set({
                                          'text': '밥 먹을 시간이에요! 모두들 모임장소로 모여주세요!',
                                          'time': Timestamp.now(),
                                          'userId': 'admin',
                                          'nickname': '밥친구',
                                          'type': MessageType.normal.toString(),
                                          'action': MessageAction.rate.toString(),
                                          'restaurant': '',
                                        });
                                        Navigator.of(context).pop();
                                        FirebaseFirestore.instance
                                            .collection('chats')
                                            .doc(chatProvider.docId).update({'state': ChatState.rate.toString()});
                                    },
                                  ),
                                ],
                              );
                            });
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

                        if (snapshot.data!['state'].toString() ==
                            ChatState.selectMeetingPlace.toString()) {
                          if (chatProvider.owner ==
                              userUid) {
                            return const Text('모임 장소를 공지해주세요');
                          } else if (chatProvider.owner !=
                              userUid) {
                            return const Text('모임 장소를 정하는 중이에요');
                          }
                        }

                        if (snapshot.data!['state'].toString() ==
                            ChatState.callRider.toString()) {
                          if (chatProvider.owner ==
                              userUid) {
                            return const Text('배달 서비스를 골라주세요');
                          } else if (chatProvider.owner !=
                              userUid) {
                            return const Text('배달 서비스를 정하는 중이에요');
                          }
                        }

                        if (snapshot.data!['state'].toString() ==
                            ChatState.notifyDeliveryCompletion.toString()) {
                          if (chatProvider.owner ==
                              userUid) {
                            return const Text('배달 도착 알림을 보낼게요');
                          } else if (chatProvider.owner !=
                              userUid) {
                            return const Text('배달이 도착하면 알려드릴게요');
                          }
                        }

                        if (snapshot.data!['state'].toString() ==
                            ChatState.rate.toString()) {
                          return const Text('맛있게 드세요!');
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
  }
}
