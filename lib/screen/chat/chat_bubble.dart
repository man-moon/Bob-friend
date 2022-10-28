import 'package:bobfriend/config/msg_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/bubble_type.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_4.dart';

class ChatBubbles extends StatelessWidget {
  ChatBubbles(this.message, this.isMe, this.userNickname, this.action, {Key? key})
      : super(key: key);
  final String message;
  final String userNickname;
  final String action;
  bool isMe;

  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisAlignment:
            isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if(isMe)
            Padding(
              padding: EdgeInsets.fromLTRB(0, 0, 5, 0),
              child: ChatBubble(
                clipper: ChatBubbleClipper4(type: BubbleType.sendBubble),
                alignment: Alignment.topRight,
                margin: EdgeInsets.only(top: 20),
                backGroundColor: Colors.orangeAccent,
                child: Container(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.6,
                  ),
                  child: Column(
                      crossAxisAlignment: isMe
                          ? CrossAxisAlignment.end
                          : CrossAxisAlignment.start,
                      children: [
                        Text(
                          userNickname,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.white70),
                        ),
                        Text(
                          message,
                          style: TextStyle(color: Colors.white),
                        ),
                      ]),
                ),
              ),
            ),
          if (!isMe)
            Padding(
              padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
              child: GestureDetector(
                onTap: (){
                  debugPrint('');
                },
                child: ChatBubble(
                  clipper: ChatBubbleClipper4(type: BubbleType.receiverBubble),
                  backGroundColor: Color(0xffE7E7ED),
                  margin: EdgeInsets.only(top: 20),
                  child: Container(
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.6,
                    ),
                    child: Column(
                        crossAxisAlignment: isMe
                            ? CrossAxisAlignment.end
                            : CrossAxisAlignment.start,
                        children: [
                          Text(
                            userNickname,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, color: Colors.black38),
                          ),
                          SizedBox(height: 5,),
                          Text(
                            message,
                            style: TextStyle(color: Colors.black),
                          ),
                          if(action.compareTo(MessageAction.selectRestaurant.toString()) == 0)
                          ElevatedButton(
                              onPressed: (){
                                debugPrint('가게 보러가요');
                              },
                              child: const Text('가게 보러가기', style: TextStyle(color: Colors.black),)
                          ),
                          if(action.compareTo(MessageAction.selectMenu.toString()) == 0)
                            ElevatedButton(
                                onPressed: (){
                                  debugPrint('메뉴 선정');
                                },
                                child: const Text('메뉴 정하러 가기', style: TextStyle(color: Colors.black),)
                            )

                        ]),
                  ),
                  ),
              ),
              ),
        ]);
  }
}
