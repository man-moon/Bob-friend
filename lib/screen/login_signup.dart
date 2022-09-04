import 'package:bobfriend/screen/home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';

//현재 접속중인 유저 정보를 전역에서 관리
late UserCredential? currentUser;

class LoginSignupScreen extends StatelessWidget {
  Duration get loginTime => Duration(milliseconds: 2250);

  final _authentication = FirebaseAuth.instance;

  Future<String?> _authUser(LoginData data) {
    debugPrint('Name: ${data.name}, Password: ${data.password}');

    return Future.delayed(loginTime).then((_) async {
      try{
        currentUser = await _authentication.signInWithEmailAndPassword(
          email: data.name,
          password: data.password,
        );
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          debugPrint('user-not-found');
          return '해당 이메일로 가입이 되어있지 않아요';
        } else if (e.code == 'wrong-password') {
          debugPrint('wrong-password');
          return '비밀번호가 틀렸어요';
        }
        return null;
      }
      // //회원가입, 로그인시 사용자 영속
      // void authPersistence() async{
      //   await FirebaseAuth.instance.setPersistence(Persistence.NONE);
      // }
    });
  }

  Future<String?> _signupUser(SignupData data) {
    debugPrint('Signup Name: ${data.name}, Password: ${data.password}');
    bool noError = true;
    return Future.delayed(loginTime).then((_) async {
      try{
        currentUser = await _authentication.createUserWithEmailAndPassword(
            email: data.name,
            password: data.password
        );

      } on FirebaseAuthException catch(e){
        if(e.code == 'email-already-in-use'){
          debugPrint('email-already-exits');
          noError = false;
          return '이미 가입된 이메일입니다';
        }
      }
      if(noError){
        debugPrint(FirebaseAuth.instance.currentUser.toString());
        FirebaseAuth.instance.currentUser!.sendEmailVerification();
        debugPrint('인증 메일 전송');

        FirebaseFirestore.instance
            .collection('user')
            .doc(currentUser!.user!.uid)
            .set({
          'nickname': data.additionalSignupData!['nickname'],
          'email': data.name,
        });

        // //회원가입, 로그인시 사용자 영속
        // void authPersistence() async{
        //   await FirebaseAuth.instance.setPersistence(Persistence.NONE);
        // }
      }
      return null;
    });
  }

  Future<String?> _recoverPassword(String name) {
    debugPrint('Name: $name');
    return Future.delayed(loginTime).then((_) async {
      await FirebaseAuth.instance.setLanguageCode("kr");
      await FirebaseAuth.instance.sendPasswordResetEmail(email: name);
      //return '존재하지 않는 사용자입니다';
      return null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        FocusScope.of(context).unfocus();
      },
      child: FlutterLogin(
        title: '밥친구',
        //logo: AssetImage('assets/images/ecorp-lightblue.png'),
        onLogin: _authUser,
        onSignup: _signupUser,
        onSubmitAnimationCompleted: () {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => HomeScreen(),
          ));
        },
        onRecoverPassword: _recoverPassword,
        navigateBackAfterRecovery: true,
        userType: LoginUserType.email,
        messages: LoginMessages(
          userHint: '이메일',
          passwordHint: '비밀번호',
          loginButton: '로그인',
          signupButton: '회원가입',
          forgotPasswordButton: '비밀번호 찾기',
          recoverPasswordIntro: '학교 이메일을 입력해주세요',
          recoverPasswordButton: '임시 비밀번호 발급',
          goBackButton: '돌아가기',
          recoverPasswordDescription: '해당 이메일로 임시 비밀번호가 발급됩니다',
          recoverPasswordSuccess: '해당 이메일로 임시 비밀번호가 발급되었습니다',
          confirmPasswordHint: '비밀번호 확인',
        ),
        additionalSignupFields: [
          UserFormField(
            keyName: 'nickname',
            displayName: '닉네임',
            icon: Icon(Icons.abc_rounded),
            //fieldValidator: ,
          )
        ],
      ),
    );
  }
}