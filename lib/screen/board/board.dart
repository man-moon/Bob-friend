import 'package:bobfriend/screen/board/board_write.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bobfriend/Model/board.dart';
import 'package:bobfriend/screen/board/board_view.dart';
import 'package:intl/intl.dart';

//firebase data get
/*class FireService {
  static final FireService _fireService = FireService._internal();

  factory FireService() => _fireService;

  FireService._internal();

  Future<void> getFireModels() async {
    boardList.clear();
    CollectionReference<Map<String, dynamic>> _collectionReference =
        FirebaseFirestore.instance.collection('board');
    QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await _collectionReference.orderBy('date', descending: true).get();
    for (var doc in querySnapshot.docs) {
      BoardModel boardModel = BoardModel.fromQuerySnapshot(doc);
      boardList.add(boardModel);
    }
  }
}*/

String formatTimestamp(DateTime timestamp) {
  DateTime now = DateTime.now();
  Duration diff = now.difference(timestamp);
  String stdDate = "";
  if (diff.inSeconds < 60) {
    stdDate = "${diff.inSeconds}초 전";
  } else if (diff.inSeconds > 60 && diff.inHours < 1) {
    stdDate = "${(diff.inSeconds / 60).floor()}분 전";
  } else if (diff.inHours < 24) {
    stdDate = "${diff.inHours}시간 전";
  } else if (diff.inDays < 30) {
    stdDate = "${diff.inDays}일 전";
  } else if (diff.inDays < 365) {
    stdDate = "${diff.inDays / 30}달 전";
  } else {
    stdDate = "${diff.inDays / 365}년 전";
  }
  return stdDate;
}

class BoardListScreen extends StatefulWidget {
  const BoardListScreen({super.key});

  @override
  BoardListScreenState createState() => BoardListScreenState();
}

//board list
class BoardListScreenState extends State<BoardListScreen> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  List<BoardModel> boardList = [];

  void getBoard() async {
    boardList = [];
    final tmpRef = FirebaseFirestore.instance.collection('board');
    QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await tmpRef.orderBy('date', descending: true).get();
    for (var doc in querySnapshot.docs) {
      BoardModel boardModel = BoardModel.fromQuerySnapshot(doc);
      boardList.add(boardModel);
    }
    setState(() {
      boardList = boardList;
    });
  }
  @override
  void initState() {
    super.initState();
    //FireService().getFireModels();
    getBoard();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "게시판",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        elevation: 1,
        actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.search))],
      ),
      body: RefreshIndicator(
          key: _refreshIndicatorKey,
          onRefresh: () async {
            getBoard();
            return Future<void>.delayed(const Duration(seconds: 1));
          },
          child: ListView.builder(
              itemCount: boardList.length,
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  elevation: 0,
                  child: ListTile(
                    title: Text("${boardList[index].author}"),
                    trailing:
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Expanded(
                          flex: 3,
                          child: Text(
                              formatTimestamp(
                                  (boardList[index].date)!.toDate()),
                              style: const TextStyle(color: Colors.grey)),
                        ),
                        Expanded(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Row(mainAxisSize: MainAxisSize.min, children: [
                                  Container(
                                    padding: const EdgeInsets.all(2),
                                    child: const Icon(Icons.thumb_up_alt_outlined,
                                        size: 15),
                                  ),
                                  Text("${boardList[index].likeCnt?.length}"),
                                ]),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(2),
                                      child: const Icon(Icons.comment, size: 15),
                                    ),
                                    Text("${boardList[index].commentCnt}"),
                                  ],
                                )
                              ],
                            )),
                      ],
                    ),
                    subtitle: Text(
                      "${boardList[index].content}",
                      style: const TextStyle(color: Colors.grey),
                    ),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  BoardView(boardList[index].reference))).then((value) {
                        setState(() {
                          getBoard();
                        });
                      });
                    },
                  ),
                );
              })),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
                  MaterialPageRoute(builder: (context) => BoardWriteScreen()))
              .then((value) {
            setState(() {
              getBoard();
            });
          });
        },
        child: const Text('글쓰기'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
