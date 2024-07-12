import 'dart:convert';

import 'package:adopsian/class/offers.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

class EditOffer extends StatefulWidget {
  int offerID;
  EditOffer({super.key, required this.offerID});
  @override
  State<StatefulWidget> createState() {
    return _EditOffer();
  }
}

class _EditOffer extends State<EditOffer> {
  final _formKey = GlobalKey<FormState>();

  late PopOffer po;
  TextEditingController _NamaBinatangCont = TextEditingController();
  TextEditingController _JenisHewanCont = TextEditingController();
  TextEditingController _KeteranganCont = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    bacaData();
  }

  bacaData() {
    fetchData().then((value) {
      Map json = jsonDecode(value);
      po = PopOffer.fromJson(json['data']);
      setState(() {
        _NamaBinatangCont.text = po.nama_binatang;
        _JenisHewanCont.text = po.jenis_hewan;
        _KeteranganCont.text = po.keterangan;
        // _releaseDate.text = po.release_date;
        // _runtime = po.runtime;
      });
    });
  }

  Future<String> fetchData() async {
    final response = await http.post(
        Uri.parse("https://ubaya.me/flutter/160420043/uas/Offer_Detail.php"),
        body: {'id': widget.offerID.toString()});
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to read API');
    }
  }

  Future<void> submit() async {
    final response = await http.post(
      Uri.parse("https://ubaya.me/flutter/160420043/uas/Offer_Update.php"),
      body: {
        'id': widget.offerID.toString(),
        'nama_binatang': _NamaBinatangCont.text,
        'jenis_hewan': _JenisHewanCont.text,
        'keterangan': _KeteranganCont.text,
      },
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      if (jsonResponse['result'] == 'success') {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Offer updated successfully')));
        // Navigator.pop(context);
        // Navigator.of(context).pop();
        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(jsonResponse['message'])));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update offer. Try again.')));
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Offer'),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(10),
                child: TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Nama Binatang',
                  ),
                  onChanged: (value) {
                    po.nama_binatang = value;
                  },
                  controller: _NamaBinatangCont,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Nama harus diisi';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child: TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Jenis hewan',
                  ),
                  onChanged: (value) {
                    po.jenis_hewan = value;
                  },
                  controller: _JenisHewanCont,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Jenis hewan harus diisi';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child: TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Keterangan',
                  ),
                  onChanged: (value) {
                    po.keterangan = value;
                  },
                  controller: _KeteranganCont,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Keterangan harus diisi';
                    }
                    return null;
                  },
                ),
              ),
              // Padding(
              //   padding: EdgeInsets.all(10),
              //   child: GestureDetector(
              //     onTap: () {
              //       _showPicker(context);
              //     },
              //     child: _image != null
              //         ? Image.file(_image!)
              //         : Image.network("https://ubaya.me/blank.jpg"),
              //   ),
              // ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: ElevatedButton(
                  onPressed: () {
                    var state = _formKey.currentState;
                    if (state == null || !state.validate()) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Harap Isian diperbaiki')));
                    } else {
                      submit();
                    }
                  },
                  child: Text('Submit'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
