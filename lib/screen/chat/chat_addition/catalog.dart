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
      appBar: AppBar(
        title: const Text('장바구니'),
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

            separatorBuilder: (context, index) => const Divider(color: Colors.black,),
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

              return Card(
                elevation: 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //닉네임 출력
                    //카운트가 > 0 인 메뉴이름과 카운트 x 가격 출력
                    //총합 출력
                    Text(
                      catalogRef[index].id == 'allCatalogs' ? '전체 장바구니' : '${catalogRef[index].id}님의 장바구니',
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),

                    SizedBox(height: 20,),

                    for(int i = 0; i < menuListForPrint.length; i++)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [

                        Text('${menuListForPrint[i]}'),
                        Text('${priceListForPrint[i].toString()}원'),
                        Text('${countListForPrint[i].toString()}개\n'),
                      ],),
                    SizedBox(height: 20,),
                    Text('총합계   ${myTotalPrice.toString()}원'),

                  ],
                )
              );
            },
          );
        },
      ),
    );
  }
}
