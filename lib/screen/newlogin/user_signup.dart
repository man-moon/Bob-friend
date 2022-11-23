import 'package:bobfriend/screen/newlogin/new_login_signup.dart';
import 'package:bobfriend/screen/newlogin/user_detail_setting.dart';
import 'package:bobfriend/validator/validator.dart';
import 'package:flutter/material.dart';

enum SignupStatus {
  //인증 메일 전송 버튼 -> 인증하기 버튼 -> 회원가입 버튼 비활성화 상태 -> 회원가입 활성화 상태
  beforeVerification, //인증 메일 전송 버튼
  verification, //인증하기 버튼
  afterVerification,  //회원가입 버튼 회색 상태
  signup  //회원가입 버튼 활성화 상태

}

class UserSignupScreen extends StatefulWidget {
  const UserSignupScreen({Key? key}) : super(key: key);

  @override
  State<UserSignupScreen> createState() => _UserSignupScreenState();
}

class _UserSignupScreenState extends State<UserSignupScreen> {

  SignupStatus signupStatus = SignupStatus.beforeVerification;

  String email = '';
  String emailVerificationCode = '';
  String password = '';
  String checkPassword = '';

  bool passwordVisibility = true;

  TextEditingController emailController = TextEditingController();
  TextEditingController emailVerificationController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: WillPopScope(
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
        child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            title: const Text('회원가입'),
            centerTitle: true,
          ),
          body: Container(
            margin: EdgeInsets.only(top: width*0.05),
            child: ListView(
              children: [Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: width * 0.08),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: const [
                            Text.rich(
                                TextSpan(
                                    children: <TextSpan>[
                                      TextSpan(text: '학교 이메일 인증\n\n', style: TextStyle(color: Colors.black, fontSize: 25)),
                                      TextSpan(text: '맞춤 서비스를 위해 학교 이메일 인증이 필요해요', style: TextStyle(color: Colors.grey, fontSize: 15),),
                                    ]
                                )
                            ),
                          ]
                      ),
                    ),

                    const SizedBox(height: 20,),


                    ///이메일 입력 필드
                Padding(
                    padding: EdgeInsets.symmetric(horizontal: width*0.05),
                    child: buildEmailField(context)
                ),
                const SizedBox(height: 13,),
                Padding(
                    padding: EdgeInsets.symmetric(horizontal: width*0.05),
                    child: Row(
                      children: [
                        (emailValidator(email) == null) ?
                          const Text('') :
                          Text(emailValidator(email).toString(), style: TextStyle(color: Colors.red),)
                      ],
                    )
                ),

                ///본인인증 테스트코드
                // TextButton(
                //   onPressed: () {
                //     Navigator.push(
                //         context,
                //         MaterialPageRoute(builder: (context) => Certification()));
                //   },
                //   child: Text('본인 인증', style: TextStyle(color: Colors.black),)),

                ///이메일 인증번호 입력 필드
                if(signupStatus != SignupStatus.beforeVerification)
                  Padding(
                      padding: EdgeInsets.symmetric(horizontal: width*0.05),
                      child: buildEmailVerificationField(context)
                  ),
                    const SizedBox(height: 8,),


