import 'package:bobfriend/screen/newlogin/new_login_signup.dart';
import 'package:bobfriend/validator/validator.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:bobfriend/my_app.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import '../../provider/user.dart';
import '../login/login_signup.dart';

import 'package:bobfriend/provider/user.dart';

/// isMe == true
/// + 프로필 변경 기능
/// + 닉네임 변경 기능
/// + 자기 이메일 표시
/// - 팔로우 버튼 비활성화
///
/// isMe == false
/// - 프로필 변경 기능
/// - 닉네임 변경 기능
/// - 타인 이메일 표시
/// + 팔로우 버튼 활성화
///
/// 공통 기능
/// + 프로필 이미지
/// + 닉네임
/// + 온도
/// + 작성한 후기 게시글
/// + 주문수
/// + 좋아하는 음식
/// +
///
/// 친구페이지
/// 친구와 함께 먹은 횟수

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({this.uid, Key? key}) : super(key: key);
  final String? uid;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late final bool isMe;
  String othersNickname = '';
  double othersTemperature = 0;
  String othersProfileImageUrl =
      'https://firebasestorage.googleapis.com/v0/b/bobfriend-7ffd5.appspot.com/o/profile_image%2Fbasic.jpeg?alt=media&token=b4018fb6-05ac-4e34-babd-04ee02ee2ce5';
  String othersUniv = '';
  late bool isFriend=false;
  final _authentication = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  late dynamic _nicknameController;
  void follow() {}

  void getUserInfo() async {
    final ref = await FirebaseFirestore.instance
        .collection('user')
        .doc(widget.uid)
        .get();
    setState(() {
      othersNickname = ref.data()!['nickname'];
      othersTemperature = ref.data()!['temperature'];
      othersProfileImageUrl = ref.data()!['profile_image'];
      othersUniv = ref.data()!['univ'] == 'ajou' ? '아주대학교' : '인하대학교';
    });
  }

  @override
  void initState() {
    friendCheck();
    if (!checkIsMe()) {
      getUserInfo();
    }
    super.initState();
  }

  @override
  void dispose() {
    _nicknameController.dispose();
    super.dispose();
  }

  bool checkIsMe() {
    setState(() {
      isMe = widget.uid == null ? true : false;
    });
    return isMe;
  }

  void updateProfileImage(XFile? pickedImage) async {
    File image = File(pickedImage!.path);
    final ref = FirebaseStorage.instance
        .ref()
        .child('profile_image')
        .child('${FirebaseAuth.instance.currentUser!.uid}.jpg');
    try {
      await ref.putFile(image);

      String profileUrl = await ref.getDownloadURL();
      await FirebaseFirestore.instance
          .collection('user')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({'profile_image': profileUrl}).whenComplete(
              () => applyProfileImage(profileUrl));
    } catch (e) {
      debugPrint('이미지 업로드 중, 오류가 발생하였습니다');
    }
  }

  void pickImage() async {
    final imagePicker = ImagePicker();
    final pickedImage = await imagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
    );
    updateProfileImage(pickedImage);
  }

  void showImagePicker(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            title: Column(
              children: const <Widget>[
                Text('프로필 변경'),
              ],
            ),
            //
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const <Widget>[
                Text(
                  '프로필을 변경하기 위해 갤러리에서 사진을 선택합니다',
                ),
              ],
            ),
            actions: <Widget>[
              TextButton(
                child: const Text(
                  '취소',
                  style: TextStyle(color: Colors.black),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              TextButton(
                child: const Text(
                  '사진 선택',
                  style: TextStyle(color: Colors.black),
                ),
                onPressed: () {
                  pickImage();
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }

  void applyProfileImage(String url) {
    context.read<UserProvider>().profileImageLink = url;
  }

  void showChangeNicknamePopup() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            //Dialog Main Title
            title: Column(
              children: const <Widget>[
                Text('닉네임 변경'),
              ],
            ),
            //
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Form(
                  key: _formKey,
                  child: TextFormField(
                    decoration: const InputDecoration(
                      icon: Icon(Icons.abc_rounded),
                      iconColor: Colors.black,
                      labelText: '닉네임',
                    ),
                    autofocus: true,
                    maxLength: 12,
                    validator: nicknameValidator,
                    controller: _nicknameController,
                  ),
                ),
              ],
            ),
            actions: <Widget>[
              TextButton(
                child: const Text(
                  '취소',
                  style: TextStyle(color: Colors.black),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              TextButton(
                child: const Text(
                  '변경',
                  style: TextStyle(color: Colors.black),
                ),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    debugPrint('processing');
                  }
                  String changeNickname = _nicknameController.text;
                  context.read<UserProvider>().nickname = changeNickname;
                  await FirebaseFirestore.instance
                      .collection('user')
                      .doc(FirebaseAuth.instance.currentUser!.uid)
                      .update({'nickname': changeNickname})
                      .whenComplete(() => showTopSnackBar(
                            context,
                            const CustomSnackBar.success(
                                message: '닉네임 변경이 완료되었어요'),
                            animationDuration:
                                const Duration(milliseconds: 1200),
                            displayDuration: const Duration(milliseconds: 0),
                            reverseAnimationDuration:
                                const Duration(milliseconds: 800),
                          ))
                      .onError((error, stackTrace) => showTopSnackBar(
                            context,
                            const CustomSnackBar.error(
                                message: '닉네임 변경 도중 오류가 발생했어요. 다시 시도해주세요'),
                            animationDuration:
                                const Duration(milliseconds: 1200),
                            displayDuration: const Duration(milliseconds: 0),
                            reverseAnimationDuration:
                                const Duration(milliseconds: 800),
                          ))
                      .then((value) => Navigator.of(context).pop());
                },
              ),
            ],
          );
        });
  }
  void friendCheck() async {
    var dmRef = await FirebaseFirestore.instance.collection('user').doc(FirebaseAuth.instance.currentUser!.uid).get();
    List<dynamic> tmpList = dmRef.data()!['friends'];
    if(tmpList.contains(widget.uid)==true){
      isFriend=true;
    }
    else {
      isFriend=false;
    }
  }
  void dmCheck() async {
    bool isDm=true;
    var checkPost1 = await FirebaseFirestore.instance.collection('dm').where('userID1', isEqualTo: widget.uid)
    .where('userID2', isEqualTo: FirebaseAuth.instance.currentUser!.uid).get();
    var checkPost2 = await FirebaseFirestore.instance.collection('dm').where('userID2', isEqualTo: widget.uid)
        .where('userID1', isEqualTo: FirebaseAuth.instance.currentUser!.uid).get();

    if(checkPost1.docs.isNotEmpty){
      isDm=false;
    }
    if(checkPost2.docs.isNotEmpty){
      isDm=false;
    }
    if(isDm){
      FirebaseFirestore.instance.collection('dm').add({
        'userID1': FirebaseAuth.instance.currentUser!.uid,
        'userID2': widget.uid
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    _nicknameController = TextEditingController(
        text: context.select((UserProvider u) => u.nickname));
    return Scaffold(
        appBar: AppBar(
          elevation: 1,
          centerTitle: true,
          title: Text(
            isMe ? '마이페이지' : '$othersNickname님의 프로필',
            style: const TextStyle(color: Colors.black),
          ),
        ),
        body: Stack(
          children: <Widget>[
            Container(
              color: Colors.white,
              width: MediaQuery.of(context).size.width,
              alignment: Alignment.center,
              child: Column(
                children: [
                  //프로필 이미지
                  if (isMe)
                    Padding(
                      padding: const EdgeInsets.only(top: 15),
                      child: GestureDetector(
                        child: CachedNetworkImage(
                          imageUrl: context
                              .watch<UserProvider>()
                              .profileImageLink
                              .toString(),
                          imageBuilder: (context, imageProvider) => Container(
                            width: 130.0,
                            height: 130.0,
                            decoration: BoxDecoration(
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.grey,
                                  blurRadius: 5,
                                  spreadRadius: 3,
                                )
                              ],
                              shape: BoxShape.rectangle,
                              borderRadius: BorderRadius.circular(30),
                              image: DecorationImage(
                                image: imageProvider,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          //placeholder: (context, url) => CircularProgressIndicator(),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.person_rounded),
                        ),
                        onTap: () {
                          showImagePicker(context);
                        },
                      ),
                    ),
                  if (!isMe)
                    Padding(
                      padding: const EdgeInsets.only(top: 15),
                      child: CachedNetworkImage(
                        imageUrl: othersProfileImageUrl,
                        imageBuilder: (context, imageProvider) => Container(
                          width: 130.0,
                          height: 130.0,
                          decoration: BoxDecoration(
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.grey,
                                blurRadius: 5,
                                spreadRadius: 3,
                              )
                            ],
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(30),
                            image: DecorationImage(
                              image: imageProvider,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        //placeholder: (context, url) => CircularProgressIndicator(),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.person_rounded),
                      ),
                    ),

                  //닉네임
                  if (isMe)
                    Padding(
                      padding: const EdgeInsets.only(top: 0),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(context.select<UserProvider, String>(
                                (UserProvider u) => u.nickname.toString())),
                            IconButton(
                                iconSize: 15,
                                onPressed: () {
                                  showChangeNicknamePopup();
                                },
                                icon: const Icon(Icons.edit_rounded)),
                          ]),
                    ),
                  if (!isMe)
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(othersNickname),
                          ]),
                    ),

                  //이메일
                  if (isMe)
                    Padding(
                      padding: const EdgeInsets.only(top: 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            context
                                .select((UserProvider u) => u.email.toString()),
                            style: const TextStyle(
                                fontSize: 12, color: Colors.grey),
                          )
                        ],
                      ),
                    ),
                  if (!isMe)
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            othersUniv,
                            style: const TextStyle(
                                fontSize: 12, color: Colors.grey),
                          )
                        ],
                      ),
                    ),

                  //온도
                  Padding(
                    padding: EdgeInsets.only(top: 30),
                    child: Container(
                      margin: EdgeInsets.only(
                          left: MediaQuery.of(context).size.width * 0.08),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              '매너 온도',
                              style: TextStyle(fontSize: 16),
                            ),
                            IconButton(
                              onPressed: () {
                                debugPrint('온도 설명 페이지');
                              },
                              icon: const Icon(Icons.info_rounded),
                              iconSize: 16,
                            ),
                          ]),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 0),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          LinearPercentIndicator(
                            width: MediaQuery.of(context).size.width * 0.9,
                            lineHeight: 15.0,
                            percent: isMe
                                ? context.select((UserProvider u) =>
                                    u.temperature!.toDouble() / 100)
                                : othersTemperature / 100,
                            center: Text(
                              isMe
                                  ? '${context.select((UserProvider u) => u.temperature.toString())}°C'
                                  : '$othersTemperature°C',
                              style: GoogleFonts.lato(fontSize: 12),
                            ),
                            backgroundColor: Colors.grey[340],
                            progressColor: Colors.orangeAccent,
                            animation: true,
                            animationDuration: 1000,
                            barRadius: const Radius.circular(15),
                          ),
                        ]),
                  ),


                  if (isMe)
                    Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                      const Text(
                        '로그아웃',
                        //style: TextStyle(color: Palette.textColor1),
                      ),
                      IconButton(
                          onPressed: () {
                            _authentication.signOut();
                            UserProvider userProvider =
                                Provider.of<UserProvider>(context,
                                    listen: false);
                            userProvider.clear();
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        const NewLoginSignupScreen()),
                                (route) => false);
                          },
                          icon: const Icon(
                            Icons.logout_rounded,
                          )),
                    ]),
                  if (!isMe && !isFriend)
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      OutlinedButton(
                        onPressed: () {
                          final addFriend =
                              FirebaseFirestore.instance.collection('user');
                          addFriend
                              .doc(FirebaseAuth.instance.currentUser!.uid)
                              .update({
                            'friends': FieldValue.arrayUnion([widget.uid])
                          });
                          dmCheck();
                          setState(() {
                            isFriend = true;
                          });
                        },
                        child: const Text(
                          "팔로우",
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ]),
                    if(!isMe&&isFriend)
                      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                        OutlinedButton(
                          onPressed: () {
                            FirebaseFirestore.instance.collection('user').doc(FirebaseAuth.instance.currentUser!.uid).update({
                              'friends': FieldValue.arrayRemove([widget.uid])
                            });
                            setState(() {
                              isFriend=false;
                            });
                          },
                          style:OutlinedButton.styleFrom(backgroundColor: Colors.blueAccent),
                          child: const Text(
                            "팔로잉",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ]),
                ],
              ),
            ),
          ],
        ));
  }
}
