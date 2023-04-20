import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:mobgpt/services/assets_manager.dart';
import 'package:mobgpt/constants/constants.dart';
import 'package:mobgpt/widgets/text_widget.dart';

class ChatWidget extends StatelessWidget {
  const ChatWidget({super.key, required this.message, required this.index});
  final String message;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Material(
          color: index == 0 ? scaffoldBackgroundColor : cardColor,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(children: [
              Image.asset(
                index == 0 ? AssetsManager.userImage : AssetsManager.gptImage,
                height: 30,
                width: 30,
              ),
              const SizedBox(
                width: 8,
              ),
              Expanded(child: TextWidget(label: message))
            ]),
          ),
        )
      ],
    );
  }
}
