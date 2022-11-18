import 'package:bobfriend/Model/board.dart';
import 'package:bobfriend/provider/user.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class BoardView extends StatefulWidget {
  BoardView(this.ref, {super.key});

  final dynamic ref;

  @override
  BoardViewState createState() => BoardViewState();
}

class BoardViewState extends State<BoardView> {
  BoardModel boardModel = new BoardModel();
  List<CommentModel> commentList = [];
  List<dynamic> likeList=[];
  var comment='';
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  final commentController = TextEditingController();
  final commentFocusNode = FocusNode();
  String profileImageURL="";
  String dateForm = "";
  bool isAnonymous = false;
  bool isLike =false;
  UserProvider userProvider = new UserProvider();
  void deleteBoard() async {
    await (widget.ref).delete();
  }
  void getBoard() async {
    likeList = [];
    boardModel = BoardModel();
    await (widget.ref).get().then((DocumentSnapshot<Map<String, dynamic>> ds) {
      setState(() {
        BoardModel tmpBoard = BoardModel.fromSnapShot(ds);
        boardModel = tmpBoard;
        dateForm =
            new DateFormat("yy/MM/dd HH:mm").format(boardModel.date!.toDate());
        likeList = tmpBoard.likeCnt!;
        if(likeList.contains(FirebaseAuth.instance.currentUser!.uid)==true){
          isLike=true;
        }
        else {
          isLike=false;
        }
      });
    });
    if (boardModel.author != "익명") {
      await FirebaseFirestore.instance
          .collection('user')
          .doc(boardModel.userId)
          .get()
          .then((DocumentSnapshot<Map<String, dynamic>> ds) {
        setState(() {
          profileImageURL = ds.data()!['profile_image'];
        });
      });
    }
  }
  void commentAdd() async{
    String? author = isAnonymous ? "익명" : userProvider.nickname;
    await (widget.ref).collection('comment').add(
      {
        'content': comment,
        'userId': FirebaseAuth.instance.currentUser!.uid,
        'author': author,
        'date': Timestamp.now()
      }
    );
    widget.ref.update({
      'commentCnt': FieldValue.increment(1)
    });
    setState(() {
      comment='';
    });
    commentController.clear();
    commentGet();
  }
  void commentGet() async{
    commentList = [];
    var tmpRef = await (widget.ref).collection('comment').orderBy('date', descending: false).get();
    for(int i=0; i<tmpRef.docs.length;i++){
      CommentModel tmpModel = new CommentModel();
      tmpModel.content = tmpRef.docs[i].data()!['content'];
      tmpModel.date = tmpRef.docs[i].data()!['date'];
      tmpModel.userId = tmpRef.docs[i].data()!['userId'];
      tmpModel.author = tmpRef.docs[i].data()!['author'];
      commentList.add(tmpModel);
    }
    setState(() {
      commentList = commentList;
    });
  }
  Widget buildCommentList(String author, Timestamp date, String content){
    String commentDate =
        new DateFormat("yy/MM/dd HH:mm").format(date.toDate());
    return Column(children: [
      ListTile(
        dense: true,
      visualDensity: VisualDensity(vertical: -3),
      title: Text(author),
      subtitle: Text(content),
      trailing: Text(commentDate,style: TextStyle(color: Colors.grey,fontSize: 10),),
      ),
      const Divider(
        thickness: 1,
      )
    ]);
  }
  void likeAdd()async{
    await (widget.ref).update({
      'likeCnt' : FieldValue.arrayUnion([FirebaseAuth.instance.currentUser!.uid])
    });
    setState(() {
      likeList.add(FirebaseAuth.instance.currentUser!.uid);
      isLike = true;
    });
  }
  void likeRemove() async{
    await (widget.ref).update({
      'likeCnt' : FieldValue.arrayRemove([FirebaseAuth.instance.currentUser!.uid])
    });
    setState(() {
      likeList.remove(FirebaseAuth.instance.currentUser!.uid);
      isLike = false;
    });
  }
  @override
  void initState() {
    userProvider = Provider.of<UserProvider>(context, listen: false);
    getBoard();
    commentGet();
    super.initState();
  }

