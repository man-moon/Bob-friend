import 'package:bobfriend/Model/board.dart';
import 'package:bobfriend/Model/dm.dart';
import 'package:bobfriend/provider/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:eventsource/eventsource.dart';
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
  String curUid=FirebaseAuth.instance.currentUser!.uid;
  String? myNickname='';
  List<dynamic> friendsList = [];
  List<dynamic> friendsIdList = [];
  List<dmListModel> dmList=[];
  void getFriendInfo() async {
    final userRef = await FirebaseFirestore.instance.collection('user').doc(curUid).get();
    setState(() {
      friendsIdList = userRef.data()!['friends'];
    });
    for(var i=0; i<friendsIdList.length;i++){
      var tmpRef = await FirebaseFirestore.instance.collection('user').doc(friendsIdList[i]).get();
      friendsList.add(tmpRef.data()!['nickname']);
    }
    setState(() {
      friendsList=friendsList;
    });
  }
  void getDmInfo() async{
    var dmRef = await FirebaseFirestore.instance.collection('dm').where('userID1',isEqualTo: curUid).get();
    debugPrint(dmRef.size.toString());
    for(int i=0;i<dmRef.size;i++){
      dmListModel tmpModel= new dmListModel();
      if(dmRef.docs[i]['userID1']!=curUid) {
        tmpModel.opponent=dmRef.docs[i]['userID1'];
      }
      else{
        tmpModel.opponent=dmRef.docs[i]['userID2'];
      }
      var latestDm = await dmRef.docs[i].reference.collection('message').orderBy('time',descending: true).get();
      tmpModel.date = latestDm.docs[0].data()!['time'];
      tmpModel.recentDm = latestDm.docs[0].data()!['text'];
      dmList.add(tmpModel);
    }
    setState(() {
      dmList = dmList;
    });
    //debugPrint(dmRef.docs[0]['userID2']);
    //debugPrint(dmRef.docs[1].data()!['sender']);
  }
  void removeFriend(String othersUid) async {
    await FirebaseFirestore.instance.collection('user').doc(curUid).update({
      'friends': FieldValue.arrayRemove([othersUid])
    });
  }
  String formatTimestamp(DateTime timestamp){
    DateTime now = DateTime.now();
    DateFormat formatter = DateFormat('yyyy-MM-dd');
    String strNow = formatter.format(now);
    String strTime = formatter.format(timestamp);
    return strTime;
  }
  @override
  void initState() {
    userProvider = Provider.of<UserProvider>(context, listen: false);
    myNickname = userProvider.nickname;
    getFriendInfo();
    _tabController = TabController(
      length: 2,
      vsync: this,
    );
    getDmInfo();
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
        elevation: 0.0,
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
                  '쪽지',
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
                        child: ListTile(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ProfileScreen(
                                      uid: friendsIdList[index],
                                    )));
                          },
                          title: Text(friendsList[index]),
                          trailing:
                          Row(mainAxisSize: MainAxisSize.min, children: [
                            IconButton(
                              onPressed: () {
                                removeFriend(friendsIdList[index]);
                                setState(() {
                                  getFriendInfo();
                                  friendsList.removeAt(index);
                                  friendsIdList.removeAt(index);
                                  friendsList.length;
                                });
                              },
                              icon: const Icon(Icons.person_remove),
                            ),
                            IconButton(
                                onPressed: () {},
                                icon: const Icon(Icons.message_sharp))
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
                        child: ListTile(
                          onTap: () {
                          },
                            title: Text(dmList[index].recentDm!,style: TextStyle(color: Colors.black),),
                            leading: Text(dmList[index].opponent!,style: TextStyle(color: Colors.black),),
                            trailing: Text(formatTimestamp(dmList[index].date!.toDate()),style: TextStyle(color: Colors.black,fontSize: 10),)
                        ),
                      );
                    }),
              ),
            ],
          ))
        ],
      ),
    );

    //EventSource eventSource = EventSource.connect('http://192.168.136.150:8080/test');

    // return StreamBuilder(
    //   stream: eventSource.onMessage,
    //   builder: (BuildContext context, AsyncSnapshot<Event> snapshot) {
    //     debugPrint(snapshot.hasData.toString());
    //     return
    //       ListView.builder(
    //         padding: const EdgeInsets.fromLTRB(0, 0, 0, 12),
    //         reverse: true,
    //         itemCount: 1,
    //         itemBuilder: (context, index) {
    //           return Text('hello');
    //         },
    //       );
    //   },
    // );
  }
}
