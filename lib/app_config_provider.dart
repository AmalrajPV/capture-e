import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AppConfigProvider with ChangeNotifier {
  final FlutterSecureStorage secureStorage;
  String language;
  String voice;
  double pitch;
  double speechRate;

  AppConfigProvider(this.secureStorage)
      : language = 'en-US',
        voice = 'en-US-male',
        pitch = 1.0,
        speechRate = 0.8 {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    language = await secureStorage.read(key: 'language') ?? language;
    final voiceCode = await secureStorage.read(key: 'voice') ?? voice;
    voice = voiceCode;
    pitch =
        double.tryParse(await secureStorage.read(key: 'pitch') ?? '') ?? pitch;
    speechRate =
        double.tryParse(await secureStorage.read(key: 'speechRate') ?? '') ??
            speechRate;
    notifyListeners();
  }

  Future<void> setLanguage(String language) async {
    this.language = language;
    await secureStorage.write(key: 'language', value: language);
    notifyListeners();
  }

  Future<void> setVoice(voice) async {
    this.voice = voice;
    await secureStorage.write(key: 'voice', value: voice);
    notifyListeners();
  }

  Future<void> setPitch(double pitch) async {
    this.pitch = pitch;
    await secureStorage.write(key: 'pitch', value: pitch.toString());
    notifyListeners();
  }

  Future<void> setSpeechRate(double speechRate) async {
    this.speechRate = speechRate;
    await secureStorage.write(key: 'speechRate', value: speechRate.toString());
    notifyListeners();
  }
}
