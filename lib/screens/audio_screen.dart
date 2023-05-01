import 'dart:developer';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:mobgpt/constants/constants.dart';
import 'package:mobgpt/providers/audio_provider.dart';
import 'package:mobgpt/services/api_service.dart';
import 'package:mobgpt/services/assets_manager.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mobgpt/widgets/chat_widget.dart';
import 'package:mobgpt/widgets/text_widget.dart';
import 'package:provider/provider.dart';
import '../models/chat_model.dart';
import '../providers/chat_provider.dart';
import '../services/services.dart';

class AudioScreen extends StatefulWidget {
  const AudioScreen({super.key});
  @override
  State<AudioScreen> createState() => _AudioScreenState();
}

class _AudioScreenState extends State<AudioScreen> {
  bool _isTyping = false;
  late ScrollController listScrollController;
  // late TextEditingController textEditingController;
  late FocusNode focusnode;
  String fileNamePlaceHolder = "Select .mp3 file";

  File audioFile = File("");

  @override
  void initState() {
    listScrollController = ScrollController();
    // textEditingController = TextEditingController();
    focusnode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    listScrollController.dispose();
    // textEditingController.dispose();
    focusnode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final audioprovider = Provider.of<AudioProvider>(context);

    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(AssetsManager.openaiImage)),
        title: const Text("MobGPT - Audio Transcript"),
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
                itemCount: audioprovider.getAudioList.length,
                itemBuilder: (context, index) {
                  return ChatWidget(
                      role: audioprovider.getAudioList[index].role,
                      content:
                          audioprovider.getAudioList[index].content.toString(),
                      index: index,
                      size: audioprovider.getAudioList.length);
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
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                      child: IconButton(
                          onPressed: () {
                            selectFile();
                          },
                          color: Colors.white,
                          icon: const Icon(Icons.attach_file_sharp)),
                    ),
                    Expanded(
                        child: Text(
                      fileNamePlaceHolder,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Colors.white),
                    )),
                    IconButton(
                        onPressed: () async {
                          await sendAudio(audioprovider: audioprovider);
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

  void selectFile() async {
    FilePickerResult? audio =
        await FilePicker.platform.pickFiles(
          type: FileType.custom,
          allowMultiple: false,
          allowedExtensions: ["mp3"]
        );
    if (audio != null) {
      setState(() {
        audioFile = File(audio.files.single.path ?? "");
        fileNamePlaceHolder = audioFile.toString().substring(57);
      });
    }
  }

  Future<void> sendAudio({required audioprovider}) async {
    if (fileNamePlaceHolder == "Select .mp3 file") {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: TextWidget(
          label: "Please select a file",
        ),
        backgroundColor: Colors.red,
      ));
      return;
    }
    if (_isTyping) {
      return;
    }
    try {
      final msg = audioFile;
      setState(() {
        _isTyping = true;
        audioprovider.addUserAudio(message: audioFile.toString().substring(57));
        fileNamePlaceHolder = "Select .mp3 file";
        focusnode.unfocus();
      });
      await audioprovider.sendAudio(message: msg.path);
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
