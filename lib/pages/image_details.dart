import 'package:capture_app/app_config_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:provider/provider.dart';

class ImageDetailsPage extends StatefulWidget {
  final String imageUrl;
  final String extractedText;

  const ImageDetailsPage({
    Key? key,
    required this.imageUrl,
    required this.extractedText,
  }) : super(key: key);

  @override
  ImageDetailsPageState createState() => ImageDetailsPageState();
}

class ImageDetailsPageState extends State<ImageDetailsPage> {
  bool isSpeaking = false;
  FlutterTts flutterTts = FlutterTts();

  void _speak(String text) async {
    final appConfigProvider =
        Provider.of<AppConfigProvider>(context, listen: false);
    await flutterTts.setLanguage(appConfigProvider.language);
    await flutterTts.setPitch(appConfigProvider.pitch);
    await flutterTts.setSpeechRate(appConfigProvider.speechRate);

    if (!isSpeaking) {
      setState(() {
        isSpeaking = true;
      });

      await flutterTts.speak(text);
    } else {
      setState(() {
        isSpeaking = false;
      });

      await flutterTts.stop();
    }
  }

  @override
  void initState() {
    super.initState();

    flutterTts.setCompletionHandler(() {
      setState(() {
        isSpeaking = false;
      });
    });
  }

  @override
  void dispose() {
    flutterTts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Image Details',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF24293D),
        actions: [
          IconButton(
            onPressed: () {
              Clipboard.setData(ClipboardData(text: widget.extractedText));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Text copied to clipboard'),
                  duration: Duration(seconds: 3),
                ),
              );
            },
            icon: const Icon(
              Icons.copy,
              color: Colors.white,
            ),
          ),
          IconButton(
            onPressed: () {
              _speak(widget.extractedText);
            },
            icon: Icon(
              isSpeaking ? Icons.stop : Icons.volume_up,
              color: Colors.white,
            ),
          ),
        ],
      ),
      backgroundColor: const Color(0xFF24293D),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.network(
                widget.imageUrl,
                width: 200,
                height: 200,
              ),
              const SizedBox(height: 20),
              const Text(
                'Extracted Text:',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 10),
              Container(
                color: const Color(0xff2F3855),
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    widget.extractedText,
                    style: const TextStyle(fontSize: 14, color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
