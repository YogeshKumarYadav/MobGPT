import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:mobgpt/constants/api_constants.dart';
import 'package:mobgpt/models/audio_model.dart';
import 'package:mobgpt/models/chat_model.dart';
import 'package:provider/provider.dart';
import '../models/edit_model.dart';
import '../models/image_model.dart';
import '../providers/chat_provider.dart';

class ApiService {
  static List<Map> allChats = [];

  static Future<List<ChatModel>> sendMessage({
    required String message,
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
        "content": utf8convert(responsejson['choices'][0]['message']['content'])
      });
      List<ChatModel> chatList = [];
      if (responsejson['choices'].length > 0) {
        log(utf8convert(responsejson['choices'][0]['message']['content']));
        chatList = List.generate(
            responsejson['choices'].length,
            (index) => ChatModel(
                content: utf8convert(
                    responsejson['choices'][0]['message']['content']),
                role: "assistant"));
      }
      return chatList;
    } catch (e) {
      log("Error: $e");
      rethrow;
    }
  }

  static Future<List<EditModel>> sendEditMessage(
      {required String message, required String instruction}) async {
    try {
      log(message);
      var response = await http.post(Uri.parse("$BASE_URL/edits"),
          headers: {
            'Authorization': 'Bearer $API_KEY',
            "Content-Type": "application/json"
          },
          body: jsonEncode({
            "model": "text-davinci-edit-001",
            "input": message,
            "instruction": instruction
          }));
      Map responsejson = jsonDecode(response.body);
      if (responsejson['error'] != null) {
        throw HttpException(responsejson['error']['message']);
      }
      List<EditModel> editList = [];
      if (responsejson['choices'].length > 0) {
        log(utf8convert(responsejson['choices'][0]['text']));
        editList = List.generate(
            responsejson['choices'].length,
            (index) => EditModel(
                instruction: instruction,
                input: utf8convert(responsejson['choices'][0]['text']),
                role: "assistant"));
      }
      return editList;
    } catch (e) {
      log("Error: $e");
      rethrow;
    }
  }

  static Future<List<ImageModel>> sendImageRequest(
      {required String message, required String size}) async {
    try {
      log(message);
      var response = await http.post(Uri.parse("$BASE_URL/images/generations"),
          headers: {
            'Authorization': 'Bearer $API_KEY',
            "Content-Type": "application/json"
          },
          body: jsonEncode({"prompt": message, "n": 1, "size": size}));
      Map responsejson = jsonDecode(response.body);
      if (responsejson['error'] != null) {
        throw HttpException(responsejson['error']['message']);
      }
      List<ImageModel> imageList = [];
      if (responsejson['data'].length > 0) {
        log(responsejson['data'][0]['url']);
        imageList = List.generate(
            responsejson['data'].length,
            (index) => ImageModel(
                content: responsejson['data'][index]['url'],
                role: "assistant"));
      }
      return imageList;
    } catch (e) {
      log("Error: $e");
      rethrow;
    }
  }

  static Future<List<AudioModel>> sendAudio({
    required String fileName,
  }) async {
    try {
      log(fileName);
      var request = http.MultipartRequest(
          'POST', Uri.parse('https://api.openai.com/v1/audio/transcriptions'));
      request.fields.addAll({'model': 'whisper-1'});
      request.files.add(await http.MultipartFile.fromPath(
          'file', fileName));
      request.headers.addAll({'Authorization': 'Bearer $API_KEY'});

      http.StreamedResponse streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);
      Map responsejson = jsonDecode(response.body);
      log(responsejson.toString());
      if (responsejson['error'] != null) {
        throw HttpException(responsejson['error']['message']);
      }
      List<AudioModel> audioList = [];
      log(utf8convert(responsejson['text']));
      audioList = [
        AudioModel(
            content: utf8convert(responsejson['text']), role: "assistant")
      ];
      return audioList;
    } catch (e) {
      log("Error: $e");
      rethrow;
    }
  }

  static String utf8convert(String text) {
    List<int> bytes = text.toString().codeUnits;
    return utf8.decode(bytes);
  }
}
