// ignore_for_file: file_names

// ignore: depend_on_referenced_packages
import 'package:smarthomeproject/algorytm/smartDevice.dart';
// ignore: depend_on_referenced_packages
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:smarthomeproject/algorytm/globalValue.dart' as globals;

stt.SpeechToText _speech = stt.SpeechToText();

void listenSpeak(SmartDevice sd, void Function(String value) setVariable,
    void Function(bool value) setVariable2) async {
  if (!sd.isListening) {
    bool available = await _speech.initialize(
      // ignore: avoid_print
      onStatus: (val) => print('onStatus: $val'),
      // ignore: avoid_print
      onError: (val) => print('onError: $val'),
    );
    if (available) {
      sd.isListening = true;
      setVariable2(sd.isListening);
      _speech.listen(
        localeId: globals.systemLocale == 'ru'
            ? 'ru_RU'
            : globals.systemLocale == 'pl'
                ? 'pl_PL'
                : 'en_US',
        onResult: (val) {
          sd.textSpeech = val.recognizedWords;
          setVariable(sd.textSpeech);
          /*if (val.hasConfidenceRating && val.confidence > 0) {
            _confidence = val.confidence;
          }*/
        },
      );
    }
  } else {
    sd.isListening = false;
    setVariable2(sd.isListening);
    _speech.stop();
  }
}
