import 'package:bobfriend/screen/board/board.dart';
import 'package:bobfriend/screen/board/board_write.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bobfriend/provider/board.dart';

class BoardView extends StatefulWidget{
  const BoardView({super.key});
  static const routeName = '/extractArguments';

  @override
  BoardViewState createState()=>BoardViewState();
}
class BoardViewState extends State<BoardView>{
  @override
  Widget build(BuildContext context){
    final args = ModalRoute.of(context)!.settings.arguments as Arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Hello"
          // args.author.toString()
        ),
      ),
    );
  }
}