import 'package:chatze/widgets/chat.dart';
import 'package:dialog_flowtter/dialog_flowtter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late DialogFlowtter dialogFlowtter;
  final TextEditingController _controller = TextEditingController();
  List<Map<String, dynamic>> messages = [];
  bool _isRecording = false;

  @override
  void initState() {
    super.initState();
    initDialogFlowtter();
  }

  Future<void> initDialogFlowtter() async {
    DialogAuthCredentials credentials =
        await DialogAuthCredentials.fromFile('assets/auth_hajjflow.json');
    DialogFlowtter instance = DialogFlowtter(credentials: credentials);
    setState(() {
      dialogFlowtter = instance;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 232, 35, 35),
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
        children: <Widget>[
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
            onPressed: () {},
          ),
        ],
      ),
    );
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
      // Handle the error or show an alert to the user
    }
  }

  void addMessage(String message, [bool isUserMessage = false]) {
    setState(() {
      messages.add({"message": message, "isUserMessage": isUserMessage});
    });
  }
}
