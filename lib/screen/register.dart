import 'dart:convert';

import 'package:adopsian/screen/login.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

class MyRegister extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Register',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Register(),
      routes: {
        'login': (context) => MyLogin(),
      },
    );
  }
}

class Register extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _Register();
  }
}

class _Register extends State<Register> {
  String _user_id = '';
  String _user_password = '';

  String msg_error = '';

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  void doRegister() async {
    if (_formKey.currentState!.validate()) {
      final response = await http.post(
        Uri.parse("https://ubaya.me/flutter/160420043/uas/register.php"),
        body: {
          'name': _nameController.text,
          'username': _usernameController.text,
          'password': _passwordController.text,
        },
      );

      if (response.statusCode == 200) {
        Map json = jsonDecode(response.body);
        if (json['result'] == 'success') {
          // Registration successful, navigate to login screen
          Navigator.popAndPushNamed(context, 'login');
        } else {
          // Registration failed, show alert dialog
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Registration Failed'),
                content: Text(json['message'] ??
                    "Registration failed"), // Use 'message' key from response or default message
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('OK'),
                  ),
                ],
              );
            },
          );
        }
      } else {
        // Network error, handle appropriately
        throw Exception('Failed to register');
      }
    } else {
      print(
          "Form is invalid"); // Consider a more informative message for the user
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              // crossAxisAlignment: CrossAxisAlignment.start,
              // mainAxisAlignment: MainAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Name',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your username';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: _usernameController,
                  decoration: const InputDecoration(
                    labelText: 'Username',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 32.0),
                SizedBox(
                  height: 32.0,
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.blue,
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        // Perform registration logic here
                        doRegister();
                        print('Nama: ${_nameController.text}');
                        print('Email: ${_usernameController.text}');
                        print('Password: ${_passwordController.text}');
                      }
                    },
                    child: const Text('Register'),
                  ),
                ),
                const SizedBox(
                  height: 32,
                ),
                SizedBox(
                  height: 32.0,
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () {
                      // Navigator.pushNamed(context, 'login');
                      // Navigator.pop(context);
                      Navigator.popAndPushNamed(context, 'login');
                    },
                    child: Text("LOGIN!!"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
