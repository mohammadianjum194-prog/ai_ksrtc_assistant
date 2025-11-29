import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'result.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final sourceCtrl = TextEditingController();
  final destCtrl = TextEditingController();
  final timeCtrl = TextEditingController();

  final SpeechToText _speech = SpeechToText();
  final FlutterTts _tts = FlutterTts();
  bool isListening = false;

  void speak(String text) async {
    await _tts.speak(text);
  }

  @override
  void initState() {
    super.initState();
    speak("Hi, I am Rocky. Enter your travel details.");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Enter Route"), backgroundColor: Colors.red),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.red,
        child: Icon(isListening ? Icons.mic_off : Icons.mic),
        onPressed: () async {
          if (!isListening) {
            bool available = await _speech.initialize();
            if (available) {
              setState(() => isListening = true);
              _speech.listen(onResult: (r) => sourceCtrl.text = r.recognizedWords);
            }
          } else {
            setState(() => isListening = false);
            _speech.stop();
          }
        },
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(controller: sourceCtrl, decoration: const InputDecoration(labelText: "Source")),
            TextField(controller: destCtrl, decoration: const InputDecoration(labelText: "Destination")),
            TextField(controller: timeCtrl, decoration: const InputDecoration(labelText: "Preferred Time")),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ResultScreen(
                      source: sourceCtrl.text,
                      destination: destCtrl.text,
                      time: timeCtrl.text,
                    ),
                  ),
                );
              },
              child: const Text("Find Bus"),
            )
          ],
        ),
      ),
    );
  }
}

