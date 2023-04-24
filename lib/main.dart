import 'package:flutter/material.dart';
import 'package:mobgpt/providers/chat_provider.dart';
import 'package:mobgpt/providers/models_providers.dart';
import 'package:mobgpt/screens/chat_screen.dart';
import 'package:provider/provider.dart';
import 'constants/constants.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ModelsProvider()
        ),
        ChangeNotifierProvider(
          create: (_) => ChatProvider()
        )
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          scaffoldBackgroundColor: scaffoldBackgroundColor,
          appBarTheme: AppBarTheme(
            color: cardColor
          )
        ),
        home: const ChatScreen(),
        )
    );
  }
}
