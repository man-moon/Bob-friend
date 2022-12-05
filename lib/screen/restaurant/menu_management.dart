import 'package:bobfriend/provider/owner.dart';
import 'package:bobfriend/screen/restaurant/menu_creation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MenuManagementScreen extends StatefulWidget {
  const MenuManagementScreen({Key? key}) : super(key: key);

  @override
  State<MenuManagementScreen> createState() => _MenuManagementScreenState();
}

class _MenuManagementScreenState extends State<MenuManagementScreen> {

  late OwnerProvider ownerProvider;

  @override
  Widget build(BuildContext context) {

    ownerProvider = Provider.of<OwnerProvider>(context, listen: true);

    return Scaffold(
      appBar: AppBar(
        title: const Text('메뉴 관리'),
        centerTitle: true,
        elevation: 0,
      ),
      body: ListView(
        children: [
          for(int i = 0; i < ownerProvider.menu.length; i++)
          buildMenu(context, i)

        ],
      ),
      floatingActionButton: buildAddMenu(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
  Widget buildMenu(BuildContext context, int idx) {
    return Card(
      margin: const EdgeInsets.only(top: 5, left: 5, right: 5),
      elevation: 0,
      child: Container(
        padding: const EdgeInsets.all(13),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  //가게 썸네일
                  const Icon(Icons.food_bank, size: 100,),

                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,

                      //가게 이름, 주소, 전화번호
                      children: [
                        Row(
                          children: [
                            const Text('메뉴이름  ', style: TextStyle(color: Colors.grey, fontSize: 16),),
                            Text(ownerProvider.menu[idx].name, style: const TextStyle(color: Colors.black, fontSize: 16),)
                          ],),

                        const SizedBox(height: 10,),
                        Row(
                          children: [
                            const Text('가격  ', style: TextStyle(color: Colors.grey, fontSize: 16),),
                            Text(ownerProvider.menu[idx].price.toString(), style: const TextStyle(color: Colors.black, fontSize: 16),)
                          ],
                        ),

                        const SizedBox(height: 10,),
                        Row(
                          children: [
                            const Text('주문가능여부  ', style: TextStyle(color: Colors.grey, fontSize: 16),),
                            Text(ownerProvider.menu[idx].isAvailable ? '가능' : '불가능', style: const TextStyle(color: Colors.black, fontSize: 16),)
                          ],
                        ),

                        const SizedBox(height: 10,),
                        const Text(
                          '수정하기',
                          style: TextStyle(color: Colors.redAccent,decoration: TextDecoration.underline),
                        ),
                      ],
                    ),
                  )



                ],
              ),]
        ),
      ),
    );
  }

  Widget buildAddMenu(BuildContext context) {
    return FloatingActionButton(
      elevation: 3,
      heroTag: 'create menu',
      onPressed: () {
        Navigator.push(
            context,
            MaterialPageRoute(builder: (context){
              return const MenuCreationScreen();
            })
        );
      },
      backgroundColor: Colors.greenAccent,
      child: const Icon(Icons.add),
    );
  }

}

