import 'package:bobfriend/config/palette.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class CreateRoomFormScreen extends StatefulWidget {
  const CreateRoomFormScreen({Key? key}) : super(key: key);

  @override
  State<CreateRoomFormScreen> createState() => _CreateRoomFormScreenState();
}

class _CreateRoomFormScreenState extends State<CreateRoomFormScreen> {

  final _formKey = GlobalKey<FormState>();
  String roomName = '';
  Object roomMaxPersonnel = '2';
  bool showSpinner = false;


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
        appBar: AppBar(
          //방제로 대체
          title: Text('채팅방 만들기'),
        ),
        body: ModalProgressHUD(
          inAsyncCall: showSpinner,
          child: GestureDetector(
            onTap: (){
              FocusScope.of(context).unfocus();
            },
            child: Container(
              margin: EdgeInsets.only(top: 15, left: 25, right: 25),
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 20,),
                    TextFormField(
                      key: ValueKey(1),
                      validator: (value){
                        if(value!.isEmpty) {
                          return '방 제목을 입력해주세요';
                        }
                        return null;
                      },
                      onChanged: (value){
                        roomName = value;
                      },
                      onSaved: (value){
                        roomName = value!;
                      },
                      style: const TextStyle(color: Colors.black),
                      decoration: const InputDecoration(
                        prefixIcon: Icon(
                          Icons.meeting_room,
                          color: Palette.iconColor,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Palette.textColor1),
                          borderRadius: BorderRadius.all(
                              Radius.circular(12.0)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.lightBlueAccent),
                          borderRadius: BorderRadius.all(
                              Radius.circular(12.0)),
                        ),
                        hintText: '방 제목',
                        hintStyle: TextStyle(
                            fontSize: 14,
                            color: Palette.textColor1),
                        contentPadding: EdgeInsets.all(10.0),
                      ),
                    ),
                    SizedBox(height: 20,),
                    DropdownButton(
                      isExpanded: true,
                        alignment: Alignment.center,
                        style: TextStyle(color: Palette.textColor1, fontWeight: FontWeight.bold),
                        focusColor: Colors.lightBlueAccent,
                        icon: const Icon(Icons.keyboard_arrow_down_rounded),
                        iconDisabledColor: Palette.textColor1,
                        iconEnabledColor: Palette.textColor1,
                        underline: Container(),
                        value: roomMaxPersonnel,
                        items: const [
                          DropdownMenuItem(
                            value: '2',
                            child: Text(
                              '2',
                              style: TextStyle(fontSize: 14),
                            ),
                          ),
                          DropdownMenuItem(
                            value: '3',
                            child: Text(
                              '3',
                              style: TextStyle(fontSize: 14),
                            ),
                          ),
                          DropdownMenuItem(
                            value: '4',
                            child: Text(
                              '4',
                              style: TextStyle(fontSize: 14),
                            ),
                          ),
                          DropdownMenuItem(
                            value: '5',
                            child: Text(
                              '5',
                              style: TextStyle(fontSize: 14),
                            ),
                          ),
                          DropdownMenuItem(
                            value: '6',
                            child: Text(
                              '6',
                              style: TextStyle(fontSize: 14),
                            ),
                          ),
                        ],
                        onChanged: (value) {
                          setState(() {
                            roomMaxPersonnel = value!;
                          });
                        },
                      ),
                    // Center(
                    //   // child: GestureDetector(
                    //   //   onTap: () {
                    //   //     setState(() {
                    //   //       showSpinner = true;
                    //   //     });
                    //   //   },
                    //   // ),
                    //   child: IconButton(
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
          ),
        )
    );
  }
}
