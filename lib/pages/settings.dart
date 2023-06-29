import 'package:capture_app/app_config_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

enum TtsLanguage {
  english,
  spanish,
}

enum TtsVoice {
  male,
  female,
}

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  SettingsPageState createState() => SettingsPageState();
}

class SettingsPageState extends State<SettingsPage> {
  TtsLanguage selectedLanguage = TtsLanguage.english;
  TtsVoice selectedVoice = TtsVoice.male;
  double pitch = 1.0;
  double speechRate = 0.8;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  void _loadSettings() {
    final appConfigProvider =
        Provider.of<AppConfigProvider>(context, listen: false);
    selectedLanguage = _getLanguageFromCode(appConfigProvider.language);
    selectedVoice = _getVoiceFromCode(appConfigProvider.voice);
    pitch = appConfigProvider.pitch;
    speechRate = appConfigProvider.speechRate;
  }

  void _configureTts() {
    final appConfigProvider =
        Provider.of<AppConfigProvider>(context, listen: false);
    final languageCode = _getLanguageCode(selectedLanguage);
    final voiceCode = _getVoiceCode(selectedVoice);
    appConfigProvider.setLanguage(languageCode);
    appConfigProvider.setVoice(voiceCode);
    appConfigProvider.setPitch(pitch);
    appConfigProvider.setSpeechRate(speechRate);
  }

  TtsLanguage _getLanguageFromCode(String? code) {
    if (code == 'es-ES') {
      return TtsLanguage.spanish;
    }
    return TtsLanguage.english;
  }

  TtsVoice _getVoiceFromCode(String? code) {
    if (code == 'en-US-female') {
      return TtsVoice.female;
    }
    return TtsVoice.male;
  }

  String _getLanguageCode(TtsLanguage language) {
    return language == TtsLanguage.spanish ? 'es-ES' : 'en-US';
  }

  String _getVoiceCode(TtsVoice voice) {
    return voice == TtsVoice.female ? 'en-US-female' : 'en-US-male';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF24293D),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      backgroundColor: const Color(0xFF24293D),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Language:',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            DropdownButton<TtsLanguage>(
              value: selectedLanguage,
              onChanged: (value) {
                setState(() {
                  selectedLanguage = value!;
                  _configureTts();
                });
              },
              items: const [
                DropdownMenuItem(
                  value: TtsLanguage.english,
                  child: Text('English', style: TextStyle(color: Colors.white)),
                ),
                DropdownMenuItem(
                  value: TtsLanguage.spanish,
                  child: Text('Spanish', style: TextStyle(color: Colors.white)),
                ),
              ],
              dropdownColor: const Color(0xFF24293D),
            ),
            const SizedBox(height: 20),
            const Text(
              'Pitch:',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            Slider(
              value: pitch,
              min: 0.5,
              max: 2.0,
              divisions: 15,
              onChanged: (value) {
                setState(() {
                  pitch = value;
                  _configureTts();
                });
              },
              activeColor: Colors.white,
              inactiveColor: Colors.white70,
            ),
            Text('Pitch: $pitch', style: const TextStyle(color: Colors.white)),
            const SizedBox(height: 20),
            const Text(
              'Speech Rate:',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            Slider(
              value: speechRate,
              min: 0.5,
              max: 2.0,
              divisions: 15,
              onChanged: (value) {
                setState(() {
                  speechRate = value;
                  _configureTts();
                });
              },
              activeColor: Colors.white,
              inactiveColor: Colors.white70,
            ),
            Text('Speech Rate: $speechRate',
                style: const TextStyle(color: Colors.white)),
          ],
        ),
      ),
    );
  }
}
