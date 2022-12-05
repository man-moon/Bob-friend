import 'package:bobfriend/Model/dm.dart';
import 'package:bobfriend/provider/user.dart';
import 'package:bobfriend/screen/friend/pm_write.dart';
import 'package:bobfriend/screen/friend/post_message.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../profile/profile.dart';

class FriendScreen extends StatefulWidget {
  const FriendScreen({Key? key}) : super(key: key);

  @override
  State<FriendScreen> createState() => _FriendScreenState();
}

class _FriendScreenState extends State<FriendScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late UserProvider userProvider;
  String curUid = FirebaseAuth.instance.currentUser!.uid;
  String? myNickname = '';
  List<dmListModel> friendsList = [];
  List<dynamic> friendsIdList = [];
  List<dmListModel> dmList = [];

  void getFriendInfo() async {
    final userRef =
        await FirebaseFirestore.instance.collection('user').doc(curUid).get();
    if(mounted) {
      setState(() {
      friendsIdList = userRef.data()!['friends'];
    });
    }
    for (var i = 0; i < friendsIdList.length; i++) {
      dmListModel tmpMd = new dmListModel();
      var tmpRef = await FirebaseFirestore.instance
          .collection('user')
          .doc(friendsIdList[i])
          .get();
      tmpMd.opponent = tmpRef.data()!['nickname'];
      tmpMd.profileImageLink = tmpRef.data()!['profile_image'];
      var checkPost1 = await FirebaseFirestore.instance
          .collection('dm')
          .where('userID1', isEqualTo: friendsIdList[i])
          .where('userID2', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .get();
      var checkPost2 = await FirebaseFirestore.instance
          .collection('dm')
          .where('userID2', isEqualTo: friendsIdList[i])
          .where('userID1', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .get();
      if (checkPost1.docs.isNotEmpty) {
        tmpMd.ref = checkPost1.docs[0].reference;
      }
      if (checkPost2.docs.isNotEmpty) {
        tmpMd.ref = checkPost2.docs[0].reference;
      }
      friendsList.add(tmpMd);
    }
    if(mounted) {
      setState(() {
      friendsList = friendsList;
    });
    }
  }

  void getDmInfo() async {
    var checkPost1 = await FirebaseFirestore.instance
        .collection('dm')
        .where('userID1', isEqualTo: curUid)
        .get();
    var checkPost2 = await FirebaseFirestore.instance
        .collection('dm')
        .where('userID2', isEqualTo: curUid)
        .get();
    if (checkPost1.docs.isNotEmpty) {
      for (int i = 0; i < checkPost1.size; i++) {
        dmListModel tmpModel = new dmListModel();
        if (checkPost1.docs[i]['userID1'] != curUid) {
          var tmpId = checkPost1.docs[i]['userID1'];
          var tmpRef = await FirebaseFirestore.instance
              .collection('user')
              .doc(tmpId)
              .get();
          tmpModel.opponent = tmpRef.data()!['nickname'];
          tmpModel.opponentId = tmpId;
        } else {
          tmpModel.opponent = checkPost1.docs[i]['userID2'];
          var tmpId = checkPost1.docs[i]['userID2'];
          var tmpRef = await FirebaseFirestore.instance
              .collection('user')
              .doc(tmpId)
              .get();
          tmpModel.opponent = tmpRef.data()!['nickname'];
          tmpModel.opponentId = tmpId;
        }
        tmpModel.ref = checkPost1.docs[i].reference;
        var latestDm = await checkPost1.docs[i].reference
            .collection('message')
            .orderBy('date', descending: true)
            .get();
        tmpModel.date = latestDm.docs[0].data()!['date'];
        tmpModel.recentDm = latestDm.docs[0].data()!['text'];
        dmList.add(tmpModel);
      }
    }
    if (checkPost2.docs.isNotEmpty) {
      for (int i = 0; i < checkPost2.size; i++) {
        dmListModel tmpModel = new dmListModel();
        if (checkPost2.docs[i]['userID1'] != curUid) {
          var tmpId = checkPost2.docs[i]['userID1'];
          var tmpRef = await FirebaseFirestore.instance
              .collection('user')
              .doc(tmpId)
              .get();
          tmpModel.opponent = tmpRef.data()!['nickname'];
        } else {
          var tmpId = checkPost2.docs[i]['userID2'];
          var tmpRef = await FirebaseFirestore.instance
              .collection('user')
              .doc(tmpId)
              .get();
          tmpModel.opponent = tmpRef.data()!['nickname'];
        }
        tmpModel.ref = checkPost2.docs[i].reference;
        var latestDm = await checkPost2.docs[i].reference
            .collection('message')
            .orderBy('date', descending: true)
            .get();
        tmpModel.date = latestDm.docs[0].data()!['date'];
        tmpModel.recentDm = latestDm.docs[0].data()!['text'];
        dmList.add(tmpModel);
      }
    }
    if(mounted) {
      setState(() {
      dmList = dmList;
    });
    }
  }

  void removeFriend(String othersUid) async {
    await FirebaseFirestore.instance.collection('user').doc(curUid).update({
      'friends': FieldValue.arrayRemove([othersUid])
    });
  }

  String formatTimestamp(DateTime timestamp) {
    DateTime now = DateTime.now();
    DateFormat formatter = DateFormat('yyyy-MM-dd');
    String strNow = formatter.format(now);
    String strTime = formatter.format(timestamp);
    return strTime;
  }

  void initInfo() {
    dmList.clear();
    friendsList.clear();
    friendsIdList.clear();
    getFriendInfo();
    getDmInfo();
  }

  @override
  void initState() {
    userProvider = Provider.of<UserProvider>(context, listen: false);
    myNickname = userProvider.nickname;
    _tabController = TabController(
      length: 2,
      vsync: this,
    );
    initInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "$myNickname",
          style: const TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        elevation: 1,
      ),
      body: Column(
        children: [
          TabBar(
            controller: _tabController,
            tabs: [
              Container(
                height: 40,
                alignment: Alignment.center,
                child: const Text(
                  '친구',
                  style: TextStyle(color: Colors.black),
                ),
              ),
              Container(
                height: 40,
                alignment: Alignment.center,
                child: const Text(
                  '쪽지함',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ],
          ),
          Expanded(
              child: TabBarView(
            controller: _tabController,
            children: [
              Container(
                child: ListView.builder(
                    itemCount: friendsList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Card(
                        elevation: 0,
                        child: ListTile(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ProfileScreen(
                                          uid: friendsIdList[index],
                                        )));
                          },
                          title: Row(
                            children: [
                              CachedNetworkImage(
                                imageUrl: friendsList[index].profileImageLink!,
                                imageBuilder: (context, imageProvider) =>
                                    Container(
                                  width: 30,
                                  height: 30,
                                  decoration: BoxDecoration(
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Colors.grey,
                                        blurRadius: 1,
                                        spreadRadius: 1,
                                      )
                                    ],
                                    shape: BoxShape.rectangle,
                                    borderRadius: BorderRadius.circular(1),
                                    image: DecorationImage(
                                      image: imageProvider,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.person_rounded),
                              ),
                              Container(
                                margin: EdgeInsets.all(15),
                                child: Text(friendsList[index].opponent!),
                              )
                            ],
                          ),
                          trailing:
                              Row(mainAxisSize: MainAxisSize.min, children: [
                            IconButton(
                              onPressed: () {
                                removeFriend(friendsIdList[index]);
                                setState(() {
                                  initInfo();
                                });
                              },
                              icon: const Icon(Icons.person_remove),
                            ),
                            IconButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => pmWriteScreen(
                                              friendsList[index].ref))).then(
                                      (value) {
                                    setState(() {
                                      initInfo();
                                    });
                                  });
                                },
                                icon: const Icon(Icons.send))
                          ]),
                        ),
                      );
                    }),
              ),
              Container(
                child: ListView.builder(
                    itemCount: dmList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Card(
                        elevation: 0,
                        child: ListTile(
                            onTap: () {
                              Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => postMessage(
                                              dmList[index].ref,
                                              dmList[index].opponent,
                                              dmList[index].opponentId
                                          )))
                                  .then((value) {
                                setState(() {
                                  initInfo();
                                });
                              });
                            },
                            title: Text(
                              dmList[index].recentDm!,
                              style: TextStyle(color: Colors.black),
                            ),
                            leading: Text(
                              dmList[index].opponent!,
                              style: TextStyle(color: Colors.black),
                            ),
                            trailing: Text(
                              formatTimestamp(dmList[index].date!.toDate()),
                              style:
                                  TextStyle(color: Colors.black, fontSize: 10),
                            )),
                      );
                    }),
              ),
            ],
          ))
        ],
      ),
    );
  }
}
