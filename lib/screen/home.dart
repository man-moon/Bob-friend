import 'package:bobfriend/screen/mypage.dart';
import 'package:bobfriend/screen/chat_list.dart';
import 'package:bobfriend/widget/bottom_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';

import '../dto/user.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  Widget build(BuildContext context) {

    initUserInfo();
    initializeDateFormatting(Localizations.localeOf(context).languageCode);

    return const DefaultTabController(
        length: 4,
        child: Scaffold(
          body: TabBarView(
            physics: NeverScrollableScrollPhysics(),
            children: [
              //Chat, Community, Friends, My Page로 대체
              ChatListScreen(),
              Center(child: Text('Community'),),
              Center(child: Text('Friends'),),
              //MyPage
              Center(
                child: MyPageScreen(),
              )
            ],
          ),
          bottomNavigationBar: BottomBar(),
        ),
    );
  }
  void initUserInfo() async {
    UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);
    final userInfo = await FirebaseFirestore.instance.collection('user').
    doc(FirebaseAuth.instance.currentUser!.uid).get();

    userProvider.nickname = userInfo.data()!['nickname'];
    userProvider.email = userInfo.data()!['email'];
    userProvider.profileImageLink = userInfo.data()!['profile_image'];
    userProvider.univ = userInfo.data()!['univ'];
  }
}