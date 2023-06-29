// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:io';
import 'package:capture_app/app_config_provider.dart';
import 'package:capture_app/constants/const.dart';
import 'package:capture_app/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class ScanPage extends StatefulWidget {
  const ScanPage({Key? key}) : super(key: key);

  @override
  State<ScanPage> createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  XFile? _image;
  bool isSoundOn = false;
  FlutterTts flutterTts = FlutterTts();
  final TextEditingController _text = TextEditingController();
  bool isLoading = false;

  void _myAlert() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          title: const Text('Please choose media to select'),
          content: SizedBox(
            height: MediaQuery.of(context).size.height / 6,
            child: Column(
              children: [
                ElevatedButton(
                  //if user click this button, user can upload image from gallery
                  onPressed: () {
                    Navigator.pop(context);
                    _selectImage(ImageSource.gallery);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF24293D),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.image, color: Colors.white),
                      Text(
                        'From Gallery',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _selectImage(ImageSource.camera);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF24293D),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.camera, color: Colors.white),
                      Text(
                        'From Camera',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _selectImage(ImageSource src) async {
    final pickedFile = await ImagePicker().pickImage(source: src);
    setState(() {
      _image = pickedFile;
    });
  }

  void _speak(String text) async {
    if (isSoundOn) {
      final appConfigProvider =
          Provider.of<AppConfigProvider>(context, listen: false);
      await flutterTts.setLanguage(appConfigProvider.language);
      await flutterTts.setPitch(appConfigProvider.pitch);
      await flutterTts.setSpeechRate(appConfigProvider.speechRate);
      await flutterTts.speak(text);
    }
  }

  void _extractText() async {
    const apiUrl = '${Url.baseUrl}/ocr-data';

    try {
      final request = http.MultipartRequest('POST', Uri.parse(apiUrl));

      final imageField =
          await http.MultipartFile.fromPath('image', _image!.path);
      request.files.add(imageField);
      final token = await AuthService().getToken();
      request.headers.addAll({
        'Authorization': 'Bearer $token',
        'Content-Type': 'multipart/form-data'
      });

      final response = await request.send();

      if (response.statusCode == 201) {
        final responseBody = await response.stream.bytesToString();
        final parsedResponse = json.decode(responseBody);
        _text.text = parsedResponse['text'];
      } else {
        const snackBar = SnackBar(
          content: Text('Something went wrong...'),
          duration: Duration(seconds: 3),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    } catch (e) {
      const snackBar = SnackBar(
        content: Text('Something went wrong...'),
        duration: Duration(seconds: 3),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFF24293D),
        title: const Text(
          "CAPTURE-E",
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/profile');
            },
            icon: const Icon(
              Icons.person_2_sharp,
              color: Colors.white,
            ),
          ),
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/settings');
            },
            icon: const Icon(
              Icons.settings,
              color: Colors.white,
            ),
          ),
          IconButton(
            onPressed: () async {
              await AuthService().logout();
              Navigator.popAndPushNamed(context, '/login');
            },
            icon: const Icon(
              Icons.logout,
              color: Colors.white,
            ),
          ),
        ],
      ),
      backgroundColor: const Color(0xFF24293D),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        child: SingleChildScrollView(
          child: Column(
            children: [
              GestureDetector(
                onTap: _myAlert,
                child: Container(
                  height: 300,
                  decoration: BoxDecoration(
                    color: const Color(0xff2F3855),
                    border: Border.all(color: const Color(0xFF24293D)),
                    image: _image != null
                        ? DecorationImage(
                            image: FileImage(File(_image!.path)),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: _image == null
                      ? const Center(
                          child: Icon(
                            Icons.photo,
                            size: 100,
                            color: Colors.white,
                          ),
                        )
                      : null,
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                      onPressed: () {
                        if (!isLoading) {
                          if (_image != null) {
                            setState(() {
                              isLoading = true;
                            });
                            _extractText();
                            setState(() {
                              isLoading = false;
                            });
                          } else {
                            const snackBar = SnackBar(
                              content: Text('Select an Image'),
                              duration: Duration(seconds: 3),
                            );
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF8EBBFF),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      child: !isLoading
                          ? const Padding(
                              padding: EdgeInsets.symmetric(vertical: 15),
                              child: Text(
                                "Extract text",
                                style: TextStyle(color: Colors.white),
                              ),
                            )
                          : const Center(
                              child: CircularProgressIndicator(),
                            )),
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              Row(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: SizedBox(
                        height: 200,
                        child: TextField(
                          controller: _text,
                          maxLines: 500,
                          readOnly: true,
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                            hintStyle: TextStyle(color: Color(0xFFFFFFFF)),
                            filled: true,
                            fillColor: Color(0xFF2F3855),
                            hintText: 'Scan image to get text...',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.zero,
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      IconButton(
                        onPressed: () {
                          setState(() {
                            _image = null;
                            _text.text = "";
                          });
                          flutterTts.stop();
                        },
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.white,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          Clipboard.setData(ClipboardData(text: _text.text));
                          const snackBar = SnackBar(
                            content: Text('Text copied to clipboard'),
                            duration: Duration(seconds: 3),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        },
                        icon: const Icon(
                          Icons.copy,
                          color: Colors.white,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            isSoundOn = true;
                          });
                          _speak(_text.text);
                          setState(() {
                            isSoundOn = false;
                          });
                        },
                        icon: const Icon(Icons.volume_up, color: Colors.white),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
