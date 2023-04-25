import 'dart:core';
import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:mobgpt/services/api_service.dart';

class ModesProvider with ChangeNotifier {
  String model = "Chat Converastion";
  String get getmodel {
    return model;
  }

  void setCurrentMode(String newmodel) {
    model = newmodel;
    notifyListeners();
  }
}
