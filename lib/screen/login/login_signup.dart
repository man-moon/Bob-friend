import 'package:bobfriend/screen/load/loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:bobfriend/validator/validator.dart';
import 'package:provider/provider.dart';
import '../../provider/user.dart';

class LoginSignupScreen extends StatefulWidget {
  const LoginSignupScreen({Key? key}) : super(key: key);

  @override
  State<LoginSignupScreen> createState() => _LoginSignupScreen();
}

class _LoginSignupScreen extends State<LoginSignupScreen> {
  Duration get loginTime => const Duration(milliseconds: 2250);
  final _authentication = FirebaseAuth.instance;

  void updateUserDatabase(final dynamic data, final dynamic profileUrl, final dynamic univ){
    FirebaseFirestore.instance
        .collection('user')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .set({
      'nickname': data.additionalSignupData!['nickname'],
      'email': data.name,
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

  Future<String?> setUser(SignupData data) async {
    FirebaseAuth.instance.currentUser!.sendEmailVerification();

    List<String?> parsedEmail = data.name!.split('@');
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
      return '올바른 학교 이메일을 입력해주세요';
    }

    final profileRef = FirebaseStorage.instance
        .ref().child('profile_image')
        .child('basic.jpeg');

    await profileRef.getDownloadURL().then(
            (profileUrl) => updateUserDatabase(data, profileUrl, univ)
    );
    return null;
  }
  Future<String?> _authUser(LoginData data) {
    debugPrint('Name: ${data.name}, Password: ${data.password}');

    return Future.delayed(loginTime).then((_) async {
      try{
        await _authentication.signInWithEmailAndPassword(
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

    });
  }
  Future<String?> _signupUser(SignupData data) {
    debugPrint('이메일: ${data.name}, 비밀번호: ${data.password}');
    return Future.delayed(loginTime).then((_) async {
      try{
        await _authentication.createUserWithEmailAndPassword(
            email: data.name ?? '',
            password: data.password ?? ''
        ).then((value) => setUser(data));

      } on FirebaseAuthException catch(e){
        if(e.code == 'email-already-in-use'){
          debugPrint('email-already-exits');
          return '이미 가입된 이메일입니다';
        }
      }
      return null;
    });
  }
  Future<String?> _recoverPassword(String name) {
    debugPrint('Name: $name');
    return Future.delayed(loginTime).then((_) async {
      await FirebaseAuth.instance.setLanguageCode("kr");
      await FirebaseAuth.instance.sendPasswordResetEmail(email: name);
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
        theme: LoginTheme(
            primaryColor: Colors.deepOrangeAccent,
            accentColor: Colors.white,
            errorColor: Colors.red
        ),
        title: '밥친구',
        onLogin: _authUser,
        onSignup: _signupUser,
        userValidator: emailValidator,
        passwordValidator: passwordValidator,
        onRecoverPassword: _recoverPassword,
        navigateBackAfterRecovery: true,
        userType: LoginUserType.email,
        onSubmitAnimationCompleted: (){
          Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => LoadingScreen(),
          ));
        },
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
          additionalSignUpSubmitButton: '제출',
          additionalSignUpFormDescription: '닉네임을 입력해주세요',
          confirmPasswordError: '비밀번호가 일치하지 않습니다',
          signUpSuccess: '회원가입 성공!',
          flushbarTitleSuccess: '환영합니다',
          flushbarTitleError: '오류',
        ),
        additionalSignupFields: const [
          UserFormField(
            keyName: 'nickname',
            displayName: '닉네임',
            icon: Icon(Icons.abc_rounded),
            fieldValidator: nicknameValidator,
          )
        ],
      ),
    );
  }
}