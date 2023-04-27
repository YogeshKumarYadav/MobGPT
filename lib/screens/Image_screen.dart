import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:mobgpt/constants/constants.dart';
import 'package:mobgpt/services/api_service.dart';
import 'package:mobgpt/services/assets_manager.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mobgpt/widgets/chat_widget.dart';
import 'package:mobgpt/widgets/text_widget.dart';
import 'package:provider/provider.dart';
import '../models/chat_model.dart';
import '../providers/chat_provider.dart';
import '../providers/image_provider.dart';
import '../services/services.dart';
import '../widgets/image_widget.dart';

class ImageScreen extends StatefulWidget {
  const ImageScreen({super.key});
  @override
  State<ImageScreen> createState() => _ImageScreenState();
}

class _ImageScreenState extends State<ImageScreen> {
  bool _isTyping = false;
  String size = "1024x1024";
  List<String> sizeList = ['1024x1024', '512x512', '256x256'];
  late ScrollController listScrollController;
  late TextEditingController textEditingController;
  late FocusNode focusnode;

  @override
  void initState() {
    listScrollController = ScrollController();
    textEditingController = TextEditingController();
    focusnode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    listScrollController.dispose();
    textEditingController.dispose();
    focusnode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final imageprovider = Provider.of<AiImageProvider>(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(AssetsManager.openaiImage)),
        title: const Text("MobGPT - AI Image"),
        actions: [
          IconButton(
              onPressed: () async {
                await Services.showModeSheet(context: context);
              },
              icon: const Icon(
                Icons.more_vert_rounded,
                color: Colors.white,
              ))
        ],
      ),
      body: SafeArea(
          child: Column(
        children: [
          Flexible(
            child: ListView.builder(
                controller: listScrollController,
                itemCount: imageprovider.getImageList.length,
                itemBuilder: (context, index) {
                  return ImageWidget(
                      role: imageprovider.getImageList[index].role,
                      content:
                          imageprovider.getImageList[index].content.toString());
                }),
          ),
          if (_isTyping) ...[
            const SpinKitThreeBounce(color: Colors.white70, size: 18),
          ],
          const SizedBox(
            height: 15,
          ),
          Material(
              color: cardColor,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                child: Row(
                  children: [
                    Expanded(
                        child: TextField(
                      focusNode: focusnode,
                      style: const TextStyle(color: Colors.white),
                      controller: textEditingController,
                      onSubmitted: (value) async {
                        await sendInst(imageprovider: imageprovider);
                      },
                      decoration: const InputDecoration.collapsed(
                          hintText: "How can I help you!",
                          hintStyle: TextStyle(color: Colors.white38)),
                    )),
                    DropdownButton(
                      dropdownColor: scaffoldBackgroundColor,
                      iconEnabledColor: Colors.white,
                      items: List<DropdownMenuItem<Object?>>.generate(
                          sizeList.length,
                          (index) => DropdownMenuItem(
                                value: sizeList[index],
                                child: Text(sizeList[index],
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 15)),
                              )),
                      value: size,
                      onChanged: (value) {
                        setState(() {
                          size = value.toString();
                        });
                      },
                    ),
                    IconButton(
                        onPressed: () async {
                          await sendInst(imageprovider: imageprovider);
                        },
                        icon: const Icon(
                          Icons.send,
                          color: Colors.white,
                        )),
                  ],
                ),
              ))
        ],
      )),
    );
  }

  void scrollToEnd() {
    listScrollController.animateTo(
        listScrollController.position.maxScrollExtent,
        duration: const Duration(seconds: 2),
        curve: Curves.easeOut);
  }

  Future<void> sendInst({required AiImageProvider imageprovider}) async {
    if (textEditingController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: TextWidget(
          label: "Please type a message",
        ),
        backgroundColor: Colors.red,
      ));
      return;
    }
    if (_isTyping) {
      return;
    }
    try {
      final msg = textEditingController.text;
      setState(() {
        _isTyping = true;
        imageprovider.addUserInstruction(message: msg);
        textEditingController.clear();
        focusnode.unfocus();
      });
      await imageprovider.sendImgRequest(
        message: msg, size: size
      );
    } catch (e) {
      log("Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: TextWidget(
          label: e.toString(),
        ),
        backgroundColor: Colors.red,
      ));
    } finally {
      setState(() {
        scrollToEnd();
        _isTyping = false;
      });
    }
  }
}
