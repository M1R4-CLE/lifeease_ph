import 'package:speech_to_text/speech_to_text.dart';
import 'package:flutter/foundation.dart';

class SpeechService {
  final SpeechToText _speech = SpeechToText();

  Future<bool> init() async {
    try {
      return await _speech.initialize(
        onError: (error) => debugPrint('STT error: $error'),
        onStatus: (status) => debugPrint('STT status: $status'),
      );
    } catch (e) {
      debugPrint('STT init exception: $e');
      return false;
    }
  }

  void startListening(Function(String) onResult) {
    try {
      _speech.listen(
        onResult: (result) {
          onResult(result.recognizedWords);
        },
        // ignore: deprecated_member_use
        cancelOnError: true,
      );
    } catch (e) {
      debugPrint('STT listen exception: $e');
    }
  }

  void stopListening() {
    try {
      _speech.stop();
    } catch (e) {
      debugPrint('STT stop exception: $e');
    }
  }

  bool get isListening => _speech.isListening;
}
