// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'package:capture_app/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';
import 'package:http/http.dart' as http;
import 'package:capture_app/constants/const.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF24293D),
      appBar: AppBar(
        title: const Text(
          'Change Password',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF24293D),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(
                height: 30,
              ),
              TextFormField(
                  controller: _oldPasswordController,
                  decoration: const InputDecoration(
                      labelText: "Old password",
                      iconColor: Color(0xFFCCCCCC),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFFCCCCCC)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFFCCCCCC)),
                      ),
                      prefixIcon: Icon(
                        Icons.email,
                        color: Color(0xFFCCCCCC),
                      ),
                    ),
                  obscureText: true,
                  validator: ValidationBuilder().required().build()),
              const SizedBox(
                height: 30,
              ),
              TextFormField(
                  controller: _newPasswordController,
                  decoration: const InputDecoration(
                      labelText: "New password",
                      iconColor: Color(0xFFCCCCCC),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFFCCCCCC)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFFCCCCCC)),
                      ),
                      prefixIcon: Icon(
                        Icons.email,
                        color: Color(0xFFCCCCCC),
                      ),
                    ),
                  obscureText: true,
                  validator: ValidationBuilder().required().build()),
              const SizedBox(
                height: 50,
              ),
              SizedBox(
                height: 60,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _changePassword();
                    }
                  },
                  child: const Text('Change Password'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _changePassword() async {
    final oldPassword = _oldPasswordController.text;
    final newPassword = _newPasswordController.text;
    final token = await AuthService().getToken();

    final response =
        await http.post(Uri.parse('${Url.baseUrl}/change-password'), body: {
      'old_password': oldPassword,
      'new_password': newPassword,
    }, headers: {
      "Authorization": "Bearer $token"
    });
    if (response.statusCode == 200) {
      const snackBar = SnackBar(
        content: Text('Password changed successfuly'),
        duration: Duration(seconds: 3),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      Navigator.pop(context);
    } else {
      const snackBar = SnackBar(
        content: Text('Something went wrong ...!'),
        duration: Duration(seconds: 3),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }
}