                    ///비밀번호 입력 필드
                    if(signupStatus != SignupStatus.verification &&
                    signupStatus != SignupStatus.beforeVerification)
                  Padding(
                      padding: EdgeInsets.symmetric(horizontal: width*0.05),
                      child: buildPasswordField(context)
                  ),
                  if(signupStatus != SignupStatus.verification &&
                      signupStatus != SignupStatus.beforeVerification)
                  const SizedBox(height: 6,),
                  if(signupStatus != SignupStatus.verification &&
                      signupStatus != SignupStatus.beforeVerification)
                  Padding(
                      padding: EdgeInsets.symmetric(horizontal: width*0.05),
                      child: Row(
                        children: [
                          (passwordValidator(password) == null) ?
                          const Text('') :
                          Text(passwordValidator(password).toString(), style: const TextStyle(color: Colors.red),)
                        ],
                      )
                  ),
                    if(signupStatus != SignupStatus.verification &&
                        signupStatus != SignupStatus.beforeVerification)
                      const SizedBox(height: 8,),
                    ///비밀번호 확인 필드
                    if(signupStatus != SignupStatus.verification &&
                        signupStatus != SignupStatus.beforeVerification)
                    Padding(
                        padding: EdgeInsets.symmetric(horizontal: width*0.05),
                        child: buildCheckPasswordField(context)
                    ),
                    if(signupStatus != SignupStatus.verification &&
                        signupStatus != SignupStatus.beforeVerification)
                      const SizedBox(height: 6,),
                  if(signupStatus != SignupStatus.verification &&
                      signupStatus != SignupStatus.beforeVerification)
                    Padding(
                        padding: EdgeInsets.symmetric(horizontal: width*0.05),
                        child: Row(
                          children: [
                            (passwordCheckValidator(password, checkPassword) == null) ?
                            const Text('') :
                            Text(passwordCheckValidator(password, checkPassword).toString(), style: const TextStyle(color: Colors.red),)
                          ],
                        )
                    ),
                    SizedBox(height: height*0.15,),
              ]),]
            ),
          ),

          //모든 필드가 정상일 때 활성화됨
          floatingActionButton: buildSignupFloatingActionButton(context),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        ),
      ),
    );
  }

  Widget buildEmailField(BuildContext context) {
    return TextField(
      enabled: signupStatus == SignupStatus.beforeVerification ? true : false,
      onChanged: (val) {
        setState(() {
          email = val;
        });
      },
      keyboardType: TextInputType.emailAddress,
      autofocus: true,
      decoration: InputDecoration(
        labelText: '이메일',
        labelStyle: TextStyle(color: Colors.grey,),
        // disabledBorder: UnderlineInputBorder(
        //   borderRadius: BorderRadius.all(Radius.circular(8)),
        //   borderSide: BorderSide(
        //       color: Colors.grey,
        //       width: 2.0
        //   ),
        // ),
        focusedBorder: UnderlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide(
              color: emailValidator(email) == null ? Colors.greenAccent : Colors.red,
              width: 2.0
          ),
        ),
        enabledBorder: UnderlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide(
              color: emailValidator(email) == null ? Colors.greenAccent : Colors.grey,
              width: 2.0
          ),
        ),
        hintText: '학교 이메일만 가입이 가능해요',
        prefixIcon: Icon(Icons.mail_outline, color: Colors.grey,),
      ),
    );
  }

  Widget buildEmailVerificationField(BuildContext context) {
    return TextField(
      enabled: signupStatus == SignupStatus.verification ? true : false,
      onChanged: (val) {
        setState(() {
          emailVerificationCode = val;
        });
      },
      autofocus: true,
      keyboardType: TextInputType.number,

      decoration: InputDecoration(
        labelText: '인증코드',
        labelStyle: TextStyle(color: Colors.grey,),
        // disabledBorder: UnderlineInputBorder(
        //   borderRadius: BorderRadius.all(Radius.circular(8)),
        //   borderSide: BorderSide(
        //       color: Colors.grey,
        //       width: 2.0
        //   ),
        // ),
        focusedBorder: UnderlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide(
              color: emailVerificationCodeValidator(emailVerificationCode) == null ? Colors.greenAccent : Colors.red,
              width: 2.0
          ),
        ),
        enabledBorder: UnderlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide(
              color: emailVerificationCodeValidator(emailVerificationCode) == null ? Colors.greenAccent : Colors.grey,
              width: 2.0
          ),
        ),
        prefixIcon: Icon(Icons.numbers, color: Colors.grey,),
      ),
      maxLength: 4,
    );
  }

  Widget buildPasswordField(BuildContext context) {
    return TextField(
      enabled: signupStatus == SignupStatus.signup ? false : true,
      obscureText: passwordVisibility,
      obscuringCharacter: '*',
      enableSuggestions: false,
      onChanged: (val) {
        setState(() {
          password = val;
        });
      },
      autofocus: true,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        suffixIcon: IconButton(
          color: Colors.grey,
          icon: Icon(Icons.visibility),
          onPressed: () {
            setState(() {
              passwordVisibility = passwordVisibility ? false : true;
            });
          },
        ),
        labelText: '비밀번호',
        labelStyle: TextStyle(color: Colors.grey,),
        focusedBorder: UnderlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide(
              color: passwordValidator(password) == null ? Colors.greenAccent : Colors.red,
              width: 2.0
          ),
        ),
        enabledBorder: UnderlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide(
              color: passwordValidator(password) == null ? Colors.greenAccent : Colors.grey,
              width: 2.0
          ),
        ),
        prefixIcon: passwordValidator(password) == null ?
        const Icon(Icons.lock_outline, color: Colors.grey,) : const Icon(Icons.lock_open_outlined, color: Colors.grey,),
      ),
    );
  }
  Widget buildCheckPasswordField(BuildContext context) {
    return TextField(
      enabled: signupStatus == SignupStatus.signup ? false : true,
      obscureText: true,
      obscuringCharacter: '*',
      enableSuggestions: false,
      onChanged: (val) {
        setState(() {
          checkPassword = val;
        });
      },
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        labelText: '비밀번호 확인',
        labelStyle: TextStyle(color: Colors.grey,),
        focusedBorder: UnderlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide(
              color: passwordCheckValidator(password, checkPassword) == null && passwordValidator(password) == null ? Colors.greenAccent : Colors.red,
              width: 2.0
          ),
        ),
        enabledBorder: UnderlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide(
              color: passwordCheckValidator(password, checkPassword) == null && passwordValidator(password) == null ? Colors.greenAccent : Colors.grey,
              width: 2.0
          ),
        ),
        prefixIcon: passwordCheckValidator(password, checkPassword) == null ?
            const Icon(Icons.lock_outline, color: Colors.grey,) : const Icon(Icons.lock_open_outlined, color: Colors.grey,),
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
        backgroundColor: setFABColor(),
        onPressed: () {
          if(signupStatus == SignupStatus.beforeVerification &&
              emailValidator(email) != null) {}
          if(signupStatus == SignupStatus.beforeVerification &&
              emailValidator(email) == null) {
            setState(() {
              signupStatus = SignupStatus.verification;
            });
            //서버로 이메일 인증 메일 요청
            //서버 확인 후, setState 해야됨

          }
          if(signupStatus == SignupStatus.verification &&
              emailVerificationCodeValidator(emailVerificationCode) != null) {}
          if(signupStatus == SignupStatus.verification &&
              emailVerificationCodeValidator(emailVerificationCode) == null) {
            setState(() {
              signupStatus = SignupStatus.afterVerification;
              //서버로 인증 코드 확인 요청
              //서버 확인 후, setState 해야됨

            });
          }

          if(signupStatus == SignupStatus.afterVerification && password == checkPassword && passwordValidator(password) == null
              && passwordCheckValidator(password, checkPassword) == null) {
            //서버로 유저 이메일, 비밀번호 넘김, ok 응답 받은 후, 다음페이지로
            setState(() {
              signupStatus = SignupStatus.signup;
            });
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context) =>
                    UserDetailSettingScreen(email: email, password: password,)));
          }


        },
        isExtended: true,
        elevation: 3,
        label: setFABLabel(),
      ),
    );
  }

  //회색이어야 되는 경우만
  ColorSwatch<int> setFABColor() {
    if(signupStatus == SignupStatus.beforeVerification &&
        emailValidator(email) != null) {
      return Colors.grey;
    }
    if(signupStatus == SignupStatus.verification &&
        emailVerificationCodeValidator(emailVerificationCode) != null) {
      return Colors.grey;
    }
    if(signupStatus == SignupStatus.afterVerification && (password != checkPassword || passwordValidator(password) != null ||
        passwordCheckValidator(password, checkPassword) != null)) {
      return Colors.grey;
    }
    if(signupStatus == SignupStatus.afterVerification && password == checkPassword && passwordValidator(password) == null &&
    passwordCheckValidator(password, checkPassword) == null){
      return Colors.greenAccent;
    }
    return Colors.greenAccent;
  }

  Widget setFABLabel() {
    if(signupStatus == SignupStatus.beforeVerification) {
      return const Text('인증 메일 전송', style: TextStyle(fontSize: 18),);
    }
    if(signupStatus == SignupStatus.verification) {
      return const Text('이 코드로 인증할게요', style: TextStyle(fontSize: 18),);
    }
    return const Text('다음', style: TextStyle(fontSize: 18),);
  }

}