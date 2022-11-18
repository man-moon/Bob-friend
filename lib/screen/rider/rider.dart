import 'package:bobfriend/provider/user.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'rider_description.dart';
import 'matching.dart';

class RiderScreen extends StatefulWidget {
  const RiderScreen({Key? key}) : super(key: key);

  @override
  State<RiderScreen> createState() => _RiderScreenState();
}

/// 배달라이더 등록이 되어있는지 확인
/// #등록이 되어있는 경우
///   배달지 리스트(현재 배달기사를 찾고있는 채팅방) 보여줌
///
/// #등록이 안되어있는 경우
///   배달기사 설명과 함께 등록 페이지로 유도하는 스크린
class _RiderScreenState extends State<RiderScreen> {
  late UserProvider userProvider;


  @override
  Widget build(BuildContext context) {
    userProvider = Provider.of<UserProvider>(context, listen: true);
    return userProvider.isRider == null ?
      const CircularProgressIndicator() : (userProvider.isRider == true ? MatchingScreen() : RiderDescriptionScreen());
  }
}
