import 'package:bobfriend/screen/friend/pm_write.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../Model/dm.dart';
import '../profile/profile.dart';

class postMessage extends StatefulWidget {
  postMessage(this.ref, this.opponent, this.opponentId, {Key? key}) : super(key: key);
  final dynamic ref;
  String? opponent;
  String? opponentId;
  @override
  State<postMessage> createState() => _postMessageState();
}
class _postMessageState extends State<postMessage>{
  List<postModel> postList=[];
  void getDm() async {
    postList.clear();
    var tmpRef = await (widget.ref).collection('message').orderBy('date',descending: true).get();
    for(int i=0;i<tmpRef.size;i++){
      postModel tmpModel = new postModel();
      tmpModel.sender = tmpRef.docs[i].data()!['sender'];
      tmpModel.date = tmpRef.docs[i].data()!['date'];
      tmpModel.text = tmpRef.docs[i].data()!['text'];
      postList.add(tmpModel);
    }
    setState(() {
      postList = postList;
    });
  }
  String formatTimestamp(DateTime timestamp){
    DateTime now = DateTime.now();
    DateFormat formatter = DateFormat('yyyy-MM-dd');
    String strNow = formatter.format(now);
    String strTime = formatter.format(timestamp);
    return strTime;
  }
  @override
  void initState() {
    getDm();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: (){
            Navigator.pop(context);
          },
        ),
        title: Text(widget.opponent!),
        actions: [
          IconButton(onPressed: (){
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ProfileScreen(
                      uid: widget.opponentId,
                    )));
          }, icon: const Icon(Icons.person),),
          IconButton(onPressed: (){
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => pmWriteScreen(
                        widget.ref))).then((value){
              setState(() {
                getDm();
              });
            });
          },
              icon: const Icon(Icons.send)
          )
        ],
      ),
      body: ListView.builder(
          itemCount: postList.length,
          itemBuilder: (BuildContext context, int index){
            return Card(
              elevation: 0,
              child: ListTile(
                title: Text(postList[index].sender!),
                trailing: Text(formatTimestamp(postList[index].date!.toDate())),
                subtitle: Text(postList[index].text!),
              ),
            );
          })
    );
  }
}
