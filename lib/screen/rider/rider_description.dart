import 'package:bobfriend/screen/rider/register_rider.dart';
import 'package:flutter/material.dart';
import 'package:intro_slider/intro_slider.dart';

class RiderDescriptionScreen extends StatefulWidget {
  const RiderDescriptionScreen({Key? key}) : super(key: key);

  @override
  State<RiderDescriptionScreen> createState() => _RiderDescriptionScreenState();
}

class _RiderDescriptionScreenState extends State<RiderDescriptionScreen> {
  List<ContentConfig> listContentConfig = [];

  @override
  void initState() {
    super.initState();

    listContentConfig.add(
      const ContentConfig(
        title: "배달원 등록하기",
        description:
        "학교를 오가는 길에 할 수 있는 생산적인 일!",
        //pathImage: "image/001.png",
        backgroundColor: Colors.green,
      ),
    );
    listContentConfig.add(
      const ContentConfig(
        title: "배달원 고고",
        description:
        "학교에서 들어오는 길에 배달 콜 한번 확인하고 들어가요!",
        //pathImage: "image/002.png",
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return IntroSlider(
      key: UniqueKey(),
      listContentConfig: listContentConfig,
      onDonePress: (){
        Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const RegisterRiderScreen()));
      },
      renderDoneBtn: Text('등록하러 가기'),
      renderNextBtn: Text('다음'),
      renderPrevBtn: Text('이전'),
      isShowSkipBtn: false,
    );
  }
}

