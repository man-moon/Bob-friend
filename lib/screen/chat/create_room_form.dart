import 'package:bobfriend/config/chat_config.dart';
import 'package:bobfriend/config/palette.dart';
import 'package:bobfriend/provider/chat.dart';
import 'package:bobfriend/provider/user.dart';
import 'package:bobfriend/screen/chat/chat.dart';
import 'package:bobfriend/screen/chat/new_message.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

import '../../config/msg_config.dart';


class CreateRoomFormScreen extends StatefulWidget {
  const CreateRoomFormScreen({required this.univ, Key? key}) : super(key: key);
  final String univ;

  @override
  State<CreateRoomFormScreen> createState() => _CreateRoomFormScreenState();
}

class _CreateRoomFormScreenState extends State<CreateRoomFormScreen> {
  bool autoValidate = true;
  bool readOnly = false;
  bool showSegmentedControl = true;
  final _formKey = GlobalKey<FormBuilderState>();
  bool _roomNameHasError = false;
  bool _genderHasError = false;

  late ChatProvider chatProvider;
  late UserProvider userProvider;

  late var ref;

  var genderOptions = ['남자만 있었으면 좋겠어요', '여자만 있었으면 좋겠어요', '혼성도 괜찮아요'];

  dynamic setChatProvider() {
    debugPrint(ref.id.toString());
    userProvider = Provider.of<UserProvider>(context, listen: false);

    chatProvider.users =
    [{FirebaseAuth.instance.currentUser!.uid: userProvider.nickname}];
    chatProvider.roomName = _formKey.currentState!.value['roomName'];
    chatProvider.docId = ref.id;
    chatProvider.date =
        Timestamp.fromDate(_formKey.currentState!.value['date']);
    chatProvider.foodType = _formKey.currentState!.value['foodType'];
    chatProvider.gender = _formKey.currentState!.value['gender'];
    chatProvider.maxPersonnel = _formKey.currentState!.value['maxPersonnel'];
    chatProvider.nowPersonnel = 1;
    chatProvider.owner = FirebaseAuth.instance.currentUser!.uid;
    chatProvider.univ = widget.univ;
    chatProvider.state = ChatState.none.toString();

    return;
  }

  //void _onChanged(dynamic val) => debugPrint(val.toString());

