import 'package:flutter/material.dart';
import '../constants/constants.dart';
import '../widgets/dropdown_widget.dart';
import '../widgets/text_widget.dart';

class Services {
  static Future<void> showModeSheet({required BuildContext context}) async {
    await showModalBottomSheet(
      backgroundColor: scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius:
          BorderRadius.vertical(
            top: Radius.circular(20)
          )
      ),
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Flexible(
                    child: Text(
                      "Choose Mode", 
                      style: TextStyle(
                        fontSize: 16, 
                        color: Colors.white
                      )
                    )
                  ),
                  Flexible(
                    flex: 2,
                    child: ModeDropDown()),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.black,
                  elevation: 2, 
                  shadowColor: Colors.grey,
                ),
                onPressed: () {},
                child: const Text(
                  "Logout", 
                  style: TextStyle(
                    fontSize: 15, 
                    color: Colors.white
                  )
                )
              )
            ]
          )
        );
      }
    );
  }
}
