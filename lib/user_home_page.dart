import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:novi/feature_box.dart';
import 'package:novi/openai_service.dart';
import 'package:novi/pallete.dart';
import 'package:novi/login_page.dart';

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

  String lastWords = '';
  String? generatedContent;
  String? generatedImageUrl;
  int start = 200;
  int delay = 200;

  @override
  void initState() {
    super.initState();
    initSpeechToText();
    initTextToSpeech();
  }

  Future<void> initTextToSpeech() async {
    await flutterTts.setSharedInstance(true);
    setState(() {});
  }

  Future<void> initSpeechToText() async {
    await speechToText.initialize();
    setState(() {});
  }

  Future<void> startListening() async {
    await speechToText.listen(onResult: onSpeechResult);
    setState(() {});
  }

  Future<void> stopListening() async {
    await speechToText.stop();
    setState(() {});
  }

  void onSpeechResult(SpeechRecognitionResult result) async {
    if (!result.isConfident() || result.confidence < 0.7) return;

    lastWords = result.recognizedWords;
    await processQuery(lastWords);
    await stopListening();
  }

  Future<void> processQuery(String query) async {
    final speech = await openAIService.isArtPromptAPI(query);
    if (speech.contains('https')) {
      generatedImageUrl = speech;
      generatedContent = null;
    } else {
      generatedImageUrl = null;
      generatedContent = speech;
      await systemSpeak(speech);
    }
    setState(() {});
  }

  Future<void> systemSpeak(String content) async {
    await flutterTts.speak(content);
  }

  void logout() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }

  @override
  void dispose() {
    super.dispose();
    speechToText.stop();
    flutterTts.stop();
    _textController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: BounceInDown(child: const Text('Novi')),
        centerTitle: true,
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.account_circle),
            onSelected: (value) {
              if (value == 'logout') {
                logout();
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem<String>(
                value: 'email',
                enabled: false,
                child: Text(widget.userEmail),
              ),
              const PopupMenuDivider(),
              PopupMenuItem<String>(
                value: 'logout',
                child: const Text("Logout"),
              ),
            ],
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                reverse: true,
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Column(
                  children: [
                    Center(
                      child: Container(
                        height: 123,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: AssetImage(
                                'assets/images/virtualAssistant.png'),
                          ),
                        ),
                      ),
                    ),
                    FadeInRight(
                      child: Visibility(
                        visible: generatedImageUrl == null,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          margin: const EdgeInsets.symmetric(horizontal: 40)
                              .copyWith(top: 30),
                          decoration: BoxDecoration(
                            border: Border.all(color: Pallete.borderColor),
                            borderRadius: BorderRadius.circular(20)
                                .copyWith(topLeft: Radius.zero),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10.0),
                            child: Text(
                              generatedContent ??
                                  'Good Morning, what task can I do for you?',
                              style: TextStyle(
                                fontFamily: 'Cera Pro',
                                color: Pallete.mainFontColor,
                                fontSize: generatedContent == null ? 25 : 18,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                border: Border(top: BorderSide(color: Colors.grey.shade300)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _textController,
                      decoration: InputDecoration(
                        hintText: 'Type your question...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(color: Colors.grey.shade400),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 15),
                        suffixIcon: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.send),
                              onPressed: () {
                                final input = _textController.text.trim();
                                if (input.isNotEmpty) {
                                  processQuery(input);
                                  _textController.clear();
                                }
                              },
                            ),
                            IconButton(
                              icon: Icon(speechToText.isListening
                                  ? Icons.stop
                                  : Icons.mic),
                              onPressed: () async {
                                if (await speechToText.hasPermission &&
                                    !speechToText.isListening) {
                                  await startListening();
                                } else if (speechToText.isListening) {
                                  await stopListening();
                                } else {
                                  initSpeechToText();
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: ZoomIn(
        delay: Duration(milliseconds: start + 3 * delay),
        child: FloatingActionButton.large(
          backgroundColor: Pallete.firstSuggestionBoxColor,
          onPressed: () async {
            if (await speechToText.hasPermission && !speechToText.isListening) {
              await startListening();
            } else if (speechToText.isListening) {
              await stopListening();
            } else {
              initSpeechToText();
            }
          },
          child: Icon(speechToText.isListening ? Icons.stop : Icons.mic),
        ),
      ),
    );
  }
}
