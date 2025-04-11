import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:novi/ai_service.dart';
import 'package:novi/login_page.dart';
import 'package:novi/models/chat_message.dart';
import 'package:novi/models/user_model.dart';

class UserHomePage extends StatefulWidget {
  final String userEmail;

  const UserHomePage({super.key, required this.userEmail});

  @override
  State<UserHomePage> createState() => _UserHomePageState();
}

class _UserHomePageState extends State<UserHomePage> {
  final SpeechToText speechToText = SpeechToText();
  final FlutterTts flutterTts = FlutterTts();
  final OpenAIService openAIService = OpenAIService();
  final TextEditingController _textController = TextEditingController();

  List<ChatMessage> chatHistory = [];
  bool isListening = false;
  late Box<UserModel> userBox;
  late UserModel currentUser;

  @override
  void initState() {
    super.initState();
    initHive();
    initSpeechToText();
    initTTS();
  }

  Future<void> initHive() async {
    userBox = Hive.box<UserModel>('users');

    final user = userBox.values.firstWhere(
      (u) => u.email == widget.userEmail,
      orElse: () => throw Exception("User not found"),
    );

    setState(() {
      currentUser = user;
      chatHistory = List<ChatMessage>.from(user.chatHistory);
    });
  }

  Future<void> initSpeechToText() async {
    await speechToText.initialize();
  }

  Future<void> initTTS() async {
    await flutterTts.setSharedInstance(true);
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

  Future<void> handleSendMessage(String message) async {
    final userMsg = ChatMessage(
      message: message,
      isUser: true,
      timestamp: DateTime.now(),
    );

    setState(() {
      chatHistory.add(userMsg);
    });

    currentUser.chatHistory.add(userMsg);
    await currentUser.save();

    final aiResponse = await openAIService.isArtPromptAPI(message);

    final aiMsg = ChatMessage(
      message: aiResponse,
      isUser: false,
      timestamp: DateTime.now(),
    );

    setState(() {
      chatHistory.add(aiMsg);
    });

    currentUser.chatHistory.add(aiMsg);
    await currentUser.save();

    await flutterTts.speak(aiResponse);
  }

  @override
  void dispose() {
    speechToText.stop();
    flutterTts.stop();
    _textController.dispose();
    super.dispose();
  }

  Widget buildMessage(ChatMessage msg) {
    final isUser = msg.isUser;
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
        padding: const EdgeInsets.all(14),
        constraints: const BoxConstraints(maxWidth: 300),
        decoration: BoxDecoration(
          color: isUser ? Colors.teal.shade600 : Colors.grey.shade200,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(isUser ? 16 : 0),
            bottomRight: Radius.circular(isUser ? 0 : 16),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 5,
              offset: const Offset(0, 2),
            )
          ],
        ),
        child: Text(
          msg.message,
          style: TextStyle(
            color: isUser ? Colors.white : Colors.black87,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: const Text('Novi AI Assistant',
            style: TextStyle(color: Colors.white)),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.account_circle, color: Colors.white),
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
      body: Column(
        children: [
          Expanded(
            child: chatHistory.isEmpty
                ? const Center(child: Text("Start a conversation..."))
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    itemCount: chatHistory.length,
                    itemBuilder: (context, index) {
                      return buildMessage(chatHistory[index]);
                    },
                  ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(32),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  )
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _textController,
                      decoration: const InputDecoration(
                        hintText: "Type your message...",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send, color: Colors.teal),
                    onPressed: () {
                      final text = _textController.text.trim();
                      if (text.isNotEmpty) {
                        handleSendMessage(text);
                        _textController.clear();
                      }
                    },
                  ),
                  IconButton(
                    icon: Icon(
                      isListening ? Icons.stop_circle : Icons.mic,
                      color: Colors.teal,
                    ),
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
          ),
        ],
      ),
    );
  }
}
