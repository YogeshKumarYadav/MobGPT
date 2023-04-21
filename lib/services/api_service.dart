import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:mobgpt/constants/api_constants.dart';
import 'package:mobgpt/models/chat_model.dart';

import '../models/models_model.dart';

class ApiService {
  static Future<List<ModelsModel>> getModels() async {
    try {
      var response = await http.get(Uri.parse("$BASE_URL/models"),
          headers: {'Authorization': 'Bearer $API_KEY'});
      Map responsejson = jsonDecode(response.body);
      if (responsejson['error'] != null) {
        throw HttpException(responsejson['error']['message']);
      }
      return ModelsModel.modelsResp(responsejson['data']);
    } catch (e) {
      log("Error: $e");
      rethrow;
    }
  }

  static Future<List<ChatModel>> sendMessage({
    required String message,
    required String model,
  }) async {
    try {
      var response = await http.post(Uri.parse("$BASE_URL/completions"),
          headers: {
            'Authorization': 'Bearer $API_KEY',
            "Content-Type": "application/json"
          },
          body: jsonEncode({
            "model": model,
            "prompt": message,
            "max_tokens": 4000,
          }));
      Map responsejson = jsonDecode(response.body);
      if (responsejson['error'] != null) {
        throw HttpException(responsejson['error']['message']);
      }

      List<ChatModel> chatList = [];
      if (responsejson['choices'].length > 0) {
        log(responsejson['choices'][0]['text']);
        chatList = List.generate(responsejson['choices'].length, (index) => ChatModel(message: responsejson['choices'][0]['text'], chatIndex: 1));
      }
      return chatList;
    } catch (e) {
      log("Error: $e");
      rethrow;
    }
  }
}
