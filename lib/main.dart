import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:novi/models/chat_message.dart';
import 'package:novi/models/user_model.dart';
import 'package:novi/home_page.dart'; // <-- Updated import

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await Hive.initFlutter();

  // Register Hive adapters
  Hive.registerAdapter(ChatMessageAdapter());
  Hive.registerAdapter(UserModelAdapter());

  // Open Hive boxes
  await Hive.openBox<UserModel>('users'); // Box for user credentials
  await Hive.openBox<List>('chats'); // Box for user-based chat history

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Novi AI',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const HomePage(), // <-- Updated landing page
    );
  }
}
