import 'package:flutter/material.dart';
import 'package:mobgpt/models/chat_model.dart';
import 'package:mobgpt/services/api_service.dart';

import '../models/image_model.dart';

class AiImageProvider with ChangeNotifier {
  List<ImageModel> imagelist = [];
  List<ImageModel> get getImageList {
    return imagelist;
  }

  void addUserInstruction({required String message}) {
    imagelist.add(ImageModel(role: "user", content: message));
    notifyListeners();
  }

  Future<void> sendImgRequest({required String message, required String size}) async {
    imagelist.addAll(await ApiService.sendImageRequest(message: message, size: size));
    notifyListeners();
  }
}
