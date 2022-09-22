import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:bobfriend/my_app.dart';
import '../provider/user.dart';
import 'login_signup.dart';

import 'package:bobfriend/provider/user.dart';

/// 상대방 페이지일 경우에는 팔로우 표시 추가 필요
///
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

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _authentication = FirebaseAuth.instance;

  //db 업데이트, user provider 업데이트
  void updateProfileImage(XFile? pickedImage) async {
    File image = File(pickedImage!.path);
    final ref = FirebaseStorage.instance
                    .ref().child('profile_image')
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
                child: const Text('취소'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              TextButton(
                child: const Text('사진 선택'),
                onPressed: () {
                  pickImage();
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }

  void applyProfileImage(String url){
    context.read<UserProvider>().profileImageLink = url;
  }

  void showChangeNicknamePopup(){
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
              children: const <Widget>[
                TextField(),
              ],
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('취소'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              TextButton(
                child: const Text('확인'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
    String changeNickname = 'changednickname';
    context.read<UserProvider>().nickname = changeNickname;
    FirebaseFirestore.instance.collection('user').
    doc(FirebaseAuth.instance.currentUser!.uid).update({'nickname': changeNickname});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Center(
            child: Text(
              '마이페이지',
              style: TextStyle(color: Colors.black),
            ),
          ),
        ),
        body: Stack(
          children: <Widget>[
            Container(
              color: Colors.white,
              width: MediaQuery.of(context).size.width,
              alignment: Alignment.center,

              child: Column(children: [
                Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: GestureDetector(
                    child: CachedNetworkImage(
                      imageUrl: context.watch<UserProvider>().profileImageLink.toString(),
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
                              image: imageProvider, fit: BoxFit.cover,),
                        ),
                      ),
                      //placeholder: (context, url) => CircularProgressIndicator(),
                      errorWidget: (context, url, error) => const Icon(Icons.person_rounded),
                    ),
                    onTap: () {
                      showImagePicker(context);
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(context.select<UserProvider, String>((UserProvider user) => user.nickname.toString())),
                      IconButton(
                        iconSize: 15,
                        onPressed: (){
                          showChangeNicknamePopup();
                        },
                        icon: const Icon(Icons.edit_rounded)
                      ),
                    ]
                  ),
                ),
              ],

              ),
            ),

            SlidingUpPanel(
              panel: Center(
                child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                  const Text(
                    '로그아웃',
                    //style: TextStyle(color: Palette.textColor1),
                  ),
                  IconButton(
                      onPressed: () {
                        _authentication.signOut();
                      },
                      icon: const Icon(
                        Icons.logout_rounded,
                        //color: Palette.textColor1,
                      )),
                ]),
              ),
              collapsed:
                  const Center(child: Icon(Icons.keyboard_double_arrow_up_rounded)),
            )
          ],
        ));
  }
}
