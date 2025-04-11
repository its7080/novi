import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:novi/ai_service.dart';
import 'package:novi/login_page.dart';
import 'package:novi/pallete.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final SpeechToText _speechToText = SpeechToText();
  final FlutterTts _flutterTts = FlutterTts();
  final OpenAIService _openAIService = OpenAIService();

  String lastWords = '';
  String? generatedContent;
  String? generatedImageUrl;

  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _initSpeech();
    _initTTS();
  }

  Future<void> _initSpeech() async {
    await _speechToText.initialize();
  }

  Future<void> _initTTS() async {
    await _flutterTts.setSharedInstance(true);
  }

  Future<void> _startListening() async {
    await _speechToText.listen(onResult: _onSpeechResult);
    setState(() {});
  }

  Future<void> _stopListening() async {
    await _speechToText.stop();
    setState(() {});
  }

  void _onSpeechResult(SpeechRecognitionResult result) async {
    if (!result.isConfident() || result.confidence < 0.7) return;

    lastWords = result.recognizedWords;
    await _processQuery(lastWords);
    await _stopListening();
  }

  Future<void> _processQuery(String query) async {
    setState(() => _isProcessing = true);

    try {
      final response = await _openAIService.isArtPromptAPI(query);
      if (response.contains('https')) {
        generatedImageUrl = response;
        generatedContent = null;
      } else {
        generatedContent = response;
        generatedImageUrl = null;
        await _flutterTts.speak(response);
      }
    } catch (e) {
      generatedContent = "Oops! Something went wrong.";
      generatedImageUrl = null;
    }

    setState(() => _isProcessing = false);
  }

  @override
  void dispose() {
    _speechToText.stop();
    _flutterTts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Pallete.whiteColor,
      appBar: AppBar(
        title: const Text("Novi AI"),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 165, 231, 244),
        actions: [
          IconButton(
            icon: const Icon(Icons.login),
            tooltip: 'Login',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 120,
                      width: 120,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: AssetImage('assets/images/ai.gif'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    if (_isProcessing)
                      const Padding(
                        padding: EdgeInsets.all(20),
                        child: CircularProgressIndicator(),
                      )
                    else if (generatedImageUrl != null)
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Image.network(
                          generatedImageUrl!,
                          width: MediaQuery.of(context).size.width * 0.8,
                        ),
                      )
                    else
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 16),
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                          color: Pallete.whiteColor,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Pallete.borderColor),
                        ),
                        child: Text(
                          generatedContent ??
                              "Good Morning 👋\nWhat can I do for you today?",
                          style: TextStyle(
                            fontSize: generatedContent == null ? 22 : 18,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Cera Pro',
                            color: Pallete.mainFontColor,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: ZoomIn(
        delay: const Duration(milliseconds: 600),
        child: FloatingActionButton.extended(
          onPressed: () async {
            if (await _speechToText.hasPermission &&
                !_speechToText.isListening) {
              await _startListening();
            } else if (_speechToText.isListening) {
              await _stopListening();
            } else {
              await _initSpeech();
            }
          },
          label: Text(_speechToText.isListening ? "Stop" : "Talk"),
          icon:
              Icon(_speechToText.isListening ? Icons.stop : Icons.mic_rounded),
          backgroundColor: Pallete.firstSuggestionBoxColor,
        ),
      ),
    );
  }
}
