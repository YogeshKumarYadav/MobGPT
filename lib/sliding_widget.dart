import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:mobgpt/screens/Image_screen.dart';
import 'package:mobgpt/screens/audio_screen.dart';
import 'package:mobgpt/screens/chat_screen.dart';
import 'package:mobgpt/screens/edit_screen.dart';

import 'constants/constants.dart';

class SliderWidget extends StatefulWidget {
  const SliderWidget({super.key});

  @override
  State<SliderWidget> createState() => _SliderWidgetState();
}

class _SliderWidgetState extends State<SliderWidget> {
  int cur_index = 0;
  PageController pagecontroller = PageController(initialPage: 0);
  final navigation_items = [
    BottomNavigationBarItem(
        icon: const Icon(Icons.chat_outlined),
        label: "Chat",
        backgroundColor: scaffoldBackgroundColor),
    BottomNavigationBarItem(
        icon: const Icon(Icons.edit_attributes_outlined),
        label: "Edit",
        backgroundColor: scaffoldBackgroundColor),
    BottomNavigationBarItem(
        icon: const Icon(Icons.image_outlined),
        label: "Image",
        backgroundColor: scaffoldBackgroundColor),
    BottomNavigationBarItem(
        icon: const Icon(Icons.audiotrack_outlined),
        label: "Audio",
        backgroundColor: scaffoldBackgroundColor)
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: pagecontroller,
        onPageChanged: (newindex) {
          setState(() {
            cur_index = newindex;
          });
        },
        children: const [
          ChatScreen(),
          EditScreen(),
          ImageScreen(),
          AudioScreen()
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: cur_index,
          fixedColor: Colors.white,
          items: navigation_items,
          onTap: (newIndex) {
            setState(() {
              pagecontroller.animateToPage(newIndex,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeIn);
            });
          }),
    );
  }
}
