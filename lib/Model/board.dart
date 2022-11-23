import 'package:cloud_firestore/cloud_firestore.dart';

class BoardModel {
  String? author;
  String? content;
  String? userId;
  List<dynamic>? likeCnt;
  int? commentCnt;
  Timestamp? date;
  DocumentReference? reference;
  List<String>? imageLink;

  BoardModel(
      {this.author,
      this.content,
      this.date,
      this.userId,
      this.likeCnt,
      this.commentCnt,
      this.reference,
      this.imageLink});

  BoardModel.fromJson(dynamic json, this.reference) {
    author = json['author'];
    content = json['content'];
    date = json['date'];
    userId = json['userId'];
    likeCnt = json['likeCnt'];
    commentCnt = json['commentCnt'];
    imageLink = json['imageLink'];
  }

  BoardModel.fromSnapShot(DocumentSnapshot<Map<String, dynamic>> snapshot)
      : this.fromJson(snapshot.data(), snapshot.reference);

  BoardModel.fromQuerySnapshot(
      QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : this.fromJson(snapshot.data(), snapshot.reference);

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['author'] = author;
    map['content'] = content;
    map['date'] = date;
    map['userId'] = userId;
    map['likeCnt'] = likeCnt;
    map['commentCnt'] = commentCnt;
    return map;
  }
}

class CommentModel {
  String? author;
  String? userId;
  Timestamp? date;
  String? content;

  CommentModel({this.author, this.userId, this.date, this.content});
}
