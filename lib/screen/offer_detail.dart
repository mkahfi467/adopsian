import 'dart:convert';

import 'package:adopsian/class/offers.dart';
import 'package:adopsian/screen/offer_edit.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

class DetailOffer extends StatefulWidget {
  int offerID;
  final Function() refreshCallback;
  DetailOffer(
      {super.key, required this.offerID, required this.refreshCallback});
  @override
  State<StatefulWidget> createState() {
    return _DetailOffer();
  }
}

class _DetailOffer extends State<DetailOffer> {
  PopOffer? _po;
  @override
  void initState() {
    super.initState();
    bacaData();
  }

  @override
  void dispose() {
    widget.refreshCallback();
    super.dispose();
  }

  bacaData() {
    fetchData().then((value) {
      Map json = jsonDecode(value);
      _po = PopOffer.fromJson(json['data']);
      setState(() {});
    });
  }

  Future<String> fetchData() async {
    print('Sending request for offerID: ${widget.offerID}');
    final response = await http.post(
      Uri.parse("https://ubaya.me/flutter/160420043/uas/Offer_Detail.php"),
      body: {'id': widget.offerID.toString()},
    );

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to read API: ${response.statusCode}');
    }
  }

  Future<void> deleteData() async {
    final response = await http.post(
      Uri.parse("https://ubaya.me/flutter/160420043/uas/Offer_Delete.php"),
      body: {'id': widget.offerID.toString()},
    );

    if (response.statusCode == 200) {
      Map json = jsonDecode(response.body);
      if (json['result'] == 'success') {
        Navigator.pop(context, true); // Kembali ke halaman sebelumnya
      } else {
        showErrorDialog(context, json['message']);
      }
    } else {
      throw Exception('Failed to delete API: ${response.statusCode}');
    }
  }

  Future<void> navigateToEdit() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditOffer(offerID: widget.offerID),
      ),
    );

    if (result == true) {
      // Jika hasil dari halaman EditOffer adalah true, refresh data
      bacaData();
    }
  }

  void showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget tampilData() {
    if (_po == null) {
      return const CircularProgressIndicator();
    }
    return Card(
      elevation: 10,
      margin: const EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          Text(_po!.nama_binatang, style: const TextStyle(fontSize: 25)),
          Image.network(
              "https://ubaya.me/flutter/160420043/images/${widget.offerID}.jpg"),
          Padding(
              padding: const EdgeInsets.all(10),
              child:
                  Text(_po!.jenis_hewan, style: const TextStyle(fontSize: 15))),
          Padding(
              padding: const EdgeInsets.all(10),
              child:
                  Text(_po!.keterangan, style: const TextStyle(fontSize: 15))),
          Padding(
            padding: EdgeInsets.all(5),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                child: Text('Edit'),
                onPressed: () {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) => EditOffer(offerID: widget.offerID),
                  //   ),
                  // );
                  navigateToEdit();
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  deleteData();
                },
                child: Text(
                  'DELETE',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Offer'),
      ),
      body: ListView(
        children: <Widget>[
          tampilData(),
        ],
      ),
    );
  }
}
