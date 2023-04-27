import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:mobgpt/screens/Image_screen.dart';
import 'package:mobgpt/screens/chat_screen.dart';
import 'package:mobgpt/screens/edit_screen.dart';
import 'package:mobgpt/widgets/text_widget.dart';
import 'package:provider/provider.dart';
import '../constants/constants.dart';
import '../providers/mode_provider.dart';
import '../services/api_service.dart';

class ModeDropDown extends StatefulWidget {
  const ModeDropDown({super.key});
  @override
  State<ModeDropDown> createState() => _ModeDropDownState();
}

class _ModeDropDownState extends State<ModeDropDown> {
  String? currentMode;
  List<String> modes = [
    "Chat Converastion",
    "Customize Input",
    "Audio Transcription",
    "Generate AI Image"
  ];

  @override
  Widget build(BuildContext context) {
    final modesprovider = Provider.of<ModesProvider>(context);
    currentMode = modesprovider.getmodel;
    return FittedBox(
        child: DropdownButton(
            dropdownColor: scaffoldBackgroundColor,
            iconEnabledColor: Colors.white,
            items: List<DropdownMenuItem<Object?>>.generate(
                modes.length,
                (index) => DropdownMenuItem(
                      value: modes[index],
                      child: Text(modes[index],
                          style: const TextStyle(
                              color: Colors.white, fontSize: 15)
                              ),
                    )
                  ),
            value: currentMode,
            onChanged: (value) {
              modesprovider.setCurrentMode(value.toString());              
              setState(() {
                currentMode = value.toString();
              });
              if(currentMode == "Chat Converastion") {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const ChatScreen()));
              }
              if(currentMode == "Customize Input") {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const EditScreen()));
              } 
              if(currentMode == "Generate AI Image") {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const ImageScreen()));
              }              
            }));
  }
}
