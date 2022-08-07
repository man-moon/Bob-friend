import 'package:bobfriend/screen/chat.dart';
import 'package:bobfriend/screen/chat_list.dart';
import 'package:bobfriend/screen/home.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import '../config/palette.dart';

class LoginSignUpScreen extends StatefulWidget {
  const LoginSignUpScreen({Key? key}) : super(key: key);

  @override
  State<LoginSignUpScreen> createState() => _LoginSignUpScreenState();
}

class _LoginSignUpScreenState extends State<LoginSignUpScreen> {
  final _authentication = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();

  bool showSpinner = false;
  bool isSignupScreen = true;
  String userNickname = '';
  String userEmail = '';
  String userPassword = '';

  void _tryValidation() {
    //모든 textformfield validator 호출
    final isValid = _formKey.currentState!.validate();

    if (isValid) {
      //각 textformfield에서 onSaved 메소드 호출
      _formKey.currentState!.save();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.backgroundColor,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Stack(
            children: [
              //background
              Positioned(
                top: 0,
                right: 0,
                left: 0,
                child: Container(
                    height: 300,
                    decoration: const BoxDecoration(
                        image: DecorationImage(
                      image: AssetImage('image/sky.jpg'),
                      fit: BoxFit.fill,
                    )),
                    child: Container(
                      padding: const EdgeInsets.only(top: 90, left: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(
                            text: const TextSpan(
                              text: '나랑 밥친구 할래?',
                              style: TextStyle(
                                letterSpacing: 2.0,
                                fontSize: 25,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'BM',
                              ),
                              // children: [
                              //   TextSpan(
                              //       text: ' 밥친구',
                              //       style: TextStyle(
                              //         letterSpacing: 1.0,
                              //         fontSize: 25,
                              //         color: Colors.white,
                              //         fontWeight: FontWeight.bold,
                              //       ),
                              //       children: [
                              //         TextSpan(
                              //             text: ' 할래?',
                              //             style: TextStyle(
                              //               letterSpacing: 1.0,
                              //               fontSize: 25,
                              //               color: Colors.white,
                              //               fontWeight: FontWeight.normal,
                              //             )
                              //         )
                              //       ]
                              //   )
                              // ],
                            ),
                          ),
                          const SizedBox(
                            height: 5.0,
                          ),
                          const Text(
                            '모여모여 배달비 절감!',
                            style: TextStyle(
                              letterSpacing: 1.0,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    )),
              ),
              //text form
              AnimatedPositioned(
                duration: const Duration(milliseconds: 100),
                curve: Curves.easeIn,
                top: 180,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 100),
                  curve: Curves.easeIn,
                  padding: const EdgeInsets.all(20.0),
                  height: isSignupScreen ? 295 : 230,
                  width: MediaQuery.of(context).size.width - 40,
                  margin: const EdgeInsets.symmetric(horizontal: 20.0),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 15,
                          spreadRadius: 5,
                        )
                      ]),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.only(bottom: 75),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  isSignupScreen = false;
                                });
                              },
                              child: Column(
                                children: [
                                  Text(
                                    '로그인',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: isSignupScreen
                                            ? Palette.textColor1
                                            : Colors.black),
                                  ),
                                  if (!isSignupScreen)
                                    Container(
                                      margin: const EdgeInsets.only(top: 3),
                                      height: 2,
                                      width: 55,
                                      color: Colors.lightBlueAccent,
                                    )
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  isSignupScreen = true;
                                });
                              },
                              child: Column(
                                children: [
                                  Text(
                                    '회원가입',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: isSignupScreen
                                            ? Colors.black
                                            : Palette.textColor1),
                                  ),
                                  if (isSignupScreen)
                                    Container(
                                      margin: const EdgeInsets.only(top: 3),
                                      height: 2,
                                      width: 55,
                                      color: Colors.lightBlueAccent,
                                    )
                                ],
                              ),
                            ),
                          ],
                        ),

                        //입력 폼
                        if (isSignupScreen)
                          Container(
                            margin: const EdgeInsets.only(top: 20),
                            child: Form(
                              key: _formKey,
                              child: Column(
                                children: [
                                  TextFormField(
                                    key: const ValueKey(1),
                                    validator: (value) {
                                      if (value!.isEmpty || value.length < 2) {
                                        return '닉네임은 두 글자 이상이어야 합니다';
                                      }
                                      return null;
                                    },
                                    onSaved: (value) {
                                      userNickname = value!;
                                    },
                                    onChanged: (value) {
                                      userNickname = value;
                                    },
                                    style: const TextStyle(color: Colors.black),
                                    decoration: const InputDecoration(
                                      prefixIcon: Icon(
                                        Icons.account_circle,
                                        color: Palette.iconColor,
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Palette.textColor1),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(35.0)),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.lightBlueAccent),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(35.0)),
                                      ),
                                      hintText: '닉네임',
                                      hintStyle: TextStyle(
                                          fontSize: 14,
                                          color: Palette.textColor1),
                                      contentPadding: EdgeInsets.all(10.0),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 14,
                                  ),
                                  TextFormField(
                                    keyboardType: TextInputType.emailAddress,
                                    key: const ValueKey(2),
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return '이메일을 입력해주세요';
                                      }
                                      if (!value.contains('@')) {
                                        return '올바른 형식이 아닙니다';
                                      }
                                      //@기준 파싱해서 정확한 이메일 형식인지 검증하는 과정 필요
                                      if (!value.contains('@ajou.ac.kr') &&
                                          !value.contains('@inha.edu')) {
                                        return '학교 이메일이 아니면 가입할 수 없습니다';
                                      }
                                      return null;
                                    },
                                    onSaved: (value) {
                                      userEmail = value!;
                                    },
                                    onChanged: (value) {
                                      userEmail = value;
                                    },
                                    style: const TextStyle(color: Colors.black),
                                    decoration: const InputDecoration(
                                      prefixIcon: Icon(
                                        Icons.email_rounded,
                                        color: Palette.iconColor,
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Palette.textColor1),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(35.0)),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.lightBlueAccent),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(35.0)),
                                      ),
                                      hintText: '학교 이메일 (abc@ajou.ac.kr)',
                                      hintStyle: TextStyle(
                                          fontSize: 14,
                                          color: Palette.textColor1),
                                      contentPadding: EdgeInsets.all(10.0),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 14,
                                  ),
                                  TextFormField(
                                    obscureText: true,
                                    key: const ValueKey(3),
                                    validator: (value) {
                                      if (value!.isEmpty || value.length < 6) {
                                        return '비밀번호는 6글자 이상이어야 합니다';
                                      }
                                      return null;
                                    },
                                    onSaved: (value) {
                                      userPassword = value!;
                                    },
                                    onChanged: (value) {
                                      userPassword = value;
                                    },
                                    style: const TextStyle(color: Colors.black),
                                    decoration: const InputDecoration(
                                      prefixIcon: Icon(
                                        Icons.lock_rounded,
                                        color: Palette.iconColor,
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Palette.textColor1),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(35.0)),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.lightBlueAccent),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(35.0)),
                                      ),
                                      hintText: '비밀번호',
                                      hintStyle: TextStyle(
                                          fontSize: 14,
                                          color: Palette.textColor1),
                                      contentPadding: EdgeInsets.all(10.0),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                        //로그인 화면
                        if (!isSignupScreen)
                          Container(
                            margin: const EdgeInsets.only(top: 20),
                            child: Form(
                              key: _formKey,
                              child: Column(
                                children: [
                                  TextFormField(
                                    keyboardType: TextInputType.emailAddress,
                                    key: ValueKey(4),
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return '이메일을 입력해주세요';
                                      }
                                      if (!value.contains('@')) {
                                        return '올바른 형식이 아닙니다';
                                      }
                                      //@기준 파싱해서 정확한 이메일 형식인지 검증하는 과정 필요
                                      if (!value.contains('@ajou.ac.kr') &&
                                          !value.contains('@inha.edu')) {
                                        return '학교 이메일을 입력해주세요';
                                      }
                                      return null;
                                    },
                                    onSaved: (value) {
                                      userEmail = value!;
                                    },
                                    onChanged: (value) {
                                      userEmail = value;
                                    },
                                    style: TextStyle(color: Colors.black),
                                    decoration: const InputDecoration(
                                      prefixIcon: Icon(
                                        Icons.email_rounded,
                                        color: Palette.iconColor,
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Palette.textColor1),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(35.0)),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.lightBlueAccent),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(35.0)),
                                      ),
                                      hintText: '학교 이메일 (abc@ajou.ac.kr)',
                                      hintStyle: TextStyle(
                                          fontSize: 14,
                                          color: Palette.textColor1),
                                      contentPadding: EdgeInsets.all(10.0),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 14,
                                  ),
                                  TextFormField(
                                    obscureText: true,
                                    key: ValueKey(5),
                                    validator: (value) {
                                      if (value!.isEmpty || value.length < 6) {
                                        return '비밀번호는 6글자 이상이어야 합니다';
                                      }
                                      return null;
                                    },
                                    onSaved: (value) {
                                      userPassword = value!;
                                    },
                                    onChanged: (value) {
                                      userPassword = value;
                                    },
                                    style: TextStyle(color: Colors.black),
                                    decoration: const InputDecoration(
                                      prefixIcon: Icon(
                                        Icons.lock_rounded,
                                        color: Palette.iconColor,
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Palette.textColor1),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(35.0)),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.lightBlueAccent),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(35.0)),
                                      ),
                                      hintText: '비밀번호',
                                      hintStyle: TextStyle(
                                          fontSize: 14,
                                          color: Palette.textColor1),
                                      contentPadding: EdgeInsets.all(10.0),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                      ],
                    ),
                  ),
                ),
              ),
              //button
              AnimatedPositioned(
                  duration: const Duration(milliseconds: 100),
                  curve: Curves.easeIn,
                  top: isSignupScreen ? 430 : 365,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Container(
                      padding: EdgeInsets.all(15),
                      height: 90,
                      width: 90,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(50)),
                      child: GestureDetector(
                        onTap: () async {
                          setState(() {
                            showSpinner = true;
                          });

                          //회원가입 동작
                          if (isSignupScreen) {
                            _tryValidation();

                            try {
                              final newUser = await _authentication
                                  .createUserWithEmailAndPassword(
                                      email: userEmail, password: userPassword);

                              await FirebaseFirestore.instance
                                  .collection('user')
                                  .doc(newUser.user!.uid)
                                  .set({
                                'userNickname': userNickname,
                                'email': userEmail
                              });

                              if (newUser.user != null) {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  //return ChatScreen();
                                  return ChatListScreen();
                                }));
                                setState(() {
                                  showSpinner = false;
                                });
                              }
                            } catch (e) {
                              print(e);
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                content: Text('이메일과 비밀번호를 확인해주세요'),
                                backgroundColor: Colors.blue,
                              ));
                            }
                          }

                          //로그인 동작
                          if (!isSignupScreen) {
                            _tryValidation();

                            try {
                              final newUser = await _authentication
                                  .signInWithEmailAndPassword(
                                email: userEmail,
                                password: userPassword,
                              );
                              if (newUser.user != null) {
                                // Navigator.push(
                                //     context,
                                //     MaterialPageRoute(builder: (context){
                                //       return ChatScreen();
                                //     })
                                // );
                                setState(() {
                                  showSpinner = false;
                                });
                              }
                            } catch (e) {
                              print(e);
                            }
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                                colors: [Colors.lightBlueAccent, Colors.white],
                                begin: Alignment.topLeft,
                                end: Alignment.topRight),
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                spreadRadius: 2,
                                blurRadius: 2,
                                offset: Offset(0, 1),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.arrow_forward_ios_rounded,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  )),
              //sign with google
              Positioned(
                top: MediaQuery.of(context).size.height - 125,
                right: 0,
                left: 0,
                child: Column(
                  children: [
                    Text(
                      isSignupScreen ? '구글 계정으로 회원가입' : '구글 계정으로 로그인',
                      style: const TextStyle(color: Colors.black54),
                    ),
                    const SizedBox(height: 10),
                    TextButton.icon(
                        onPressed: () {},
                        style: TextButton.styleFrom(
                          primary: Colors.white,
                          minimumSize: Size(155, 40),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          backgroundColor: Palette.googleColor,
                        ),
                        icon: const Icon(Icons.add),
                        label: const Text('Google'))
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
