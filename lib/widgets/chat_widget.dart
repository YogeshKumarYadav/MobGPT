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
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              Image.asset(
                index == 0 ? AssetsManager.userImage : AssetsManager.gptImage,
                height: 30,
                width: 30,
              ),
              const SizedBox(
                width: 8,
              ),
              Expanded(child: TextWidget(label: message )),
              index == 0
              ? const SizedBox.shrink()
              : Row(
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(Icons.thumb_up_alt_outlined, color: Colors.white,),
                  SizedBox(width: 5),
                  Icon(Icons.thumb_down_alt_outlined, color: Colors.white,)
                ],
              )
            ]),
          ),
        )
      ],
    );
  }
}
