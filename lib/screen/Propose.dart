import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:http/http.dart' as http;

class NewPropose extends StatefulWidget {
  int offerID;
  NewPropose({super.key, required this.offerID});
  @override
  State<StatefulWidget> createState() {
    return _NewPropose();
  }
}

class _NewPropose extends State<NewPropose> {
  final _formKey = GlobalKey<FormState>();
  final _PesanController = TextEditingController();
  // final _jenisHewanController = TextEditingController();
  // final _keteranganController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getUserId().then((value) {
      activeUserId = value;
      // bacaData();
    });
    // bacaData();
  }

  Future<String> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_id') ?? '';
  }

  String activeUserId = '';

  void doAddPropose() async {
    if (_formKey.currentState!.validate()) {
      final response = await http.post(
        Uri.parse("https://ubaya.me/flutter/160420043/uas/Propose_Add.php"),
        body: {
          'user_id': activeUserId,
          'offer_id': widget.offerID.toString(),
          'pesan': _PesanController.text,
          // 'nama_binatang': _namaBinatangController.text,
          // 'jenis_hewan': _jenisHewanController.text,
          // 'keterangan': _keteranganController.text,
        },
      );

      // print('Response status: ${response.statusCode}'); // Tambahkan ini
      // print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        print('run');
        Map json = jsonDecode(response.body);
        if (json['result'] == 'success') {
          // Registration successful, navigate to login screen
          // Navigator.popAndPushNamed(context, 'login');
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) => NewPropose(),
          //   ),
          // );
          Navigator.pop(context);
        } else {
          // Registration failed, show alert dialog
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Add propose Failed'),
                content: Text(json['message'] ??
                    "Add propose failed"), // Use 'message' key from response or default message
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
        throw Exception('Failed to add propose');
      }
    } else {
      print(
          "Form is invalid"); // Consider a more informative message for the user
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Propose'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                controller: _PesanController,
                decoration: InputDecoration(
                    labelText: 'Pesan pinangan adopsi Binatang'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
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
                      doAddPropose();
                    }
                  },
                  child: const Text('Add Propose'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
