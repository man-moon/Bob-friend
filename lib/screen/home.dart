import 'package:bobfriend/screen/profile/profile.dart';
import 'package:bobfriend/screen/chat/chat_list.dart';
import 'package:bobfriend/widget/bottom_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:bobfriend/screen/board/board.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';

import '../provider/user.dart';


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

    return DefaultTabController(
        length: 4,
        child: Scaffold(
          body: TabBarView(
            physics: const NeverScrollableScrollPhysics(),
            children: [
              //Chat, Community, Friends, My Page로 대체
              const ChatListScreen(),
              BoardListScreen(),
              const Center(child: Text('Friends'),),
              //Profile
              const ProfileScreen(),
            ],
          ),
          bottomNavigationBar: const BottomBar(),
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