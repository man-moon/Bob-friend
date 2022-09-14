import 'package:bobfriend/config/profile_image.dart';
import 'package:bobfriend/screen/login_signup.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class MyPageScreen extends StatefulWidget {
  const MyPageScreen({Key? key}) : super(key: key);

  @override
  State<MyPageScreen> createState() => _MyPageScreenState();
}

class _MyPageScreenState extends State<MyPageScreen> {
  final _authentication = FirebaseAuth.instance;

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
                )
              ),
              onTap: () {
                showImagePicker(context);
              },
            ),
            SlidingUpPanel(
              panel: Center(
                child: Text("This is the sliding Widget"),
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
