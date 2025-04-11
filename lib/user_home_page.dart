import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

import 'package:novi/ai_service.dart';
import 'package:novi/login_page.dart';
import 'package:path_provider/path_provider.dart';

class UserHomePage extends StatefulWidget {
  final String userEmail;

  const UserHomePage({super.key, required this.userEmail});

  @override
  State<UserHomePage> createState() => _UserHomePageState();
}

class _UserHomePageState extends State<UserHomePage> {
  final speechToText = SpeechToText();
  final flutterTts = FlutterTts();
  final openAIService = OpenAIService();

  final TextEditingController _textController = TextEditingController();
  List<Map<String, String>> chatHistory = [];

  late File localJsonFile;
  late Map<String, dynamic> jsonData;
  bool isListening = false;

  @override
  void initState() {
    super.initState();
    initSpeechToText();
    initTextToSpeech();
    loadJsonData();
  }

  Future<void> initTextToSpeech() async {
    await flutterTts.setSharedInstance(true);
  }

  Future<void> initSpeechToText() async {
    await speechToText.initialize();
  }

  Future<void> loadJsonData() async {
    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/novi_user_data.json';
    localJsonFile = File(filePath);

    if (!await localJsonFile.exists()) {
      final data = await rootBundle.loadString('assets/novi_user_data.json');
      await localJsonFile.writeAsString(data);
    }

    final contents = await localJsonFile.readAsString();
    jsonData = json.decode(contents);

    setState(() {
      chatHistory = List<Map<String, String>>.from(
        (jsonData['chats'][widget.userEmail] ?? []),
      );
    });
  }

  Future<void> saveChatHistory() async {
    jsonData['chats'][widget.userEmail] = chatHistory;
    await localJsonFile.writeAsString(json.encode(jsonData));
  }

  Future<void> handleSendMessage(String message) async {
    setState(() {
      chatHistory.add({'role': 'user', 'message': message});
    });

    final response = await openAIService.isArtPromptAPI(message);
    setState(() {
      chatHistory.add({'role': 'ai', 'message': response});
    });

    await flutterTts.speak(response);
    await saveChatHistory();
  }

  void logout() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }

  void onSpeechResult(SpeechRecognitionResult result) {
    if (result.finalResult && result.recognizedWords.isNotEmpty) {
      _textController.text = result.recognizedWords;
      handleSendMessage(result.recognizedWords);
    }
  }

  @override
  void dispose() {
    speechToText.stop();
    flutterTts.stop();
    _textController.dispose();
    super.dispose();
  }

  Widget buildMessage(String role, String message) {
    bool isUser = role == 'user';
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isUser ? Colors.blueAccent : Colors.grey[300],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          message,
          style: TextStyle(
            color: isUser ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }

  Future<void> startListening() async {
    if (!isListening && await speechToText.hasPermission) {
      setState(() => isListening = true);
      await speechToText.listen(onResult: onSpeechResult);
    }
  }

  Future<void> stopListening() async {
    if (isListening) {
      await speechToText.stop();
      setState(() => isListening = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Novi AI Assistant'),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.account_circle),
            onSelected: (value) {
              if (value == 'logout') logout();
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                  value: 'email',
                  enabled: false,
                  child: Text(widget.userEmail)),
              const PopupMenuDivider(),
              const PopupMenuItem(value: 'logout', child: Text("Logout")),
            ],
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                reverse: false,
                itemCount: chatHistory.length,
                itemBuilder: (context, index) {
                  final entry = chatHistory[index];
                  return buildMessage(entry['role']!, entry['message']!);
                },
              ),
            ),
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _textController,
                      decoration: InputDecoration(
                        hintText: "Type your message...",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 16),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: () {
                      final text = _textController.text.trim();
                      if (text.isNotEmpty) {
                        handleSendMessage(text);
                        _textController.clear();
                      }
                    },
                  ),
                  IconButton(
                    icon: Icon(isListening ? Icons.stop : Icons.mic),
                    onPressed: () async {
                      if (!isListening) {
                        await startListening();
                      } else {
                        await stopListening();
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
