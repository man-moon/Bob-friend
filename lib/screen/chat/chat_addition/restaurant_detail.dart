import 'package:bobfriend/provider/my_catalog.dart';
import 'package:bobfriend/screen/chat/chat_addition/catalog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../../config/msg_config.dart';
import '../../../config/restaurant_fireservice.dart';
import '../../../provider/chat.dart';
import '../../../Model/restaurant.dart';
import '../../../provider/user.dart';

class RestaurantDetailScreen extends StatelessWidget {
  final String name;

  /// types can be: [share, noShare, addMenu]
  final String type;

  late ChatProvider chatProvider;
  late UserProvider userProvider;
  late MyCatalogProvider myCatalogProvider;


  RestaurantDetailScreen({super.key, required this.name, required this.type});

  @override
  Widget build(BuildContext context) {
    chatProvider = Provider.of<ChatProvider>(context, listen: false);
    userProvider = Provider.of<UserProvider>(context, listen: false);
    myCatalogProvider = Provider.of<MyCatalogProvider>(context, listen: true);

    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.close),
          ),
          title: Text(name),
          actions: [
            if(type == 'share')
              TextButton(
                  onPressed: () {
                    shareRestaurant();
                    Navigator.of(context).pop();
                    if(type == 'share'){
                      Navigator.of(context).pop();
                    }
                  },
                  child: const Text(
                    '공유하기',
                    style: TextStyle(color: Colors.black),
                  )
              ),

            if(type == 'addMenu')
              IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const CatalogScreen()));
                  },
                  icon: const Icon(Icons.shopping_cart))
          ],
        ),
        body:
          FutureBuilder<List<RestaurantModel>>(
            future: RestaurantFireService().getDocs(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<RestaurantModel> datas = snapshot.data!;
              for (int i = 0; i < datas.length; i++) {
                  if (datas[i].name == name) {
                    return ListView.separated(
                        itemCount: datas[i].menu!.length,
                        itemBuilder: (BuildContext context, int idx) {
                          if(type == 'addMenu'){
                            if(myCatalogProvider.menu.length < datas[i].menu!.length){
                              myCatalogProvider.addMenu(datas[i].menu?[idx]);
                              myCatalogProvider.setCount();
                              myCatalogProvider.setPrice(datas[i].price![idx]);
                            }

                            return Card(
                                child: ListTile(
                                  title: Text("${datas[i].menu?[idx]}"),
                                  subtitle: Text("${datas[i].price?[idx]}원"),
                                  trailing: SizedBox(
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(
                                          onPressed: () {
                                            if(myCatalogProvider.count[idx] != 0){
                                              myCatalogProvider.subtractCount(idx);
                                              myCatalogProvider.subTotalPrice(myCatalogProvider.price[idx]);
                                            }
                                          },
                                          icon: const Icon(Icons.remove),
                                          color:
                                          (idx + 1 <= myCatalogProvider.count.length) ?
                                          (myCatalogProvider.count[idx] == 0 ? Colors.grey : Colors.black) : Colors.grey,
                                          iconSize: 17,
                                        ),

                                        Text(myCatalogProvider.count[idx].toString()),

                                        IconButton(
                                          onPressed: () {
                                            myCatalogProvider.addCount(idx);
                                            myCatalogProvider.addTotalPrice(myCatalogProvider.price[idx]);
                                          },
                                          icon: const Icon(Icons.add),
                                          color: Colors.black,
                                          iconSize: 17,
                                        ),
                                      ],
                                    ),
                                  )
                                ));
                          }
                          else{
                            return Card(
                                child: ListTile(
                                  title: Text("${datas[i].menu?[idx]}"),
                                  subtitle: Text("${datas[i].price?[idx]}원"),
                                ));
                          }


                        },
                        separatorBuilder: (BuildContext ctx, int idx) {
                          return const Divider();
                        });
                  }
                }

              }
              return const SizedBox(
                width: 0,
                height: 0,
              );
            }
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton:
      (type == 'addMenu') ?
      Container(
        decoration: const BoxDecoration(
          shape: BoxShape.rectangle,
        ),
        width: MediaQuery.of(context).size.width * 0.9,
        child: FloatingActionButton.extended(
          onPressed: () {
            var ref = FirebaseFirestore.instance.collection('chats')
                .doc(chatProvider.docId).collection('catalog');

            ref.doc(userProvider.nickname.toString())
                .set({
                    'menu': myCatalogProvider.menu,
                    'price': myCatalogProvider.price,
                    'count': myCatalogProvider.count
                  });
            debugPrint(myCatalogProvider.count.toString());

            late List<dynamic> count;

            ref.doc('allCatalogs').get().then((value) {
              count = value.data()!['count'];
            }).then((_) {
              for(int i = 0; i < count.length; i++){
                debugPrint('forloop');
                count[i] += myCatalogProvider.count[i];
              }
            }).then((_){
              ref.doc('allCatalogs').update({
                'count': count
              });
            }).then((_) => myCatalogProvider.softReset());

            Navigator.of(context).pop();
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CatalogScreen())
            );
          },

          icon: const Icon(Icons.add_shopping_cart_rounded, color: Colors.white,),
          backgroundColor: Colors.greenAccent,
          isExtended: true,
          elevation: 30,
          label: Text('${myCatalogProvider.totalPrice}원 장바구니에 담기', style: TextStyle(fontSize: 17),),
        ),
      ) : Container(),
    );
  }

  void shareRestaurant() {
    FirebaseFirestore.instance.collection('chats').doc(chatProvider.docId).collection('chat').doc().set({
      'text': '이 가게 어때요?\n"$name"',
      'time': Timestamp.now(),
      'userId': FirebaseAuth.instance.currentUser!.uid,
      'nickname': userProvider.nickname,
      'type': MessageType.action.toString(),
      'action': MessageAction.share.toString(),
      'restaurant': name,
    });
  }
}
