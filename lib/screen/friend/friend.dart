import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:eventsource/eventsource.dart';

class FriendScreen extends StatefulWidget {
  const FriendScreen({Key? key}) : super(key: key);

  @override
  State<FriendScreen> createState() => _FriendScreenState();
}

class _FriendScreenState extends State<FriendScreen> {

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: (){

        },
        icon: const Icon(Icons.add));

    //EventSource eventSource = EventSource.connect('http://192.168.136.150:8080/test');

    // return StreamBuilder(
    //   stream: eventSource.onMessage,
    //   builder: (BuildContext context, AsyncSnapshot<Event> snapshot) {
    //     debugPrint(snapshot.hasData.toString());
    //     return
    //       ListView.builder(
    //         padding: const EdgeInsets.fromLTRB(0, 0, 0, 12),
    //         reverse: true,
    //         itemCount: 1,
    //         itemBuilder: (context, index) {
    //           return Text('hello');
    //         },
    //       );
    //   },
    // );
  }
}
