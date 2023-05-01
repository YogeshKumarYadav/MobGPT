import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mobgpt/models/audio_model.dart';
import 'package:mobgpt/models/chat_model.dart';
import 'package:mobgpt/services/api_service.dart';

class AudioProvider with ChangeNotifier {
  List<AudioModel> audiolist = [];
  List<AudioModel> get getAudioList {
    return audiolist;
  }

  void addUserAudio({required String message}) {
    audiolist.add(AudioModel(role: "user", content: message));
    notifyListeners();
  }

  Future<void> sendAudio({required String message}) async {
    audiolist.addAll(await ApiService.sendAudio(fileName: message));
    notifyListeners();
  }
}
