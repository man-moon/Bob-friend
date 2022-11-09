import 'package:cloud_firestore/cloud_firestore.dart';
class dmListModel{
  String? opponent;
  Timestamp? date;
  String? recentDm;
  dmListModel({
    this.opponent,
    this.recentDm,
    this.date
  });
}