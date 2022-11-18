import 'package:bobfriend/screen/chat/chat_addition/additional_chat.dart';
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
import 'friend/friend.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  Widget build(BuildContext context) {
    debugPrint('home screen');

    initializeDateFormatting(Localizations.localeOf(context).languageCode);

    return const DefaultTabController(
        length: 4,
        child: Scaffold(
          body: TabBarView(
            physics: NeverScrollableScrollPhysics(),
            children: [
              //Chat, Community, Friends, My Page로 대체
              ChatListScreen(),
              BoardListScreen(),
              FriendScreen(),
              ProfileScreen(),
            ],
          ),
          bottomNavigationBar: BottomBar(),
        ),
    );


  }
}