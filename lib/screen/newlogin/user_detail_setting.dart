import 'package:bobfriend/screen/load/loading.dart';
import 'package:bobfriend/validator/validator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class UserDetailSettingScreen extends StatefulWidget {
  const UserDetailSettingScreen({Key? key, required this.email, required this.password}) : super(key: key);

  final String email;
  final String password;

  @override
  State<UserDetailSettingScreen> createState() => _UserDetailSettingScreenState();
}

class _UserDetailSettingScreenState extends State<UserDetailSettingScreen> {
  String nickname = '';
  Duration get loginTime => const Duration(milliseconds: 2250);
  final _authentication = FirebaseAuth.instance;
  bool showCircularProgressIndicator = false;


  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () async {
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
                    Text('주의'),
                  ],
                ),
                //
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const <Widget>[
                    Text(
                      '지금 나가면 처음부터 다시 입력하셔야 해요.\n정말로 나가시겠어요?',
                    ),
                  ],
                ),
                actions: <Widget>[
                  TextButton(
                    child: const Text('취소', style: TextStyle(color: Colors.black),),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  TextButton(
                    child: const Text('나가기', style: TextStyle(color: Colors.black),),
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                  ),
                ],
              );
            });
        return false;
      },
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            title: const Text('닉네임 설정'),
            centerTitle: true,
          ),
          body: Container(
            margin: EdgeInsets.only(top: width*0.05),
            child: Column(
                children: [
                  ///닉네임 입력 필드
                  Padding(
                      padding: EdgeInsets.symmetric(horizontal: width*0.05),
                      child: buildNicknameField(context)
                  ),
                  Padding(
                      padding: EdgeInsets.symmetric(horizontal: width*0.07),
                      child: Row(
                        children: [
                          (nicknameValidator(nickname) == null) ?
                          const Text('') :
                          Text(nicknameValidator(nickname).toString(), style: const TextStyle(color: Colors.red),)
                        ],
                      )
                  ),
                ]),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
          floatingActionButton: buildSignupFloatingActionButton(context),
        ),
      ),
    );
  }

  Widget buildNicknameField(BuildContext context) {
    return TextField(
      maxLength: 12,
      onChanged: (val) {
        setState(() {
          nickname = val;
        });
      },
      keyboardType: TextInputType.text,
      autofocus: true,
      decoration: InputDecoration(
        labelText: '닉네임',
        labelStyle: const TextStyle(color: Colors.grey,),
        focusedBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide(
              color: nicknameValidator(nickname) == null ? Colors.greenAccent : Colors.red,
              width: 2.0
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide(
              color: nicknameValidator(nickname) == null ? Colors.greenAccent : Colors.grey,
              width: 2.0
          ),
        ),
      ),
    );
  }

  Widget buildSignupFloatingActionButton(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        shape: BoxShape.rectangle,
      ),
      width: MediaQuery.of(context).size.width * 0.9,
      child: FloatingActionButton.extended(
        backgroundColor: nicknameValidator(nickname) == null ? Colors.greenAccent : Colors.grey,
        onPressed: () async {
          if(nicknameValidator(nickname) == null) {
            if(mounted) {
              setState(() {
              showCircularProgressIndicator = true;
            });
            }
            signupUser().then((value) {
              if(value == null) {
                if(mounted){
                  setState(() {
                    showCircularProgressIndicator = false;
                  });
                }
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => const LoadingScreen()));
              } else {
                if(mounted){
                  setState(() {
                    showCircularProgressIndicator = false;
                  });
                }
                debugPrint(value);
              }
            });

          }
        },
        isExtended: true,
        elevation: 3,
        label: showCircularProgressIndicator ?
          const CircularProgressIndicator() : const Text('회원가입', style: TextStyle(fontSize: 18)),
      ),
    );
  }

  Future<String?> signupUser() {
    return Future.delayed(loginTime).then((_) async {
      try{
        await _authentication.createUserWithEmailAndPassword(
            email: widget.email,
            password: widget.password
        ).then((_) => setUser());

      } on FirebaseAuthException catch(e){
        if(e.code == 'email-already-in-use'){
          debugPrint('email-already-exits');
          return '이미 가입된 이메일입니다';
        }
      }
      return null;
    });
  }
  Future<String?> setUser() async {

    List<String?> parsedEmail = widget.email.split('@');
    String? emailDomain = parsedEmail[1];
    late final String univ;

    if(emailDomain != null){
      if(emailDomain.compareTo('inha.edu.kr') == 0){
        univ = 'inha';
      }
      else if(emailDomain.compareTo('ajou.ac.kr') == 0){
        univ = 'ajou';
      }
    }
    else{
      return 'ajou';
    }

    final profileRef = FirebaseStorage.instance
        .ref().child('profile_image')
        .child('basic.jpeg');

    await profileRef.getDownloadURL().then(
            (profileUrl) => updateUserDatabase(profileUrl, univ)
    );
    return null;
  }



  void updateUserDatabase(final dynamic profileUrl, final dynamic univ){
    FirebaseFirestore.instance
        .collection('user')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .set({
      'nickname': nickname,
      'email': widget.email,
      'profile_image': profileUrl,
      'univ': univ,
      'temperature': 36.5,
      'friends': [],
      'isRider': false,
      'isDelivering': false,
    });
    FirebaseFirestore.instance
        .collection('user')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('myDelivery').doc('myDelivery').set({
      'riderId': '',
      'restaurantName': '',
      'status': '',
      'deliveryLocation': '',
      'menu': [],
      'price': [],
      'count': [],
      'orderTime': Timestamp.now(),
      'orderId': '',
    });
  }


}

