import 'package:chatze/widgets/chat.dart';
import 'package:dialog_flowtter/dialog_flowtter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late DialogFlowtter dialogFlowtter;
  final TextEditingController _controller = TextEditingController();
  List<Map<String, dynamic>> messages = [];
  final SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  String _lastWords = "";

  Future<void> requestForPermission() async {
    await Permission.microphone.request();
  }

  @override
  void initState() {
    super.initState();
    listenForPermissions();
    initDialogFlowtter();
    _initSpeech();
  }

  Future<void> listenForPermissions() async {
    final status = await Permission.microphone.status;
    if (status != PermissionStatus.granted) {
      await Permission.microphone.request();
    }
  }

  Future<void> _initSpeech() async {
    _speechEnabled = await _speechToText.initialize();
    setState(() {}); // Call setState to update the UI
  }

  Future<void> initDialogFlowtter() async {
    DialogAuthCredentials credentials =
        await DialogAuthCredentials.fromFile('your path here');
    DialogFlowtter instance = DialogFlowtter(credentials: credentials);
    setState(() {
      dialogFlowtter = instance;
    });
  }

  void _startListening() async {
    await _speechToText.listen(onResult: _onSpeechResult);
    setState(() {});
  }

  void _stopListening() async {
    await _speechToText.stop();
    setState(() {});
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    if (result.finalResult) {
      sendMessage(result.recognizedWords);
    }
  }

  Future<void> sendMessage(String msg) async {
    if (msg.isEmpty) {
      if (kDebugMode) {
        print("Message is Empty");
      }
      return;
    }

    addMessage(msg, true);

    try {
      DetectIntentResponse response = await dialogFlowtter.detectIntent(
        queryInput: QueryInput(text: TextInput(text: msg)),
      );

      if (response.message?.text?.text != null) {
        addMessage(response.message!.text!.text![0]);
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error sending message: $e');
      }
    }
  }

  void addMessage(String message, [bool isUserMessage = false]) {
    setState(() {
      messages.add({"message": message, "isUserMessage": isUserMessage});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 232, 35, 35),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image.asset(
              'assets/marbot.png',
              fit: BoxFit.contain,
              height: 32,
            ),
            const SizedBox(width: 10),
            const Text(
              "Marbot Research",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
              child: Chat(messages: messages), // Your chat messages widget
            ),
          ),
          _buildInputArea(), // Extracted input area as a separate method
        ],
      ),
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey[200], // Light grey color for the input area
        borderRadius: BorderRadius.circular(24),
      ),
      margin: const EdgeInsets.all(10),
      child: Row(
        children: [
          Flexible(
            child: TextField(
              controller: _controller,
              onSubmitted: (value) {
                sendMessage(value);
                _controller.clear();
              },
              decoration: InputDecoration(
                hintText: "Masukan pertanyaan...",
                border: InputBorder.none,
                fillColor: Colors.grey[200],
                filled: true,
                contentPadding: const EdgeInsets.all(10),
                isDense: true,
                hintStyle: TextStyle(color: Colors.grey[600]),
              ),
            ),
          ),
          // Text(
          //   _speechToText.isListening
          //       ? _lastWords
          //       : _speechEnabled
          //           ? 'Tap the microphone to start listening...'
          //           : 'Speech not available',
          // ),
          IconButton(
            icon: const Icon(Icons.send, color: Colors.blueGrey),
            onPressed: () {
              sendMessage(_controller.text);
              _controller.clear();
            },
          ),
          IconButton(
            iconSize: 30.0,
            icon: const Icon(Icons.mic_sharp, color: Colors.blueGrey),
            onPressed: () {
              if (_speechToText.isNotListening) {
                _startListening();
              } else {
                _stopListening();
              }
            },
          ),
        ],
      ),
    );
  }
}
