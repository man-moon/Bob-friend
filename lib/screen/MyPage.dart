import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:bobfriend/my_app.dart';

import 'login_signup.dart';



/*
* provider로 관리해야하는 상태
* image.url,
* */

class MyPageScreen extends StatefulWidget {
  const MyPageScreen({Key? key}) : super(key: key);

  @override
  State<MyPageScreen> createState() => _MyPageScreenState();
}

class _MyPageScreenState extends State<MyPageScreen> {
  final _authentication = FirebaseAuth.instance;

  void updateProfileImage(XFile? pickedImage) async {
    File image = File(pickedImage!.path);
    final ref = FirebaseStorage.instance.ref().child('profile_image').child('${currentUser!.uid}.jpg');
    try {
      await ref.putFile(image);

      String profileUrl = await ref.getDownloadURL();
      await FirebaseFirestore.instance.collection('user').
      doc(currentUser!.uid).update(
          {'profile_image': profileUrl}
      ).whenComplete(
              () => applyProfileImage());
    } catch(e){
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

  void showImagePicker(BuildContext context){
    showDialog(
        context: context,
        builder: (context){
          return AlertDialog(
            // RoundedRectangleBorder - Dialog 화면 모서리 둥글게 조절
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            //Dialog Main Title
            title: Column(
              children: <Widget>[
                Text('프로필 변경'),
              ],
            ),
            //
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  '프로필을 변경하기 위해 갤러리에서 사진을 선택합니다',
                ),
              ],
            ),
            actions: <Widget>[
              TextButton(
                child: Text('취소'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              TextButton(
                child: Text('사진 선택'),
                onPressed: () {
                  pickImage();
                  Navigator.pop(context);
                },
              ),
            ],
          );
        }
    );
  }

  void applyProfileImage(){
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Center(
            child: Text(
              '마이페이지',
              style: TextStyle(color: Colors.black),
            ),
          ),
        ),
        body: Stack(
          children: <Widget>[
            GestureDetector(
              child: Container(
                alignment: Alignment.topCenter,
                padding: EdgeInsets.only(top: 30),
                child: CircleAvatar(
                  radius: 70,
                  backgroundColor: Colors.grey,
                  backgroundImage: AssetImage('image/person.png'),
                    // image.url == '' ?
                    //   AssetImage('image/person.png') : CachedNetworkImageProvider(image.url),
                )
              ),
              onTap: () {
                showImagePicker(context);
              },
            ),
            SlidingUpPanel(
              panel: Center(
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const Text(
                        '로그아웃',
                        //style: TextStyle(color: Palette.textColor1),
                      ),
                      IconButton(
                          onPressed: () {
                            currentUser = null;
                            _authentication.signOut();
                            Navigator.of(context).pushReplacement(MaterialPageRoute(
                              builder: (context) => LoginSignupScreen(),
                            ));
                          },
                          icon: Icon(
                            Icons.logout_rounded,
                            //color: Palette.textColor1,
                          )
                      ),
                    ]
                ),
              ),
              collapsed:
                  Center(child: Icon(Icons.keyboard_double_arrow_up_rounded)),
            )
          ],
        ));
  }
// @override
// Widget build(BuildContext context) {
//   return Container(
//     margin: EdgeInsets.only(bottom: 10),
//     child: Row(
//         mainAxisAlignment: MainAxisAlignment.end,
//         children: [
//           const Text(
//             '로그아웃',
//             //style: TextStyle(color: Palette.textColor1),
//           ),
//           IconButton(
//               onPressed: () {
//                 currentUser = null;
//                 _authentication.signOut();
//                 Navigator.of(context).pushReplacement(MaterialPageRoute(
//                   builder: (context) => LoginSignupScreen(),
//                 ));
//               },
//               icon: Icon(
//                 Icons.logout_rounded,
//                 //color: Palette.textColor1,
//               )
//           ),
//         ]
//     ),
//   );
// }
}
