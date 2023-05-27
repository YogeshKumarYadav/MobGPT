import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:mobgpt/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/constants.dart';
import '../widgets/dropdown_widget.dart';
import '../widgets/text_widget.dart';

class Services {
  static Future<void> showModeSheet({required BuildContext context}) async {
    await showModalBottomSheet(
        backgroundColor: scaffoldBackgroundColor,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
        context: context,
        builder: (context) {
          return Padding(
              padding: const EdgeInsets.all(18.0),
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.black,
                      elevation: 2,
                      shadowColor: Colors.grey,
                    ),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return UpdateAPIWidget();
                        },
                      );
                    },
                    child: const Text("Change API",
                        style: TextStyle(fontSize: 15, color: Colors.white)))
              ]));
        });
  }
}

class UpdateAPIWidget extends StatelessWidget {
  static var textEditingController = TextEditingController();
  static var focusnode = FocusNode();

  const UpdateAPIWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Container(
        color: scaffoldBackgroundColor,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              focusNode: focusnode,
              style: const TextStyle(color: Colors.white),
              controller: textEditingController,
              onSubmitted: (value) {
                ApiService.checkAPI(api: textEditingController.text).then((value) => {
                  if (value == true) {
                    set_api_key(textEditingController.text),
                    ApiService.updateAPI(new_API: textEditingController.text),
                    Navigator.pop(context)
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: TextWidget(
                        label: "This API key either Invalid or Expired!!!",
                      ),
                      backgroundColor: Colors.red,
                    ))
                  },
                  textEditingController.clear(),
                });   
              },
              decoration: const InputDecoration.collapsed(
                hintText: "New API key",
                hintStyle: TextStyle(color: Colors.white38)
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                ApiService.checkAPI(api: textEditingController.text).then((value) => {
                  if (value == true) {
                    set_api_key(textEditingController.text),
                    ApiService.updateAPI(new_API: textEditingController.text),
                    Navigator.pop(context)
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: TextWidget(
                        label: "This API key either Invalid or Expired!!!",
                      ),
                      backgroundColor: Colors.red,
                    ))
                  },
                  textEditingController.clear(),
                });
              },
              child: const Text('Update',
                  style: TextStyle(color: Colors.white, fontSize: 15)),
            ),
          ],
        ),
      ),
    );
  }

  void set_api_key(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('api_key', key);
  }
}
