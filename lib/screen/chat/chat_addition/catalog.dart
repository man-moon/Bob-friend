import 'package:bobfriend/config/chat_config.dart';
import 'package:bobfriend/provider/chat.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CatalogScreen extends StatefulWidget {
  const CatalogScreen({Key? key}) : super(key: key);

  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  late ChatProvider chatProvider;

  @override
  Widget build(BuildContext context) {
    chatProvider = Provider.of<ChatProvider>(context, listen: false);
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: buildCatalogFAB(context),
      appBar: AppBar(
        centerTitle: true,
        title: const Text('장바구니'),
        elevation: 0,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('chats').doc(chatProvider.docId).collection('catalog').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting){
            return const Center(
              child: CircularProgressIndicator(color: Colors.black,),
            );
          }

          var catalogRef = snapshot.data!.docs;

          return ListView.separated(

            separatorBuilder: (context, index) => const SizedBox(height: 10,),
            itemCount: catalogRef.length,
            itemBuilder: (BuildContext context, int index) {

              List<dynamic> countList = catalogRef[index]['count'];

              List<String> menuListForPrint = [];
              List<int> priceListForPrint = [];
              List<int> countListForPrint = [];
              int myTotalPrice = 0;
              for(int i = 0; i < countList.length; i++){
                if(countList[i] == 0) continue;
                menuListForPrint.add(catalogRef[index]['menu'][i]);
                priceListForPrint.add(catalogRef[index]['price'][i]);
                countListForPrint.add(catalogRef[index]['count'][i]);
                myTotalPrice += (catalogRef[index]['price'][i] * catalogRef[index]['count'][i]) as int;
              }

              return Column(
                children: [
                  Card(
                  elevation: 3,
                  child: Container(
                    padding: const EdgeInsets.all(13),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //닉네임 출력
                        //카운트가 > 0 인 메뉴이름과 카운트 x 가격 출력
                        //총합 출력
                        Text(
                          catalogRef[index].id == 'allCatalogs' ? '전체 장바구니' : '${catalogRef[index].id}님의 장바구니',
                          style: const TextStyle(
                            fontSize: 25,
                            color: Colors.grey
                          ),
                        ),

                        SizedBox(height: 30,),

                        for(int i = 0; i < menuListForPrint.length; i++)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Row(
                                children: [
                                  Text('${menuListForPrint[i]}(${priceListForPrint[i]}원)       ', style: TextStyle(fontSize: 18),),
                                  Text('${countListForPrint[i]}개', style: TextStyle(fontSize: 16, color: Colors.grey),),
                                ],
                              ),
                              const SizedBox(height: 10,),
                              Text('${priceListForPrint[i] * countListForPrint[i]}원', style: TextStyle(fontSize: 16, color: Colors.grey),),
                              const SizedBox(height: 20,),
                            ],),
                        const Divider(),
                        SizedBox(height: 10,),

                        Row(
                          children: [
                            Text('총합   ', style: TextStyle(color: Colors.grey, fontSize: 18),),
                            Text('${myTotalPrice.toString()}원', style: TextStyle(fontSize: 18),)

                          ],
                        ),
                        SizedBox(height: 10,),


                      ],
                    ),
                  )
                ),
                  if(index == catalogRef.length - 1)
                  const SizedBox(height: 80,)
                ]
              );
            },
          );
        },
      ),
    );

  }

  Widget buildCatalogFAB(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        shape: BoxShape.rectangle,
      ),
      width: MediaQuery.of(context).size.width * 0.9,
      child: FloatingActionButton.extended(

        backgroundColor: Colors.greenAccent,
        onPressed: () {
          var ref = FirebaseFirestore.instance
              .collection('chats')
              .doc(chatProvider.docId);

          ref.update({'state': ChatState.selectMeetingPlace.toString()});
          Navigator.of(context).pop();
        },
        isExtended: true,
        elevation: 3,
        label: const Text('주문하기', style: TextStyle(fontSize: 18),),
      ),
    );
  }

}
