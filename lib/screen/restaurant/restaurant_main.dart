import 'package:bobfriend/provider/owner.dart';
import 'package:bobfriend/screen/restaurant/menu_management.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:switcher_button/switcher_button.dart';

class RestaurantMainScreen extends StatefulWidget {
  const RestaurantMainScreen({Key? key}) : super(key: key);

  @override
  State<RestaurantMainScreen> createState() => _RestaurantMainScreenState();
}

class _RestaurantMainScreenState extends State<RestaurantMainScreen> {

  late OwnerProvider ownerProvider;

  @override
  Widget build(BuildContext context) {

    ownerProvider = Provider.of<OwnerProvider>(context, listen: true);

    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        title: const Text('내 가게'),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          buildRestaurantInfo(context),
          buildManagementMenu(context),

        ],
      ),
    );
  }

  Widget buildRestaurantInfo(BuildContext context) {
    return Card(

      margin: const EdgeInsets.only(top: 5, left: 5, right: 5),
      elevation: 0,
      child: Container(
        padding: const EdgeInsets.all(13),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          const Text('가게 정보', style: TextStyle(fontSize: 20, color: Colors.grey),),
          const SizedBox(height: 5,),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              //가게 썸네일
              const Icon(Icons.restaurant_outlined, size: 100,),

              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  //가게 이름, 주소, 전화번호
                  children: [
                    Row(
                      children: [
                      const Text('가게이름  ', style: TextStyle(color: Colors.grey, fontSize: 16),),
                      Text(ownerProvider.name, style: const TextStyle(color: Colors.black, fontSize: 16),)
                    ],),

                    const SizedBox(height: 5,),
                    Row(children: [
                      const Text('전화번호  ', style: TextStyle(color: Colors.grey, fontSize: 16),),
                      Text(ownerProvider.callNumber, style: const TextStyle(color: Colors.black, fontSize: 16),)
                    ],),

                    const SizedBox(height: 5,),
                    Row(children: [
                      const Text('주소  ', style: TextStyle(color: Colors.grey, fontSize: 16),),
                      Text(ownerProvider.address, style: const TextStyle(color: Colors.black, fontSize: 16),)
                    ],),

                    const SizedBox(height: 5,),
                    Row(children: [
                      const Text('현재상태  ', style: TextStyle(color: Colors.grey, fontSize: 16),),
                      Text(ownerProvider.isOpen ? '영업중' : '영업 종료', style: const TextStyle(color: Colors.black, fontSize: 16),)
                    ],),
                  ],
                ),
              )



            ],
          ),]
        ),
      ),
    );
  }

  Widget buildManagementMenu(BuildContext context) {
    return Card(
        margin: const EdgeInsets.only(top: 5, left: 5, right: 5),
        elevation: 0,
        child: Container(
          padding: const EdgeInsets.all(13),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('가게 관리', style: TextStyle(fontSize: 20, color: Colors.grey),),
              const SizedBox(height: 10,),

              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextButton(
                    style: const ButtonStyle(
                        alignment: Alignment.centerLeft
                    ),
                    onPressed: (){

                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('오픈/마감', style: TextStyle(color: Colors.black, fontSize: 18,),),
                        SwitcherButton(
                          value: ownerProvider.isOpen,
                          onColor: Colors.greenAccent,
                          offColor: Colors.black12,
                          onChange: (value) {
                            print(value);
                            ownerProvider.isOpen = value;
                          },
                        ),
                      ],
                    )
                  ),
                  const Divider(height: 1,),

                  TextButton(
                    style: const ButtonStyle(
                      alignment: Alignment.centerLeft
                    ),
                    onPressed: (){
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const MenuManagementScreen()));
                    },
                    child: const Text('메뉴 관리', style: TextStyle(color: Colors.black, fontSize: 18,),),
                  ),
                  const Divider(height: 1,),

                  TextButton(
                    style: const ButtonStyle(
                        alignment: Alignment.centerLeft
                    ),
                    onPressed: (){
                      debugPrint('tapped');
                    },
                    child: const Text('기본정보 수정', style: TextStyle(color: Colors.black, fontSize: 18),),
                  ),
                  const Divider(height: 1,),

                  TextButton(
                    style: const ButtonStyle(
                        alignment: Alignment.centerLeft
                    ),
                    onPressed: (){
                      debugPrint('tapped');
                    },
                    child: const Text('주문 내역', style: TextStyle(color: Colors.black, fontSize: 18),),
                  ),
                  const Divider(height: 1,),

                  TextButton(
                    style: const ButtonStyle(
                        alignment: Alignment.centerLeft
                    ),
                    onPressed: (){
                      debugPrint('tapped');
                    },
                    child: const Text('후기 관리', style: TextStyle(color: Colors.black, fontSize: 18),),
                  ),
                  const Divider(height: 1,),

                  TextButton(
                    style: const ButtonStyle(
                        alignment: Alignment.centerLeft
                    ),
                    onPressed: (){
                      debugPrint('tapped');
                    },
                    child: const Text('정산', style: TextStyle(color: Colors.black, fontSize: 18),),
                  ),
                ],
              ),
            ],
          ),
        ),
    );
  }

}
