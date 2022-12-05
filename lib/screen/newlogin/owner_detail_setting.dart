import 'package:bobfriend/screen/address/address.dart';
import 'package:bobfriend/screen/load/loading.dart';
import 'package:bobfriend/validator/validator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:kpostal/kpostal.dart';

enum OwnerSignupStatus {
  beforeMainAddress,
  completeMainAddress,
}

class OwnerDetailSettingScreen extends StatefulWidget {
  const OwnerDetailSettingScreen({Key? key, required this.email, required this.password}) : super(key: key);

  final String email;
  final String password;

  @override
  State<OwnerDetailSettingScreen> createState() => _OwnerDetailSettingScreenState();
}

class _OwnerDetailSettingScreenState extends State<OwnerDetailSettingScreen> {
  String restaurantName = '';
  String restaurantAddress = '';
  String restaurantDetailAddress = '';

  OwnerSignupStatus status = OwnerSignupStatus.beforeMainAddress;
  Duration get loginTime => const Duration(milliseconds: 2250);
  final _authentication = FirebaseAuth.instance;
  bool showCircularProgressIndicator = false;
  //bool enableAddressField = true;
  TextEditingController addressController = TextEditingController();

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
            title: const Text('가게 세부정보 설정'),
            centerTitle: true,
          ),
          body: Container(
            margin: EdgeInsets.only(top: width*0.05),
            child: Column(
                children: [
                  ///상호명
                  Padding(
                      padding: EdgeInsets.symmetric(horizontal: width*0.05),
                      child: buildRestaurantNameField(context)
                  ),
                  const SizedBox(height: 6,),
                  Padding(
                      padding: EdgeInsets.symmetric(horizontal: width*0.07),
                      child: Row(
                        children: [
                          (restaurantNameValidator(restaurantName) == null) ?
                          const Text('') :
                          Text(restaurantNameValidator(restaurantName).toString(), style: const TextStyle(color: Colors.red),)
                        ],
                      )
                  ),

                  const SizedBox(height: 10,),

                  ///가게 주소
                  Padding(
                      padding: EdgeInsets.symmetric(horizontal: width*0.05),
                      child: buildRestaurantAddressField(context)
                  ),
                  const SizedBox(height: 6,),
                  Padding(
                      padding: EdgeInsets.symmetric(horizontal: width*0.07),
                      child: Row(
                        children: [
                          (restaurantAddressValidator(restaurantAddress) == null) ?
                          const Text('') :
                          Text(restaurantAddressValidator(restaurantAddress).toString(), style: const TextStyle(color: Colors.red),)
                        ],
                      )
                  ),

                  const SizedBox(height: 10,),


                  ///가게 세부주소
                  if(status != OwnerSignupStatus.beforeMainAddress)
                  Column(children: [
                    Padding(
                        padding: EdgeInsets.symmetric(horizontal: width*0.05),
                        child: buildRestaurantDetailAddressField(context)
                    ),
                    const SizedBox(height: 6,),
                    Padding(
                        padding: EdgeInsets.symmetric(horizontal: width*0.07),
                        child: Row(
                          children: [
                            (restaurantDetailAddressValidator(restaurantDetailAddress) == null) ?
                            const Text('') :
                            Text(restaurantDetailAddressValidator(restaurantDetailAddress).toString(), style: const TextStyle(color: Colors.red),)
                          ],
                        )
                    ),
                  ],)


                ]),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
          floatingActionButton: buildSignupFloatingActionButton(context),
        ),
      ),
    );
  }

  Widget buildRestaurantNameField(BuildContext context) {
    return TextField(
      onChanged: (val) {
        setState(() {
          restaurantName = val;
        });
      },
      keyboardType: TextInputType.text,
      autofocus: true,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.restaurant, color: Colors.grey,),
        labelText: '상호명',
        labelStyle: const TextStyle(color: Colors.grey,),
        focusedBorder: UnderlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide(
              color: restaurantNameValidator(restaurantName) == null ? Colors.greenAccent : Colors.red,
              width: 2.0
          ),
        ),
        enabledBorder: UnderlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide(
              color: restaurantNameValidator(restaurantName) == null ? Colors.greenAccent : Colors.grey,
              width: 2.0
          ),
        ),
      ),
    );
  }


  Widget buildRestaurantAddressField(BuildContext context) {
    return TextField(
      controller: addressController,
      onTap: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => KpostalView(
              callback: (Kpostal result) {
                debugPrint(result.address);
                setState(() {
                  addressController.text = result.address;
                  restaurantAddress = result.address;
                  status = OwnerSignupStatus.completeMainAddress;
                  //enableAddressField = false;
                });
              },
            ),
          ),
        );
      },
      //enabled: enableAddressField,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.map, color: Colors.grey,),
        labelText: '가게 주소',
        labelStyle: const TextStyle(color: Colors.grey,),
        focusedBorder: UnderlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide(
              color: restaurantAddressValidator(restaurantAddress) == null ? Colors.greenAccent : Colors.red,
              width: 2.0
          ),
        ),
        enabledBorder: UnderlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide(
              color: restaurantAddressValidator(restaurantAddress) == null ? Colors.greenAccent : Colors.grey,
              width: 2.0
          ),
        ),
      ),
    );
  }

  Widget buildRestaurantDetailAddressField(BuildContext context) {
    return TextField(
      autofocus: true,
      onChanged: (value) {
        setState(() {
          restaurantDetailAddress = value;
        });
      },
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.more, color: Colors.grey,),
        labelText: '가게 상세주소',
        labelStyle: const TextStyle(color: Colors.grey,),
        focusedBorder: UnderlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide(
              color: restaurantDetailAddressValidator(restaurantDetailAddress) == null ? Colors.greenAccent : Colors.red,
              width: 2.0
          ),
        ),
        enabledBorder: UnderlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide(
              color: restaurantDetailAddressValidator(restaurantDetailAddress) == null ? Colors.greenAccent : Colors.grey,
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
        backgroundColor:
          restaurantNameValidator(restaurantName) == null &&
              restaurantAddressValidator(restaurantAddress) == null &&
              restaurantDetailAddressValidator(restaurantDetailAddress) == null ?
          Colors.greenAccent : Colors.grey,
        onPressed: () async {

          ///회원가입 활성화
          if(restaurantNameValidator(restaurantName) == null &&
              restaurantAddressValidator(restaurantAddress) == null &&
              restaurantDetailAddressValidator(restaurantDetailAddress) == null) {

          }
          if(restaurantNameValidator(restaurantName) == null) {
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
      'nickname': restaurantName,
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

  @override
  void dispose() {
    addressController.dispose();
    super.dispose();
  }
}
