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
import '../services/services.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

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
    final chatprovider = Provider.of<ChatProvider>(context);

    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(AssetsManager.openaiImage)),
        title: const Text("MobGPT - Conversation"),
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
                itemCount: chatprovider.getChatList.length,
                itemBuilder: (context, index) {
                  return ChatWidget(
                    role: chatprovider.getChatList[index].role,
                    content: chatprovider.getChatList[index].content.toString(),
                    index: index,
                    size: chatprovider.getChatList.length
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
                padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        focusNode: focusnode,
                        style: const TextStyle(color: Colors.white),
                        controller: textEditingController,
                        onSubmitted: (value) async {
                          await sendMSG(
                              chatprovider: chatprovider);
                        },
                        decoration: const InputDecoration.collapsed(
                            hintText: "How can I help you!",
                            hintStyle: TextStyle(color: Colors.white38)),
                        )
                    ),
                    IconButton(
                        onPressed: () async {
                          await sendMSG(
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
      {required ChatProvider chatprovider}) async {
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
      await chatprovider.sendMessage(message: msg);
    } catch (e) {
      log("Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: TextWidget(
          label: ApiService.getAPI(),
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
