import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/bubble_type.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_4.dart';

class ChatBubbles extends StatelessWidget {
  ChatBubbles(this.message, this.isMe, this.userNickname, {Key? key})
      : super(key: key);
  final String message;
  final String userNickname;
  bool isMe;

  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisAlignment:
            isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (isMe)
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
                        Text(
                          message,
                          style: TextStyle(color: Colors.black),
                        ),
                      ]),
                ),
                ),
              ),
        ]);
  }
}
