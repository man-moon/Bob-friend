import 'package:bobfriend/provider/chat.dart';
import 'package:bobfriend/provider/my_catalog.dart';
import 'package:bobfriend/provider/my_delivery.dart';
import 'package:bobfriend/provider/owner.dart';
import 'package:bobfriend/provider/user.dart';
import 'package:flutter/material.dart';
import 'package:bobfriend/my_app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => ChatProvider()),
        ChangeNotifierProvider(create: (_) => MyCatalogProvider()),
        ChangeNotifierProvider(create: (_) => MyDeliveryProvider()),
        ChangeNotifierProvider(create: (_) => OwnerProvider()),
      ],
      child: const MyApp(),
    )
  );
}


//
// import 'dart:convert';
//
// import 'package:flutter/material.dart';
// import 'package:stomp_dart_client/stomp.dart';
// import 'package:stomp_dart_client/stomp_config.dart';
// import 'package:stomp_dart_client/stomp_frame.dart';
// import 'package:uuid/uuid.dart';
// import 'package:web_socket_channel/web_socket_channel.dart';
//
// import 'Msg.dart';
//
// void main() => runApp(const MyApp());
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     const title = 'WebSocket Demo';
//     return const MaterialApp(
//       title: title,
//       home: MyHomePage(
//         title: title,
//       ),
//     );
//   }
// }
//
// class MyHomePage extends StatefulWidget {
//   const MyHomePage({
//     super.key,
//     required this.title,
//   });
//
//   final String title;
//
//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }
//
// class _MyHomePageState extends State<MyHomePage> {
//   List<Msg> list = [];
//   StompClient? stompClient;
//   TextEditingController textEditingController = TextEditingController();
//
//
//   final socketUrl = 'http://10.0.2.2:8080/chatting';
//
//   void onConnect(StompFrame frame) {
//     stompClient!.subscribe(
//         destination: '/topic/message',
//         callback: (StompFrame frame) {
//           if (frame.body != null) {
//             Map<String, dynamic> obj = json.decode(frame.body!);
//             Msg message = Msg(content : obj['content'], uuid : obj['uuid']);
//             setState(() => {
//               list.add(message)
//             });
//           }
//         });
//   }
//
//   sendMessage(){
//     setState(() {
//       stompClient!.send(destination: '/app/message', body: json.encode({"content" : textEditingController.value.text}));
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.title),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Container(
//               height: MediaQuery.of(context).size.height * 0.8,
//               child: ListView.builder(
//                 shrinkWrap: true,
//                 itemBuilder: (context, postion){
//                   return GestureDetector(
//                     child: Card(
//                         child:
//                         Text(list[postion].content,
//                         )
//                     ),
//                   );
//                 },
//                 itemCount: list.length,
//               ),
//             ),
//             Container(
//                 decoration: BoxDecoration(
//                   border: Border.all(
//                     width: 1,
//                     color: Colors.grey,
//                   ),
//                 ),
//                 child: Row(
//                   children: <Widget>[
//                     Padding(
//                       padding: EdgeInsets.fromLTRB(20, 5, 20, 5) ,
//                       child:
//                       SizedBox(
//                           width: MediaQuery.of(context).size.width * 0.7,
//                           child: TextField(
//                             controller: textEditingController,
//                             style: TextStyle(color: Colors.black),
//                             keyboardType: TextInputType.text,
//                             decoration: InputDecoration(hintText: "Send Message"),
//                           )
//                       ),
//                     ),
//                     Padding(
//                       padding: EdgeInsets.all(0) ,
//                       child:
//                       SizedBox(
//                           width: MediaQuery.of(context).size.width * 0.15,
//                           height: MediaQuery.of(context).size.width * 0.1,
//                           child: ElevatedButton(
//                             onPressed: sendMessage, // 여기 사용된 sendMessage 함수는 차후 websocket 연결에서 다룹니다.
//                             child: Icon(Icons.send),
//                           )
//                       ),
//                     )
//                   ],
//                 )
//             )
//           ],
//         ),
//       ),
//     );
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     if (stompClient == null) {
//       stompClient = StompClient(
//           config: StompConfig.SockJS(
//             url: socketUrl,
//             onConnect: onConnect,
//             onWebSocketError: (dynamic error) => print(error.toString()),
//           ));
//       stompClient!.activate();
//     }
//   }
// }