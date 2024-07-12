import 'dart:convert';

import 'package:adopsian/class/offers.dart';
import 'package:adopsian/screen/Browse_Detail.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

class Browse extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _Browse();
  }
}

class _Browse extends State<Browse> {
  @override
  void initState() {
    super.initState();
    bacaData();
  }

  List<PopOffer> PMs = [];

  bacaData() {
    PMs.clear();
    Future<String> data = fetchData();
    data.then((value) {
      Map json = jsonDecode(value);
      for (var offer in json['data']) {
        PopOffer po = PopOffer.fromJson(offer);
        PMs.add(po);
      }

      setState(() {});
    });
  }

  Future<String> fetchData() async {
    final response = await http.post(
        Uri.parse("https://ubaya.me/flutter/160420043/uas/Offer_List.php"),
        body: {});
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to read API');
    }
  }

  Widget DaftarPopOffer(PopOffer) {
    if (PopOffer != null) {
      return ListView.builder(
          itemCount: PopOffer.length,
          itemBuilder: (BuildContext ctxt, int index) {
            return Card(
                child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ListTile(
                  leading: const Icon(Icons.pets, size: 30),
                  title: GestureDetector(
                      child: Text(PMs[index].nama_binatang),
                      onTap: () {
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) => DetailPop(
                        //       movieID: PMs[index].id,
                        //       refreshCallback: refreshData,
                        //     ),
                        //   ),
                        // );
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetailBrowse(
                              offerID: PMs[index].id,
                              // refreshCallback: refreshData,
                              refreshCallback: () => bacaData(),
                            ),
                          ),
                        );
                      }),
                  subtitle: Text(PopOffer[index].keterangan),
                ),
              ],
            ));
          });
    } else {
      return CircularProgressIndicator();
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Browse'),
      ),
      body: ListView(
        children: <Widget>[
          TextFormField(
            decoration: const InputDecoration(
              icon: Icon(Icons.search),
              labelText: 'Judul mengandung kata:',
            ),
            onFieldSubmitted: (value) {
              // _txtcari = value;
              bacaData();
            },
          ),
          Container(
            height: MediaQuery.of(context).size.height,
            child: DaftarPopOffer(PMs),
          )
        ],
      ),
    );
  }
}
