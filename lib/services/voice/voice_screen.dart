import 'package:flutter/material.dart';
import '../../services/speech_service.dart';

class VoiceScreen extends StatefulWidget {
  const VoiceScreen({super.key});

  @override
  State<VoiceScreen> createState() => _VoiceScreenState();
}

class _VoiceScreenState extends State<VoiceScreen> {
  final SpeechService _speechService = SpeechService();

  String text = "Tap the mic and speak";
  bool isReady = false;

  @override
  void initState() {
    super.initState();
    initSpeech();
  }

  void initSpeech() async {
    bool available = await _speechService.init();
    if (mounted) {
      setState(() {
        isReady = available;
      });
    }
  }

  void startListening() {
    _speechService.startListening((result) {
      if (mounted) {
        setState(() {
          text = result;
        });
      }
    });
  }

  void stopListening() {
    _speechService.stopListening();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Voice Input")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              text,
              style: const TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 40),

            GestureDetector(
              onTap: () {
                if (_speechService.isListening) {
                  stopListening();
                } else {
                  startListening();
                }
              },
              child: CircleAvatar(
                radius: 60,
                backgroundColor: Colors.blue,
                child: Icon(
                  _speechService.isListening ? Icons.mic : Icons.mic_none,
                  size: 40,
                  color: Colors.white,
                ),
              ),
            ),

            const SizedBox(height: 20),

            Text(
              _speechService.isListening ? "Listening..." : "Tap to Speak",
              style: const TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
