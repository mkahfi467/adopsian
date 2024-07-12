import 'dart:convert';
import 'dart:ui';

import 'package:adopsian/main.dart';
import 'package:adopsian/screen/register.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class MyLogin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Login(),
      routes: {
        'register': (context) => MyRegister(),
      },
    );
  }
}

class Login extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _Login();
  }
}

class _Login extends State<Login> {
  String _user_id = '';
  String _user_password = '';

  String msg_error = '';

  //
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  void doLogin() async {
    if (_formKey.currentState!.validate()) {
      // Perform registration logic here
      // print('Email: ${_emailController.text}');
      // print('Password: ${_passwordController.text}');

      final response = await http.post(
        Uri.parse("https://ubaya.me/flutter/160420043/uas/login.php"),
        body: {
          'username': _emailController.text,
          'password': _passwordController.text
        },
      );
      if (response.statusCode == 200) {
        Map json = jsonDecode(response.body);
        if (json['result'] == 'success') {
          final prefs = await SharedPreferences.getInstance();
          // prefs.setString("user_id", _emailController.text);
          prefs.setString("user_id", json['id'].toString());
          // print(json['id']);
          // prefs.setString("user_name", json['username']);
          main();
          // print('FROM DATABASE : ');
          // print('Email : ${json['user_id']}');
          // print('Email : ${json['user_name']}');
          // print('Email : ${json['user_password']}');
          // print('Email : ${_emailController.text}');
          // print('Email : ${_passwordController.text}');
        } else {
          // setState(() {
          //   msg_error = "Incorrect user or password";
          // });
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Login Failed'),
                content: const Text(
                    'Incorrect username or password'), // Consider using 'message' from response if available
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
        throw Exception('Failed to read API');
      }
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Username',
                      hintText: '',
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
                      border: OutlineInputBorder(),
                      labelText: 'Password',
                      hintText: 'Enter password',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 32,
                  ),
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
                        doLogin();
                      },
                      child: const Text('Login'),
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
                        // Navigator.pushNamed(context, 'register');
                        Navigator.popAndPushNamed(context, 'register');
                      },
                      child: Text("REGISTER!!"),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
