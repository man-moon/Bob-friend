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
import '../../config/msg_config.dart';
import '../../provider/user.dart';
import 'package:bobfriend/provider/restaurant.dart';

class FireService {
  List<RestaurantModel> list = [];

  Future<List<RestaurantModel>> getDocs() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('food').get();
    for (int i = 0; i < querySnapshot.docs.length; i++) {
      var Middle_datainfo =
          querySnapshot.docs[i].data() as Map<String, dynamic>;
      String name = '';
      List<dynamic> menu = [];
      List<dynamic> price = [];
      name = Middle_datainfo['name'];
      menu.addAll(List.from(Middle_datainfo['menu']));
      price.addAll(List.from(Middle_datainfo['price']));
      RestaurantModel r = RestaurantModel(name: name, menu: menu, price: price);
      list.add(r);
    }
    return list;
  }
}

class AdditionalChatScreen extends StatefulWidget {
  const AdditionalChatScreen({super.key});

  @override
  AdditionalChatScreenState createState() => AdditionalChatScreenState();
}

class AdditionalChatScreenState extends State<AdditionalChatScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.close),
        ),
        title: const TextField(
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: "음식점 및 메뉴 검색",
          ),
        ),
        actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.search))],
      ),
      body: FutureBuilder<List<RestaurantModel>>(
        future: FireService().getDocs(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<RestaurantModel> datas = snapshot.data!;
            return ListView.builder(
                itemCount: datas.length,
                itemBuilder: (BuildContext context, int index) {
                  RestaurantModel data = datas[index];
                  return Card(
                    child: ListTile(
                      title: Text("${data.name}"),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  DetailScreen(name: '${data.name}')),
                        );
                      },
                    ),
                  );
                });
          } else {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.black,
              ),
            );
          }
        },
      ),
    );
  }
}

class DetailScreen extends StatelessWidget {
  final String name;
  late final ChatProvider chatProvider;
  late final UserProvider userProvider;

  DetailScreen({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    chatProvider = Provider.of<ChatProvider>(context, listen: false);
    userProvider = Provider.of<UserProvider>(context, listen: false);
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.close),
          ),
          title: Text('$name'),
          actions: [
            TextButton(
                onPressed: () {
                  FirebaseFirestore.instance.collection('chats').doc(chatProvider.docId).collection('chat').doc().set({
                  'text': '이 가게 어때요?\n"$name"',
                  'time': Timestamp.now(),
                  'userId': FirebaseAuth.instance.currentUser!.uid,
                  'nickname': userProvider.nickname,
                  'type': MessageType.action.toString(),
                  'action': MessageAction.share.toString(),
                  'restaurant': name,
                  });
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
                child: const Text(
                  '공유하기',
                  style: TextStyle(color: Colors.black),
                )),
          ],
        ),
        body: FutureBuilder<List<RestaurantModel>>(
            future: FireService().getDocs(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<RestaurantModel> datas = snapshot.data!;
                for (int i = 0; i < datas.length; i++) {
                  if (datas[i].name == name) {
                    return ListView.separated(
                        itemCount: 5,
                        itemBuilder: (BuildContext ctx, int idx) {
                          return Card(
                              child: ListTile(
                            title: Text("${datas[i].menu?[idx]}"),
                            trailing: Text("${datas[i].price?[idx]}"),
                          ));
                        },
                        separatorBuilder: (BuildContext ctx, int idx) {
                          return Divider();
                        });
                  }
                }
              }
              return Container(
                width: 0,
                height: 0,
              );
            }

            ));
  }
}

/*
    ListView.separated(
    itemCount: 5,
    itemBuilder: (BuildContext ctx, int idx) {
    return Card(
    child: ListTile(
    title: Text("${restaurantModel.menu?[idx]}"),
    trailing: Text("${restaurantModel.price?[idx]}"),
    )
    );
    },
    separatorBuilder: (BuildContext ctx, int idx) {
    return Divider();
    },
    ),
    );*/
