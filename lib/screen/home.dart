import 'package:bobfriend/screen/MyPage.dart';
import 'package:bobfriend/screen/chat_list.dart';
import 'package:bobfriend/widget/bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  Widget build(BuildContext context) {

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
}