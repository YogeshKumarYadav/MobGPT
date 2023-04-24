import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:mobgpt/constants/api_constants.dart';
import 'package:mobgpt/models/chat_model.dart';
import 'package:provider/provider.dart';
import '../models/models_model.dart';
import '../providers/chat_provider.dart';

class ApiService {
  static List<Map> allChats = [];

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
      log(message);
      allChats.add({"role": "user", "content": message});
      var response = await http.post(Uri.parse("$BASE_URL/chat/completions"),
          headers: {
            'Authorization': 'Bearer $API_KEY',
            "Content-Type": "application/json"
          },
          body: jsonEncode({"model": "gpt-3.5-turbo", "messages": allChats}));
      Map responsejson = jsonDecode(response.body);
      if (responsejson['error'] != null) {
        throw HttpException(responsejson['error']['message']);
      }
      allChats.add({
        "role": "assistant",
        "content": responsejson['choices'][0]['message']['content']
      });
      List<ChatModel> chatList = [];
      if (responsejson['choices'].length > 0) {
        log(responsejson['choices'][0]['message']['content']);
        chatList = List.generate(
            responsejson['choices'].length,
            (index) => ChatModel(
                content: responsejson['choices'][0]['message']['content'],
                role: "assistant"));
      }
      return chatList;
    } catch (e) {
      log("Error: $e");
      rethrow;
    }
  }
}
