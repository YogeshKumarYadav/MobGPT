import 'package:flutter/material.dart';
import '../constants/constants.dart';

class ModelDropDown extends StatefulWidget {
  const ModelDropDown({super.key});
  @override
  State<ModelDropDown> createState() => _ModelDropDownState();
}

class _ModelDropDownState extends State<ModelDropDown> {
  String currentModel = "Model 1";
  @override
  Widget build(BuildContext context) {
    return DropdownButton(
      dropdownColor: scaffoldBackgroundColor,
      iconEnabledColor: Colors.white,
      items: getModels,
      value: currentModel,
      onChanged: (value) {
        setState(() {
          currentModel = value.toString();
        });
      }
    );
  }
}
