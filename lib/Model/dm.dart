import 'package:cloud_firestore/cloud_firestore.dart';
class dmListModel{
  String? opponent;
  Timestamp? date;
  String? recentDm;
  String? profileImageLink;
  DocumentReference<Map<String,dynamic>>? ref;
  dmListModel({
    this.opponent,
    this.recentDm,
    this.date,
    this.profileImageLink,
    this.ref
  });
}
class postModel{
  String? sender;
  Timestamp? date;
  String? text;
  String? userId;
  postModel({
    this.sender,
    this.date,
    this.text,
    this.userId
  });
}