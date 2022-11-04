import 'package:bobfriend/Model/board.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:eventsource/eventsource.dart';

class FriendScreen extends StatefulWidget {
  const FriendScreen({Key? key}) : super(key: key);

  @override
  State<FriendScreen> createState() => _FriendScreenState();
}

class _FriendScreenState extends State<FriendScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  String curId = FirebaseAuth.instance.currentUser!.uid;
  List<dynamic> friendsList=[];
  void getUserInfo() async {
    final ref = await FirebaseFirestore.instance.collection('user').doc(curId).get();
    setState(() {
      friendsList = ref.data()!['friends'];
    });
  }
  void removeFriend(String othersNickname) async {
      await FirebaseFirestore.instance.collection('user').doc(curId)
          .update({'friends':FieldValue.arrayRemove([othersNickname])});

  }
  @override
  void initState(){
    getUserInfo();
    _tabController = TabController(
        length: 2, vsync: this,);
    super.initState();
  }
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("친구", style: TextStyle(color: Colors.black),),
        centerTitle: true,
        elevation: 0.0,
      ),
      body: Column(
        children:[
          Container(
          ),
      TabBar(
          controller: _tabController,
          tabs: [
            Container(
              height: 40,
              alignment: Alignment.center,
              child: const Text(
                '팔로워', style: TextStyle(color: Colors.black),
              ),
            ),
            Container(
              height: 40,
              alignment: Alignment.center,
              child: const Text(
                '팔로잉', style: TextStyle(color: Colors.black),
              ),
            ),
          ],
      ),
          Expanded(child: TabBarView(
            controller: _tabController,
            children: [
              Container(
                child: Text(
                  '팔로워 창', style: TextStyle(color: Colors.black),
                ),
              ),
        Container(
          child: ListView.builder(
            itemCount: friendsList.length,
              itemBuilder: (BuildContext context,int index){
              return Card(
                child: ListTile(
                  title: Text(friendsList[index]),
                  trailing: OutlinedButton(
                    onPressed: (){
                      removeFriend(friendsList[index]);
                      setState(() {
                        getUserInfo();
                      });
                    },
                    child: Text("언팔로우",style: TextStyle(color: Colors.black),),
                  ),
                ),
              );
              }),
        )
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
