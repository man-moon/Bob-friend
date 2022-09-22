import 'package:flutter/material.dart';

class JoinedChatRoomListProvider extends ChangeNotifier{
  List<String?> _joinedChatList = [];

  List<String?> get joinedChatList => _joinedChatList;

  set joinedChatList(List<String?> value) {
    _joinedChatList = value;
    notifyListeners();
  }
}