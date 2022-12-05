import 'package:bobfriend/screen/newlogin/owner_signup.dart';
import 'package:bobfriend/screen/newlogin/user_signup.dart';
import 'package:bobfriend/validator/validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum PhoneNumberCertificationStatus {
  beforePressButton,
  afterPressButton,

}

class PhoneNumberCertificationScreen extends StatefulWidget {
  const PhoneNumberCertificationScreen({Key? key, required this.signupType}) : super(key: key);
  final String signupType;
  @override
  State<PhoneNumberCertificationScreen> createState() => _PhoneNumberCertificationScreenState();
}

class _PhoneNumberCertificationScreenState extends State<PhoneNumberCertificationScreen> {
  PhoneNumberCertificationStatus status = PhoneNumberCertificationStatus.beforePressButton;
  String phoneNumber = '';
  String certificationCode = '';
  bool isPhoneNumberFieldEnable = true;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('회원가입'),
          centerTitle: true,
          elevation: 0,
        ),
        body: Container(
          margin: EdgeInsets.only(top: width*0.05),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: width * 0.08),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: const [
                      Text.rich(
                        TextSpan(
                            children: <TextSpan>[
                              TextSpan(text: '휴대폰 인증\n\n', style: TextStyle(color: Colors.black, fontSize: 25)),
                              TextSpan(text: '원활한 서비스 이용을 위해 본인인증을 진행합니다', style: TextStyle(color: Colors.grey, fontSize: 15),),
                            ]
                        )
                      ),
                    ]
                  ),
                ),

                const SizedBox(height: 20,),

                ///핸드폰 번호 입력 필드
                Padding(
                    padding: EdgeInsets.symmetric(horizontal: width*0.05),
                    child: buildPhoneNumberField(context)
                ),
                //const SizedBox(height: 13,),

                Padding(
                    padding: EdgeInsets.symmetric(horizontal: width*0.1),
                    child: Row(
                      children: [
                        (phoneNumberValidator(phoneNumber) == null) ?
                        const Text('') :
                        Text(phoneNumberValidator(phoneNumber).toString(), style: const TextStyle(color: Colors.grey),)
                      ],
                    )
                ),

                ///인증번호 입력 필드
                if(status == PhoneNumberCertificationStatus.afterPressButton)
                  Padding(
                      padding: EdgeInsets.symmetric(horizontal: width*0.05),
                      child: buildInputCodeField(context)
                  ),
              ]),
        ),
        floatingActionButton: buildPhoneNumberCertificationFAB(context),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }
  Widget buildPhoneNumberField(BuildContext context) {
    return TextField(
      inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[0-9]'))],
      maxLength: 11,
      enabled: isPhoneNumberFieldEnable,
      onChanged: (val) {
        setState(() {
          phoneNumber = val;
        });
      },
      keyboardType: TextInputType.phone,
      autofocus: true,
      decoration: InputDecoration(
        labelText: '전화번호',
        labelStyle: const TextStyle(color: Colors.grey,),
        focusedBorder: UnderlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide(
              color: phoneNumberValidator(phoneNumber) == null ? Colors.greenAccent : Colors.grey,
              width: 2.0
          ),
        ),
        enabledBorder: UnderlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide(
              color: phoneNumberValidator(phoneNumber) == null ? Colors.greenAccent : Colors.grey,
              width: 2.0
          ),
        ),
        hintText: '01012345678',
        prefixIcon: const Icon(Icons.smartphone, color: Colors.grey,),
      ),
    );
  }

  Widget buildPhoneNumberCertificationFAB(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        shape: BoxShape.rectangle,
      ),
      width: MediaQuery.of(context).size.width * 0.9,
      child: FloatingActionButton.extended(
        backgroundColor: setFABColor(),
        onPressed: () {
          if(phoneNumberValidator(phoneNumber) == null &&
              status == PhoneNumberCertificationStatus.beforePressButton) {
            setState(() {
              status = PhoneNumberCertificationStatus.afterPressButton;
              isPhoneNumberFieldEnable = false;
            });
          }
          if(phoneNumberCertificationCodeValidator(certificationCode) == null) {
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => widget.signupType == 'user' ? const UserSignupScreen() : const OwnerSignupScreen()));
          }
        },
        isExtended: true,
        elevation: 3,
        label: Text(status == PhoneNumberCertificationStatus.beforePressButton ? '인증번호 전송' : '인증하기', style: TextStyle(fontSize: 18),),
      ),
    );
  }

  Widget buildInputCodeField(BuildContext context) {
    return TextField(
      inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[0-9]'))],
      maxLength: 6,
      onChanged: (val) {
        setState(() {
          certificationCode = val;
        });
      },
      keyboardType: TextInputType.number,
      autofocus: true,
      decoration: InputDecoration(
        labelText: '인증번호',
        labelStyle: const TextStyle(color: Colors.grey,),
        focusedBorder: UnderlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide(
              color: phoneNumberCertificationCodeValidator(certificationCode) == null ? Colors.greenAccent : Colors.grey,
              width: 2.0
          ),
        ),
        enabledBorder: UnderlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide(
              color: phoneNumberCertificationCodeValidator(certificationCode) == null ? Colors.greenAccent : Colors.grey,
              width: 2.0
          ),
        ),
        prefixIcon: const Icon(Icons.numbers, color: Colors.grey,),
      ),
    );
  }

  ColorSwatch<int> setFABColor() {
    if(status == PhoneNumberCertificationStatus.beforePressButton) {
      if(phoneNumberValidator(phoneNumber) == null) {
        return Colors.greenAccent;
      }
      else {
        return Colors.grey;
      }
    }
    if(status == PhoneNumberCertificationStatus.afterPressButton) {
      if(phoneNumberCertificationCodeValidator(certificationCode) == null) {
        return Colors.greenAccent;
      }
      else {
        return Colors.grey;
      }
    }
    return Colors.grey;
  }

}
