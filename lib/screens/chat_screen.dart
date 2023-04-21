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
import '../providers/models_providers.dart';
import '../services/services.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

List<ChatModel> chatlist = [];

class _ChatScreenState extends State<ChatScreen> {
  bool _isTyping = false;
  late TextEditingController? textEditingController;
  late FocusNode focusnode;

  @override
  void initState() {
    textEditingController = TextEditingController();
    focusnode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    textEditingController!.dispose();
    focusnode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final curprovider = Provider.of<ModelsProvider>(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(AssetsManager.openaiImage)),
        title: const Text("MobGPT"),
        actions: [
          IconButton(
              onPressed: () async {
                await Services.showModelSheet(context: context);
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
                itemCount: chatlist.length,
                itemBuilder: (context, index) {
                  return ChatWidget(
                    message: chatlist[index].message.toString(),
                    index: chatlist[index].chatIndex,
                  );
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
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                        child: TextField(
                      focusNode: focusnode,
                      style: const TextStyle(color: Colors.white),
                      controller: textEditingController,
                      onSubmitted: (value) async {
                        await sendMSG(curprovider: curprovider);
                      },
                      decoration: const InputDecoration.collapsed(
                          hintText: "How can I help you!",
                          hintStyle: TextStyle(color: Colors.white)),
                    )),
                    IconButton(
                        onPressed: () async {
                          await sendMSG(curprovider: curprovider);
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

  Future<void> sendMSG({required ModelsProvider curprovider}) async {
    try {
      setState(() {
        _isTyping = true;
        chatlist
            .add(ChatModel(message: textEditingController!.text, chatIndex: 0));
        textEditingController?.clear();
        focusnode.unfocus();
      });
      chatlist.addAll(await ApiService.sendMessage(
          message: textEditingController!.text, model: curprovider.getmodel));
    } catch (e) {
      log("Error: $e");
    } finally {
      setState(() {
        _isTyping = false;
      });
    }
  }
}
