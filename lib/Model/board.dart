import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
class BoardModel{
  String? author;
  String? content;
  Timestamp? date;
  DocumentReference? reference;
  BoardModel({
    this.author,
    this.content,
    this.date,
    this.reference
});
  BoardModel.fromJson(dynamic json, this.reference){
    author = json['author'];
    content = json['content'];
    date = json['date'];
  }
  BoardModel.fromSnapShot(DocumentSnapshot<Map<String, dynamic>> snapshot)
  : this.fromJson(snapshot.data(), snapshot.reference);
  BoardModel.fromQuerySnapshot(
      QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
  :this.fromJson(snapshot.data(), snapshot.reference);
  Map<String, dynamic> toJson(){
    final map = <String, dynamic>{};
    map['author']=author;
    map['content']=content;
    map['date']=date;
    return map;
  }
}