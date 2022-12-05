import 'package:bobfriend/screen/newlogin/owner_signup.dart';
import 'package:bobfriend/screen/newlogin/phone_number_certification.dart';
import 'package:bobfriend/screen/newlogin/user_signup.dart';
import 'package:flutter/material.dart';

class SignupBranchScreen extends StatelessWidget {
  const SignupBranchScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: height * 0.15, bottom: height * 0.1),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    '회원유형을\n골라주세요',
                    style: TextStyle(fontSize: 38, color: Colors.grey),
                  ),
                ]
            ),
          ),
          SizedBox(
            width: width * 0.8,
            height: height * 0.1,
            child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.greenAccent),

              ),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const PhoneNumberCertificationScreen(signupType: 'user',)
                    )
                );
              },
              child: const Text('일반 회원', style: TextStyle(color: Colors.white, fontSize: 20),)
            ),
          ),
          const SizedBox(height: 30,),
          SizedBox(
            width: width * 0.8,
            height: height * 0.1,
            child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.greenAccent),

                ),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const PhoneNumberCertificationScreen(signupType: 'owner',)
                      )
                  );
                },
                child: const Text('가게 사장님 회원', style: TextStyle(color: Colors.white, fontSize: 20),)
            ),
          ),
          const SizedBox(height: 40,),
          const Center(child: Text('회원 유형 별로 서비스 이용에 제한이 있습니다', style: TextStyle(color: Colors.grey),)),
          const Center(child: Text('', style: TextStyle(color: Colors.grey),)),

        ]
      ),
    );
  }
}
