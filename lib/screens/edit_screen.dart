import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:mobgpt/constants/constants.dart';
import 'package:mobgpt/services/assets_manager.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mobgpt/widgets/text_widget.dart';
import 'package:provider/provider.dart';
import '../providers/edit_provider.dart';
import '../services/services.dart';
import '../widgets/edit_widget.dart';

class EditScreen extends StatefulWidget {
  const EditScreen({super.key});
  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  bool _isTyping = false;
  late ScrollController listScrollController;
  late TextEditingController textEditingControllerText;
  late TextEditingController textEditingControllerInst;

  late FocusNode focusnodeText;
  late FocusNode focusnodeInst;

  @override
  void initState() {
    listScrollController = ScrollController();
    textEditingControllerText = TextEditingController();
    textEditingControllerInst = TextEditingController();
    focusnodeText = FocusNode();
    focusnodeInst = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    listScrollController.dispose();
    textEditingControllerText.dispose();
    textEditingControllerInst.dispose();
    focusnodeText.dispose();
    focusnodeInst.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final editprovider = Provider.of<EditProvider>(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(AssetsManager.openaiImage)),
        title: const Text("MobGPT - Customize"),
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
                itemCount: editprovider.getEditList.length,
                itemBuilder: (context, index) {
                  return EditWidget(
                      role: editprovider.getEditList[index].role,
                      content:
                          editprovider.getEditList[index].input.toString(),
                      instruction: editprovider.getEditList[index].instruction.toString(),
                      index: index,
                      size: editprovider.getEditList.length);
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
                    child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                            child: TextField(
                              focusNode: focusnodeText,
                              style: const TextStyle(color: Colors.white),
                              controller: textEditingControllerText,
                              onSubmitted: (value) async {
                                await editMSG(editprovider: editprovider);
                              },
                              decoration: const InputDecoration.collapsed(
                                hintText: "Enter Text to Edit",
                                hintStyle: TextStyle(color: Colors.white38)),
                              ),
                            ),
                            const SizedBox(height: 20),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 0, 15),
                              child: TextField(
                              focusNode: focusnodeInst,
                                style: const TextStyle(color: Colors.white),
                                controller: textEditingControllerInst,
                                onSubmitted: (value) async {
                                  await editMSG(editprovider: editprovider);
                                },
                                decoration: const InputDecoration.collapsed(
                                  hintText: "Instruction",
                                  hintStyle: TextStyle(color: Colors.white38)),
                              )
                            )
                        ],
                      )
                    ),
                    IconButton(
                        onPressed: () async {
                          await editMSG(editprovider: editprovider);
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

  Future<void> editMSG({required EditProvider editprovider}) async {
    if (textEditingControllerText.text.isEmpty ||
        textEditingControllerInst.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: TextWidget(
          label: "Please provide all details",
        ),
        backgroundColor: Colors.red,
      ));
      return;
    }
    if (_isTyping) {
      return;
    }
    try {
      final txt = textEditingControllerText.text;
      final ins = textEditingControllerInst.text;
      setState(() {
        _isTyping = true;
        editprovider.addUserChat(message: txt, instruction: ins);
        textEditingControllerText.clear();
        textEditingControllerInst.clear();
        focusnodeText.unfocus();
        focusnodeInst.unfocus();
      });
      await editprovider.sendMessage(message: txt, instruction: ins);
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
