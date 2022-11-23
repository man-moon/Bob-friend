import 'package:bobfriend/config/msg_config.dart';
import 'package:bobfriend/screen/chat/chat_addition/additional_chat.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/bubble_type.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_4.dart';

import 'chat_addition/restaurant_detail.dart';

class ChatBubbles extends StatelessWidget {
  ChatBubbles(this.message, this.isMe, this.userNickname, this.action, this.restaurant ,{Key? key})
      : super(key: key);
  final String message;
  final String userNickname;
  final String action;
  final String restaurant;
  bool isMe;

  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisAlignment:
            isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if(isMe)
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
              child: ChatBubble(
                clipper: ChatBubbleClipper4(type: BubbleType.sendBubble),
                alignment: Alignment.topRight,
                margin: const EdgeInsets.only(top: 20),
                backGroundColor: Colors.grey,
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
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        const SizedBox(height: 5,),
                        Text(
                          message,
                          style: const TextStyle(color: Colors.white),
                        ),
                        if(action.compareTo(MessageAction.share.toString()) == 0)
                          ElevatedButton(
                              onPressed: (){
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => RestaurantDetailScreen(name: restaurant, type: 'noShare',)));
                              },
                              child: const Text('가게 보러가기', style: TextStyle(color: Colors.black),)
                          ),
                      ]),
                ),
              ),
            ),
          if (!isMe)
            Padding(
              padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
              child: GestureDetector(
                onTap: (){
                  debugPrint('');
                },
                child: ChatBubble(
                  clipper: ChatBubbleClipper4(type: BubbleType.receiverBubble),
                  backGroundColor: (userNickname == '밥친구') ? const Color.fromRGBO(244, 224, 164, 1) : const Color(0xffE7E7ED),
                  margin: const EdgeInsets.only(top: 20),
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
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, color: Colors.black38),
                          ),
                          const SizedBox(height: 5,),
                          if(action.compareTo(MessageAction.selectMeetingPlace.toString()) != 0)
                          Text(
                            message,
                            style: const TextStyle(color: Colors.black),
                          ),
                          if(action.compareTo(MessageAction.selectRestaurant.toString()) == 0)
                          ElevatedButton(
                              onPressed: (){
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => const AdditionalChatScreen(type: 'share',)));
                              },
                              child: const Text('가게 보러가기', style: TextStyle(color: Colors.black),)
                          ),
                          if(action.compareTo(MessageAction.share.toString()) == 0)
                            ElevatedButton(
                                onPressed: (){
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => RestaurantDetailScreen(name: restaurant, type: 'noShare',)));
                                },
                                child: const Text('가게 보러가기', style: TextStyle(color: Colors.black),)
                            ),
                          if(action.compareTo(MessageAction.selectMenu.toString()) == 0)
                            ElevatedButton(
                                onPressed: (){

                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => RestaurantDetailScreen(name: restaurant, type: 'addMenu',)));
                                },
                                child: const Text('메뉴 정하러 가기', style: TextStyle(color: Colors.black),)
                            ),
                          if(action.compareTo(MessageAction.selectMeetingPlace.toString()) == 0)
                            Text('배달이 도착하면 $message(으)로 모여주세요!', style: TextStyle(color: Colors.black, fontSize: 15),),


                        ]),
                  ),
                  ),
              ),
              ),
        ]);
  }
}
