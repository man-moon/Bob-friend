import 'package:bobfriend/screen/load/loading.dart';
import 'package:bobfriend/screen/newlogin/user_signup.dart';
import 'package:bobfriend/screen/newlogin/signup_branch.dart';
import 'package:bobfriend/validator/validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class NewLoginSignupScreen extends StatefulWidget {
  const NewLoginSignupScreen({Key? key}) : super(key: key);

  @override
  State<NewLoginSignupScreen> createState() => _NewLoginSignupScreenState();
}

class _NewLoginSignupScreenState extends State<NewLoginSignupScreen> {
  Duration get loginTime => const Duration(milliseconds: 2250);
  final _authentication = FirebaseAuth.instance;

  bool showCircularProgressIndicator = false;

  String email = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: Column(children: [
          Container(
            margin: EdgeInsets.only(top: height * 0.15, bottom: height * 0.1),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text(
                  '밥친구',
                  style: TextStyle(fontSize: 38),
                ),
              ]
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: width*0.05),
            child: buildEmailField(context)
          ),
          const SizedBox(height: 13,),
          Padding(
              padding: EdgeInsets.symmetric(horizontal: width*0.05),
              child: buildPasswordField(context)
          ),
          const SizedBox(height: 10,),
          Padding(
              padding: EdgeInsets.symmetric(horizontal: width*0.05),
              child: forgotPassword(context)
          ),
          Padding(
              padding: EdgeInsets.symmetric(horizontal: width*0.05),
              child: goSignup(context)
          )



        ]),


        floatingActionButton: buildLoginFloatingActionButton(context),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }

  Future<String?> _authUser() {
    debugPrint('Name: $email, Password: $password');

    return Future.delayed(loginTime).then((_) async {
      try{
        await _authentication.signInWithEmailAndPassword(
          email: email,
          password: password,
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

  Widget buildEmailField(BuildContext context) {
    return TextField(
      onChanged: (value) {
        setState(() {
          email = value;
        });
      },
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        labelText: '이메일',
        labelStyle: TextStyle(color: Colors.grey,),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide(color: emailValidator(email) == null ? Colors.greenAccent : Colors.grey, width: 2.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide(color: emailValidator(email) == null ? Colors.greenAccent : Colors.grey, width: 2.0),
        ),
        prefixIcon: Icon(Icons.mail_outline, color: Colors.grey,),
      ),
    );
  }

  Widget buildPasswordField(BuildContext context) {
    return TextField(
      onChanged: (value) {
        setState(() {
          password = value;
        });
      },
      obscureText: true,
      obscuringCharacter: '*',
      keyboardType: TextInputType.visiblePassword,
      decoration: InputDecoration(
        labelText: '비밀번호',
        labelStyle: TextStyle(color: Colors.grey),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide(color: passwordValidator(password) == null ? Colors.greenAccent : Colors.grey, width: 2.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide(color: passwordValidator(password) == null ? Colors.greenAccent : Colors.grey, width: 2.0),
        ),
        prefixIcon: Icon(Icons.lock_outline, color: Colors.grey,),
      ),
    );
  }

  Widget buildLoginFloatingActionButton(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        shape: BoxShape.rectangle,
      ),
      width: MediaQuery.of(context).size.width * 0.9,
      child: FloatingActionButton.extended(

        backgroundColor: (emailValidator(email) == null && passwordValidator(password) == null) ?
          Colors.greenAccent : Colors.grey,
        onPressed: () {
          if(emailValidator(email) == null && passwordValidator(password) == null) {
            setState(() {
              showCircularProgressIndicator = true;
            });
            _authUser().then((value) {
              if(mounted){
                setState(() {
                  showCircularProgressIndicator = false;
                });
              }
              if(value == null) {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => const LoadingScreen()));
              }
              else {
                showTopSnackBar(
                  context,
                  CustomSnackBar.error(message: value),
                  animationDuration: const Duration(milliseconds: 1200),
                  displayDuration: const Duration(milliseconds: 0),
                  reverseAnimationDuration: const Duration(milliseconds: 800),
                );
              }
            });
          }
        },
        isExtended: true,
        elevation: 3,
        label: showCircularProgressIndicator ?
          const CircularProgressIndicator() : const Text('로그인', style: TextStyle(fontSize: 18),),
      ),
    );
  }


}




Widget forgotPassword(BuildContext context) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.end,
    children: [
        TextButton(
          onPressed: () {

          },
          child: const Text('비밀번호를 잊었어요',
            style: TextStyle(
                color: Colors.black,
                decoration: TextDecoration.underline
            ),
          ),
        )
    ],
  );
}

Widget goSignup(BuildContext context) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.end,
    children: [
      const Text(
        '아직 계정이 없으신가요? ',
        style: TextStyle(color: Colors.grey),
      ),
      TextButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SignupBranchScreen()));
        },
        child: const Text('회원가입 ',
          style: TextStyle(
              color: Colors.black,
              decoration: TextDecoration.underline
          ),
        ),
      )
    ],
  );
}