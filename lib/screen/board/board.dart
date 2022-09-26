import 'package:bobfriend/screen/board/board_write.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bobfriend/provider/board.dart';

class FireService{
  static final FireService _fireService = FireService._internal();
  factory FireService() => _fireService;
  FireService._internal();
  Future<List<BoardModel>> getFireModels() async{
    CollectionReference<Map<String, dynamic>> _collectionReference =
    FirebaseFirestore.instance.collection('board');
    QuerySnapshot<Map<String, dynamic>> querySnapshot =
    await _collectionReference.orderBy('date').get();
    List<BoardModel> list = [];
    for(var doc in querySnapshot.docs){
      BoardModel boardModel = BoardModel.fromQuerySnapshot(doc);
      list.add(boardModel);
    }
    return list;
  }
}
class BoardListScreen extends StatefulWidget{
  const BoardListScreen({super.key});

  @override
  BoardListScreenState createState() => BoardListScreenState();
}

class BoardListScreenState extends State<BoardListScreen>{

  @override
  Widget build(BuildContext context){

    return Scaffold(
      appBar: AppBar(
        title: const Text("게시판", style: TextStyle(color: Colors.black),),
        centerTitle: true,
        elevation: 0.0,
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
                        trailing: Text("${(data.date)!.toDate()}"),
                        subtitle: Text("${data.content}"),
                      ));
                });
          }
          else{
            return const Center(child: CircularProgressIndicator(color: Colors.black,),);
          }
        },
      ),


      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => BoardWriteScreen()))
              .then((value){
            setState(() {
            });
          });
        },
        child: Text('글쓰기'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}