import 'dart:core';
import 'package:flutter/cupertino.dart';
import 'package:mobgpt/models/models_model.dart';
import 'package:mobgpt/services/api_service.dart';

class ModelsProvider with ChangeNotifier {
  String model = "text-davinci-003";
  String get getmodel {
    return model;
  }

  void setCurrentModel(String newmodel) {
    model = newmodel;
    notifyListeners();
  }

  List<ModelsModel> modelslist = [];
  List<ModelsModel> get getmodelslist {
    return modelslist;
  }

  Future<List<ModelsModel>> getallmodels() async {
    modelslist = await ApiService.getModels();
    return modelslist;
  }
}
