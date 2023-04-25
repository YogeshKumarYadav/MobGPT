import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:mobgpt/services/assets_manager.dart';
import 'package:mobgpt/constants/constants.dart';
import 'package:mobgpt/widgets/text_widget.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class EditWidget extends StatelessWidget {
  const EditWidget(
      {super.key,
      required this.role,
      required this.content,
      required this.instruction,
      required this.index,
      required this.size});
  final String content;
  final String instruction;
  final String role;
  final int index;
  final int size;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Material(
          color: role == "user" ? scaffoldBackgroundColor : cardColor,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Image.asset(
                role == "user"
                    ? AssetsManager.userImage
                    : AssetsManager.gptImage,
                height: 30,
                width: 30,
              ),
              const SizedBox(
                width: 8,
              ),
              Expanded(
                child: role == "user"
                    ? Padding(
                        padding: const EdgeInsets.fromLTRB(0, 5, 20, 5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                          const TextWidget(label: "Input:", fontSize: 18),
                          TextWidget(label: content),
                          const SizedBox(height: 10),
                          const TextWidget(label: "Instructions:", fontSize: 18),
                          TextWidget(label: instruction)
                        ],)
                      ) 
                    
                    : Padding(
                        padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                          TextWidget(label: content)
                        ],)
                      )
                    ),
              role == "user"
                  ? const SizedBox.shrink()
                  : IconButton(
                      alignment: Alignment.topRight,
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: content));
                      },
                      icon: const Icon(
                        Icons.copy_rounded,
                        color: Colors.white,
                        // size: 25,
                      )),
            ]),
          ),
        )
      ],
    );
  }
}
