import 'package:bobfriend/validator/validator.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
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

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({this.uid, Key? key}) : super(key: key);
  final String? uid;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late final bool isMe;
  final _authentication = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  late dynamic _nicknameController;


  @override
  void initState() {
    debugPrint('INIT!!');
    super.initState();
    checkIsMe();
  }

  @override
  void didChangeDependencies() {
    debugPrint('didChangeDependencies!!');
    super.didChangeDependencies();
  }

  void checkIsMe() {
    if(widget.uid == null){
      isMe = false;
    }
    else{
      isMe = true;
    }
  }

  //db 업데이트, user provider 업데이트
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
                child: const Text('취소'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              TextButton(
                child: const Text('변경'),
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
                            const CustomSnackBar.success(message: '닉네임 변경이 완료되었어요'),
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
                          )).then((value) => Navigator.of(context).pop());
                },
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    _nicknameController = TextEditingController(text: context.select((UserProvider u) => u.nickname));
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
              child: Column(
                children: [
                  //프로필 이미지
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

                  //닉네임
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

                  //이메일
                  if(isMe)
                  Padding(
                    padding: const EdgeInsets.only(top: 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          context.select((UserProvider u) => u.email.toString()),
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey
                          ),
                        )
                      ],
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(top: 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          context.select((UserProvider u) => u.temperature.toString()),
                          style: const TextStyle(
                              fontSize: 12,
                              color: Colors.red
                          ),
                        )
                      ],
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
              collapsed: const Center(
                  child: Icon(Icons.keyboard_double_arrow_up_rounded)),
            )
          ],
        ));
  }

  @override
  void dispose() {
    debugPrint('DISPOSE!');
    _nicknameController.dispose();
    super.dispose();
  }
}
