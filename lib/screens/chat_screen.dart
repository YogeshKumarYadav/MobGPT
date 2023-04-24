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
import '../providers/models_providers.dart';
import '../services/services.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

// List<ChatModel> chatlist = [];

class _ChatScreenState extends State<ChatScreen> {
  bool _isTyping = false;
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
    final curprovider = Provider.of<ModelsProvider>(context);
    final chatprovider = Provider.of<ChatProvider>(context);

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
                controller: listScrollController,
                itemCount: chatprovider.getChatList.length,
                itemBuilder: (context, index) {
                  return ChatWidget(
                    message: chatprovider.getChatList[index].message.toString(),
                    index: chatprovider.getChatList[index].chatIndex,
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
                        await sendMSG(
                            curprovider: curprovider,
                            chatprovider: chatprovider);
                      },
                      decoration: const InputDecoration.collapsed(
                          hintText: "How can I help you!",
                          hintStyle: TextStyle(color: Colors.white)),
                    )),
                    IconButton(
                        onPressed: () async {
                          await sendMSG(
                              curprovider: curprovider,
                              chatprovider: chatprovider);
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

  Future<void> sendMSG(
      {required ModelsProvider curprovider,
      required ChatProvider chatprovider}) async {
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
        chatprovider.addUserChat(message: msg);
        textEditingController.clear();
        focusnode.unfocus();
      });
      await chatprovider.sendMessage(
          message: msg, model: curprovider.getmodel);
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