  @override
  void dispose() {
    commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          actions: boardModel.userId == FirebaseAuth.instance.currentUser!.uid
              ? <Widget>[
                  IconButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                                  title: const Text("게시물 삭제"),
                                  content: const Text("게시물을 삭제할까요?"),
                                  actions: [
                                    OutlinedButton(
                                        onPressed: () {
                                          deleteBoard();
                                          Navigator.pop(context);
                                          Navigator.pop(context);
                                        },
                                        child: Text(
                                          "삭제",
                                          style: TextStyle(color: Colors.black),
                                        )),
                                    OutlinedButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text(
                                          "취소",
                                          style: TextStyle(color: Colors.black),
                                        ))
                                  ],
                                ));
                      },
                      icon: const Icon(Icons.more_vert_outlined))
                ]
              : null,
        ),
        body: Stack(
          children: [
            GestureDetector(
              onTap: () {
                commentFocusNode.unfocus();
              },
              child: RefreshIndicator(
                onRefresh: () async {
                  getBoard();
                  commentGet();
                  return Future<void>.delayed(const Duration(seconds: 1));
                },
                child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.all(8),
                  child: Column(
                    children: [
                      ListTile(
                        leading: CircleAvatar(
                            backgroundColor: Colors.transparent,
                            child: boardModel.author != "익명"
                                ? CachedNetworkImage(
                                    imageUrl: profileImageURL!,
                                    imageBuilder: (context, imageProvider) =>
                                        Container(
                                      width: 30,
                                      height: 30,
                                      decoration: BoxDecoration(
                                        boxShadow: const [
                                          BoxShadow(
                                            color: Colors.grey,
                                            blurRadius: 1,
                                            spreadRadius: 1,
                                          )
                                        ],
                                        shape: BoxShape.rectangle,
                                        borderRadius: BorderRadius.circular(1),
                                        image: DecorationImage(
                                          image: imageProvider,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    errorWidget: (context, url, error) =>
                                        const Icon(Icons.person_rounded),
                                  )
                                : Icon(Icons.person)),
                        title: Text("${boardModel.author}"),
                        subtitle: Text(dateForm),
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 20, top: 5),
                        width: double.infinity,
                        child: Text(
                          "${boardModel.content}",
                          style: TextStyle(color: Colors.black, fontSize: 15),
                        ),
                      ),
                      Padding(
                          padding: EdgeInsets.only(top: 10),
                          child: Row(
                            children: [
                              Padding(
                                  padding: EdgeInsets.only(left: 20, right: 5),
                                  child: Icon(
                                    Icons.thumb_up_alt_outlined,
                                    size: 15,
                                  )),
                              Text("${boardModel.likeCnt?.length}"),
                              Padding(
                                  padding: EdgeInsets.only(left: 10, right: 5),
                                  child: Icon(
                                    Icons.comment,
                                    size: 15,
                                  )),
                              Text("${commentList.length}")
                            ],
                          )),
                      Padding(
                        padding: EdgeInsets.only(top: 10, left: 20),
                        child: Row(
                          children: [
                            OutlinedButton(
                              onPressed: () {
                                isLike?likeRemove():likeAdd();
                              },
                              child: Row(
                                children: [
                                  Icon(Icons.thumb_up_alt_outlined,
                                      size: 15, color: Colors.grey),
                                  Text(
                                    "좋아요",
                                    style: TextStyle(color: Colors.grey),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      const Divider(
                        thickness: 1,
                      ),
                      commentList.isEmpty?Container():
                      Column(
                        children:[
                          for(int i=0;i<commentList.length;i++)
                            buildCommentList(commentList[i].author!, commentList[i].date!,commentList[i].content!)
                          ]
                      )
                    ],
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                padding: EdgeInsets.fromLTRB(10, 0, 0, 12),
                child: Row(
                  children: [
                    Row(children: [
                      Container(
                          width: 20,
                          child: Checkbox(
                            value: isAnonymous,
                            onChanged: (value) {
                              setState(() {
                                isAnonymous = value!;
                              });
                            },
                          )),
                      Padding(padding: EdgeInsets.only(left: 5, right: 5),child: const Text("익명"))
                    ]),
                    Expanded(
                      child: TextField(
                        cursorColor: Colors.black,
                        focusNode: commentFocusNode,
                        maxLines: null,
                        controller: commentController,
                        decoration: const InputDecoration(
                            hintStyle: TextStyle(color: Colors.grey),
                            hintText: "댓글을 입력하세요."),
                        onChanged: (value) {
                          setState(() {
                            comment = value;
                          });
                        },
                      ),
                    ),
                    IconButton(
                      onPressed:
                        comment.trim().isEmpty ? null : commentAdd,
                      icon: const Icon(Icons.send_rounded),
                      color: Colors.orangeAccent,
                    )
                  ],
                ),
              ),
            )
          ],
        ));
  }
}
