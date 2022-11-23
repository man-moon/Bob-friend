import 'package:bobfriend/screen/chat/chat_addition/restaurant_detail.dart';
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
import '../../../config/msg_config.dart';
import '../../../config/restaurant_fireservice.dart';
import '../../../provider/user.dart';
import 'package:bobfriend/Model/restaurant.dart';

class AdditionalChatScreen extends StatefulWidget {
  ///type can be [confirm, share]
  const AdditionalChatScreen({super.key, required this.type});
  final String type;

  @override
  AdditionalChatScreenState createState() => AdditionalChatScreenState();
}

class AdditionalChatScreenState extends State<AdditionalChatScreen> {
  late final ChatProvider chatProvider;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        automaticallyImplyLeading: false,
        // leading: IconButton(
        //   onPressed: () {
        //     Navigator.pop(context);
        //   },
        //   icon: const Icon(Icons.close),
        // ),
        title: const TextField(
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: "음식점 및 메뉴 검색",
          ),
        ),
        actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.search))],
      ),
      body: FutureBuilder<List<RestaurantModel>>(
        future: RestaurantFireService().getDocs(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<RestaurantModel> datas = snapshot.data!;
            return ListView.builder(
                itemCount: datas.length,
                itemBuilder: (BuildContext context, int index) {
                  RestaurantModel data = datas[index];

                  if(widget.type == 'confirm'){
                    return Card(
                      elevation: 0,
                      child: ListTile(
                        title: Text("${data.name}"),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) =>
                                  RestaurantDetailScreen(name: data.name.toString(), type: 'noShare')));
                        },
                        trailing: ElevatedButton(
                          onPressed: () {
                            chatProvider = Provider.of<ChatProvider>(context, listen: false);
                            FirebaseFirestore.instance.collection('chats').doc(chatProvider.docId)
                                .collection('chat').doc('selectMenu').set({
                              'text': '${data.name} 가게로 확정되었습니다!\n각자 먹고싶은 메뉴를 골라주세요!\n',
                              'time': Timestamp.now(),
                              'userId': 'admin',
                              'nickname': '밥친구',
                              'type': MessageType.action.toString(),
                              'action': MessageAction.selectMenu.toString(),
                              'restaurant': data.name,
                            });

                            chatProvider.restaurantName = data.name;

                            List<int> counts = [];
                            for(int i = 0; i < data.menu!.length; i++){
                              counts.add(0);
                            }

                            FirebaseFirestore.instance.collection('chats').doc(chatProvider.docId)
                                .collection('catalog').doc('allCatalogs').set({
                                  'menu': data.menu,
                                  'price': data.price,
                                  'count': counts,
                                });

                            Navigator.of(context).pop();
                          },
                          child: const Text(
                            '확정',
                            style: TextStyle(color: Colors.black),
                          ),

                        ),
                      ),
                    );
                  }

                  else {
                    return Card(
                      elevation: 1,
                      child: ListTile(
                        title: Text("${data.name}"),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) =>
                                  RestaurantDetailScreen(name: data.name.toString(), type: 'share')));
                        },
                      ),
                    );
                  }

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

