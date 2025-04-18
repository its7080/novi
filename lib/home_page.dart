import 'package:novi/feature_box.dart';
import 'package:novi/openai_service.dart';
import 'package:novi/pallete.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final speechToText = SpeechToText();
  final flutterTts = FlutterTts();
  String lastWords = '';
  final OpenAIService openAIService = OpenAIService();
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

    final speech = await openAIService.isArtPromptAPI(lastWords);
    if (speech.contains('https')) {
      generatedImageUrl = speech;
      generatedContent = null;
      setState(() {});
    } else {
      generatedImageUrl = null;
      generatedContent = speech;
      setState(() {});
      await systemSpeak(speech);
    }
    await stopListening();
  }

  Future<void> systemSpeak(String content) async {
    await flutterTts.speak(content);
  }

  @override
  void dispose() {
    super.dispose();
    speechToText.stop();
    flutterTts.stop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: BounceInDown(
          child: const Text('Novi'),
        ),
        // leading: const Icon(Icons.menu),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Column(
              children: [
                // virtual assistant picture
                // ZoomIn(
                //   child: Stack(
                //     children: [
                //       Center(
                //         child: Container(
                //           height: 120,
                //           width: 120,
                //           margin: const EdgeInsets.only(top: 4),
                //           decoration: const BoxDecoration(
                //             color: Pallete.assistantCircleColor,
                //             shape: BoxShape.circle,
                //           ),
                //         ),
                //       ),
                //       Container(
                //         height: 123,
                //         decoration: const BoxDecoration(
                //           shape: BoxShape.circle,
                //           image: DecorationImage(
                //             image: AssetImage(
                //               'assets/images/virtualAssistant.png',
                //             ),
                //           ),
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
                Center(
                  child: Container(
                    height: 123,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: AssetImage(
                          'assets/images/virtualAssistant.png',
                        ),
                      ),
                    ),
                  ),
                ),
                // chat bubble
                FadeInRight(
                  child: Visibility(
                    visible: generatedImageUrl == null,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      margin:
                          const EdgeInsets.symmetric(horizontal: 40).copyWith(
                        top: 30,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Pallete.borderColor,
                        ),
                        borderRadius: BorderRadius.circular(20).copyWith(
                          topLeft: Radius.zero,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: Text(
                          generatedContent == null
                              ? 'Good Morning, what task can I do for you?'
                              : generatedContent!,
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
                // if (generatedImageUrl != null)
                //   Padding(
                //     padding: const EdgeInsets.all(10.0),
                //     child: ClipRRect(
                //       borderRadius: BorderRadius.circular(20),
                //       child: Image.network(generatedImageUrl!),
                //     ),
                //   ),
                // SlideInLeft(
                //   child: Visibility(
                //     visible: generatedContent == null && generatedImageUrl == null,
                //     child: Container(
                //       padding: const EdgeInsets.all(10),
                //       alignment: Alignment.centerLeft,
                //       margin: const EdgeInsets.only(top: 10, left: 22),
                //       child: const Text(
                //         'Here are a few features',
                //         style: TextStyle(
                //           fontFamily: 'Cera Pro',
                //           color: Pallete.mainFontColor,
                //           fontSize: 20,
                //           fontWeight: FontWeight.bold,
                //         ),
                //       ),
                //     ),
                //   ),
                // ),
                // features list
              ],
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: ZoomIn(
        delay: Duration(milliseconds: start + 3 * delay),
        child: FloatingActionButton.large(
          backgroundColor: Pallete.firstSuggestionBoxColor,
          onPressed: () async {
            if (await speechToText.hasPermission &&
                speechToText.isNotListening) {
              await startListening();
            } else if (speechToText.isListening) {
              final speech = await openAIService.isArtPromptAPI(lastWords);
              if (speech.contains('https')) {
                generatedImageUrl = speech;
                generatedContent = null;
                setState(() {});
              } else {
                generatedImageUrl = null;
                generatedContent = speech;
                setState(() {});
                await systemSpeak(speech);
              }
              await stopListening();
            } else {
              initSpeechToText();
            }
          },
          child: Icon(
            speechToText.isListening ? Icons.stop : Icons.mic,
          ),
        ),
      ),
    );
  }
}
