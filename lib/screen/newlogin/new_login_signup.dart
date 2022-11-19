import 'package:bobfriend/screen/newlogin/user_signup.dart';
import 'package:bobfriend/screen/newlogin/signup_branch.dart';
import 'package:flutter/material.dart';

class NewLoginSignupScreen extends StatefulWidget {
  const NewLoginSignupScreen({Key? key}) : super(key: key);

  @override
  State<NewLoginSignupScreen> createState() => _NewLoginSignupScreenState();
}

class _NewLoginSignupScreenState extends State<NewLoginSignupScreen> {
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
}

Widget buildLoginFloatingActionButton(BuildContext context) {
  return Container(
    decoration: const BoxDecoration(
      shape: BoxShape.rectangle,
    ),
    width: MediaQuery.of(context).size.width * 0.9,
    child: FloatingActionButton.extended(

      backgroundColor: Colors.greenAccent,
      onPressed: () {},
      isExtended: true,
      elevation: 3,
      label: const Text('로그인', style: TextStyle(fontSize: 18),),
    ),
  );
}

Widget buildEmailField(BuildContext context) {
  return TextField(
    keyboardType: TextInputType.emailAddress,
    decoration: InputDecoration(
      labelText: '이메일',
      labelStyle: TextStyle(color: Colors.grey,),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
        borderSide: BorderSide(color: Colors.greenAccent, width: 2.0),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
        borderSide: BorderSide(color: Colors.grey, width: 2.0),
      ),
      hintText: '이메일',
      prefixIcon: Icon(Icons.mail_outline, color: Colors.grey,),
    ),
  );
}

Widget buildPasswordField(BuildContext context) {
  return TextField(
    keyboardType: TextInputType.visiblePassword,
    decoration: InputDecoration(
      labelText: '비밀번호',
      labelStyle: TextStyle(color: Colors.grey),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
        borderSide: BorderSide(color: Colors.greenAccent, width: 2.0),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
        borderSide: BorderSide(color: Colors.grey, width: 2.0),
      ),
      prefixIcon: Icon(Icons.lock_outline, color: Colors.grey,),
    ),
  );
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