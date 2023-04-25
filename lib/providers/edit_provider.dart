import 'package:flutter/material.dart';
import 'package:mobgpt/models/chat_model.dart';
import 'package:mobgpt/services/api_service.dart';
import '../models/edit_model.dart';

class EditProvider with ChangeNotifier {
  List<EditModel> editlist = [];
  List<EditModel> get getEditList {
    return editlist;
  }

  void addUserChat({required String message, required String instruction}) {
    editlist.add(EditModel(role: "user", input: message, instruction: instruction));
    notifyListeners();
  }

  Future<void> sendMessage({required String message, required String instruction}) async {
    editlist.addAll(await ApiService.sendEditMessage(message: message, instruction: instruction));
    notifyListeners();
  }
}
