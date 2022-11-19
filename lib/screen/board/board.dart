import 'package:bobfriend/screen/board/board_write.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bobfriend/Model/board.dart';
import 'package:bobfriend/screen/board/board_view.dart';
import 'package:intl/intl.dart';
//firebase data get
class FireService{
  static final FireService _fireService = FireService._internal();
  factory FireService() => _fireService;
  FireService._internal();
  Future<List<BoardModel>> getFireModels() async{
    CollectionReference<Map<String, dynamic>> _collectionReference =
    FirebaseFirestore.instance.collection('board');
    QuerySnapshot<Map<String, dynamic>> querySnapshot =
    await _collectionReference.orderBy('date', descending: true).get();
    List<BoardModel> list = [];
    for(var doc in querySnapshot.docs){
      BoardModel boardModel = BoardModel.fromQuerySnapshot(doc);
      list.add(boardModel);
    }
    return list;
  }
}
//push board view argument
class Arguments {
  final String? author;
  var date;
  final String? content;
  Arguments(this.author, this.date, this.content);
}

String formatTimestamp(DateTime timestamp){
  DateTime now = DateTime.now();
  DateFormat formatter = DateFormat('yyyy-MM-dd');
  String strNow = formatter.format(now);
  String strBoard = formatter.format(timestamp);
  return strBoard;
}
class BoardListScreen extends StatefulWidget{
  const BoardListScreen({super.key});

  @override
  BoardListScreenState createState() => BoardListScreenState();
}
//board list
class BoardListScreenState extends State<BoardListScreen>{

  @override
  Widget build(BuildContext context){

    return Scaffold(
      appBar: AppBar(
        title: const Text('커뮤니티', style: TextStyle(color: Colors.black),),
        centerTitle: true,
        elevation: 1,
        actions: [
          IconButton(onPressed: (){},
          icon: Icon(Icons.search))
        ],
      ),
      body:
      FutureBuilder<List<BoardModel>>(
        future: FireService().getFireModels(),
        builder: (context,snapshot){
          if(snapshot.hasData){
            List<BoardModel> datas = snapshot.data!;
            return ListView.builder(
                itemCount: datas.length,
                itemBuilder: (BuildContext context, int index){
                  BoardModel data = datas[index];
                  return Card(
                      child: ListTile(
                        title: Text("${data.author}"),
                        trailing: Text("${formatTimestamp((data.date)!.toDate())}"),
                        subtitle: Text("${data.content}"),
                        onTap: ()=> Navigator.pushNamed(
                          context,
                          BoardView.routeName,
                          arguments: Arguments(data.author, (data.date)!.toDate(), data.content),
                          ),
                        ),
                      );
                });
          }
          else{
            return const Center(child: CircularProgressIndicator(color: Colors.black,),);
          }
        },
      ),


      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.greenAccent,
        onPressed: (){
          Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => BoardWriteScreen()))
              .then((value){
            setState(() {
            });
          });
        },
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}