  @override
  Widget build(BuildContext context) {
    chatProvider = Provider.of<ChatProvider>(context, listen: false);
    return Scaffold(
      floatingActionButton: buildCreateRoomFAB(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      appBar: AppBar(title: const Text('방 만들기'), elevation: 0, centerTitle: true,),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              FormBuilder(
                key: _formKey,
                // enabled: false,
                onChanged: () {
                  _formKey.currentState!.save();
                  debugPrint(_formKey.currentState!.value.toString());
                },
                autovalidateMode: AutovalidateMode.disabled,
                initialValue: const {
                  'maxPersonnel': 2,
                  'roomName': '나랑 밥 먹을 사람~',
                  'gender': '혼성도 괜찮아요',
                },
                skipDisabled: true,
                child: Column(
                  children: <Widget>[
                    const SizedBox(height: 15),
                    FormBuilderTextField(
                      autovalidateMode: AutovalidateMode.always,
                      name: 'roomName',
                      decoration: InputDecoration(
                        hintText: '나랑 밥 먹을 사람~',
                        labelText: '방 제목',
                        suffixIcon: _roomNameHasError
                            ? const Icon(Icons.error, color: Colors.red)
                            : const Icon(Icons.check, color: Colors.green),
                      ),
                      onChanged: (val) {
                        setState(() {
                          _roomNameHasError =
                          !(_formKey.currentState?.fields['roomName']
                              ?.validate() ??
                              false);
                        });
                      },
                      // valueTransformer: (text) => num.tryParse(text),
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(
                            errorText: '방 제목 입력은 필수에요'),
                        //FormBuilderValidators.numeric(),
                        FormBuilderValidators.maxLength(
                            16, errorText: '제목 수는 16글자까지 작성 가능해요'),
                      ]),
                      // initialValue: '12',
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                    ),
                    FormBuilderDateTimePicker(
                      name: 'date',
                      initialEntryMode: DatePickerEntryMode.calendar,
                      initialValue: DateTime.now(),
                      inputType: InputType.both,
                      decoration: InputDecoration(
                        labelText: '식사 시간대',
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () {
                            _formKey.currentState!.fields['date']?.didChange(
                                null);
                          },
                        ),
                      ),
                      initialTime: TimeOfDay.now(),
                      //locale: const Locale.fromSubtags(languageCode: 'ko'),
                      locale: const Locale('ko'),
                    ),

                    FormBuilderDropdown<String>(
                      // autovalidate: true,
                      name: 'gender',
                      decoration: InputDecoration(
                        labelText: '입장 가능한 성별',
                        suffix: _genderHasError
                            ? const Icon(Icons.error)
                            : const Icon(Icons.check),
                      ),
                      // initialValue: 'Male',
                      allowClear: true,
                      hint: const Text('성별', textAlign: TextAlign.center,),
                      validator: FormBuilderValidators.compose(
                          [FormBuilderValidators.required()]),
                      items: genderOptions
                          .map((gender) =>
                          DropdownMenuItem(
                            alignment: AlignmentDirectional.centerStart,
                            value: gender,
                            child: Text(gender),
                          ))
                          .toList(),
                      onChanged: (val) {
                        setState(() {
                          _genderHasError = !(_formKey
                              .currentState?.fields['gender']
                              ?.validate() ??
                              false);
                        });
                      },
                      valueTransformer: (val) => val?.toString(),
                    ),
                    FormBuilderSegmentedControl(
                      borderColor: Colors.greenAccent,
                      pressedColor: Colors.greenAccent,
                      selectedColor: Colors.greenAccent,
                      decoration: const InputDecoration(
                        labelText: '방 인원수',
                      ),
                      name: 'maxPersonnel',
                      // initialValue: 1,
                      // textStyle: TextStyle(fontWeight: FontWeight.bold),
                      options: List.generate(5, (i) => i + 2)
                          .map((number) =>
                          FormBuilderFieldOption(
                            value: number,
                            child: Text(
                              number.toString(),
                              style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold),
                            ),
                          )).toList(),
                      //onChanged: _onChanged,
                    ),

                    FormBuilderFilterChip<String>(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: const InputDecoration(
                          labelText: '뭐 먹을까요?'),
                      name: 'foodType',
                      selectedColor: Colors.greenAccent,
                      options: const [
                        FormBuilderChipOption(
                          value: '한식',
                          avatar: CircleAvatar(backgroundImage: AssetImage(
                              'image/korean.jpg')),
                        ),
                        FormBuilderChipOption(
                          value: '양식',
                          avatar: CircleAvatar(backgroundImage: AssetImage(
                              'image/steak.png')),
                        ),
                        FormBuilderChipOption(
                          value: '일식',
                          avatar: CircleAvatar(backgroundImage: AssetImage(
                              'image/sushi.png')),
                        ),
                        FormBuilderChipOption(
                          value: '중식',
                          avatar: CircleAvatar(backgroundImage: AssetImage(
                              'image/jaja.png')),
                        ),
                        FormBuilderChipOption(
                          value: '패스트푸드',
                          avatar: CircleAvatar(backgroundImage: AssetImage(
                              'image/burger.png')),
                        ),
                      ],
                      //onChanged: _onChanged,
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.minLength(
                            1, errorText: '한 개 이상의 카테고리를 골라주세요'),
                        //FormBuilderValidators.maxLength(3),
                      ]),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 7),
            ],
          ),
        ),
      ),
    );
  }
  Widget buildCreateRoomFAB(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        shape: BoxShape.rectangle,
      ),
      width: MediaQuery.of(context).size.width * 0.9,
      child: FloatingActionButton.extended(

        backgroundColor: Colors.greenAccent,
        onPressed: () async {
          if (_formKey.currentState?.saveAndValidate() ?? false) {
            debugPrint(_formKey.currentState?.value.toString());
            debugPrint(_formKey.currentState!.value['roomName']);

            ref = FirebaseFirestore.instance
                .collection('chats')
                .doc();

            final user = FirebaseAuth.instance.currentUser;
            userProvider = Provider.of<UserProvider>(context,
                listen: false);

            Map u = {user!.uid: userProvider.nickname};

            await ref.set({
              'roomName': _formKey.currentState!
                  .value['roomName'],
              'maxPersonnel': _formKey.currentState!
                  .value['maxPersonnel'],
              'date': _formKey.currentState!.value['date'],
              'gender': _formKey.currentState!.value['gender'],
              'foodType': _formKey.currentState!
                  .value['foodType'],
              'univ': widget.univ,
              'nowPersonnel': 1,
              'users': [u],
              'owner': user.uid,
              'state': ChatState.none.toString(),
              'meetingPlace': '',
            }).then((value) async =>
            await ref.collection("chat")
                .doc("WelcomeMessage")
                .set({
              'text': '채팅방을 생성하였습니다! 새로운 친구가 오면 알려드릴게요!',
              'time': Timestamp.now(),
              'userId': 'admin',
              'nickname': '밥친구',
              'type': MessageType.normal.toString(),
              'action': MessageAction.none.toString(),
              'restaurant': '',
              'meetingPlace': '',
            })).then((_) => setChatProvider()).then((value) =>
                Navigator.pop(context)).then(
                    (value) =>
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                          //deliver doc ref
                          return ChatScreen(ref);
                        })
                    ));
          } else {
            debugPrint(_formKey.currentState?.value.toString());
            debugPrint('validation failed');
          }
        },
        isExtended: true,
        elevation: 3,
        label: const Text('방 만들기', style: TextStyle(fontSize: 18),),
      ),
    );
  }

}