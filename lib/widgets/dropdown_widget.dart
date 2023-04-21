import 'package:flutter/material.dart';
import 'package:mobgpt/providers/models_providers.dart';
import 'package:mobgpt/widgets/text_widget.dart';
import 'package:provider/provider.dart';
import '../constants/constants.dart';
import '../models/models_model.dart';
import '../services/api_service.dart';

class ModelDropDown extends StatefulWidget {
  const ModelDropDown({super.key});
  @override
  State<ModelDropDown> createState() => _ModelDropDownState();
}

class _ModelDropDownState extends State<ModelDropDown> {
  String? currentModel;
  @override
  Widget build(BuildContext context) {
    final curprovider = Provider.of<ModelsProvider>(context, listen: false);
    currentModel = curprovider.getmodel;
    return FutureBuilder<List<ModelsModel>>(
        future: curprovider.getallmodels(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: TextWidget(label: snapshot.error.toString()),
            );
          } else {
            return snapshot.data == null || snapshot.data!.isEmpty
                ? const SizedBox.shrink()
                : FittedBox(
                    child: DropdownButton(
                        dropdownColor: scaffoldBackgroundColor,
                        iconEnabledColor: Colors.white,
                        items: List<DropdownMenuItem<Object?>>.generate(
                            snapshot.data!.length,
                            (index) => DropdownMenuItem(
                                value: snapshot.data![index].id,
                                child: TextWidget(
                                  label: snapshot.data![index].id,
                                  fontSize: 15,
                                ))),
                        value: currentModel,
                        onChanged: (value) {
                          setState(() {
                            currentModel = value.toString();
                          });
                          curprovider.setCurrentModel(value.toString());
                        }));
          }
        });
  }
}
