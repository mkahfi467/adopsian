import 'dart:convert';

import 'package:adopsian/class/offers.dart';
import 'package:adopsian/screen/offer_detail.dart';
import 'package:adopsian/screen/offer_new.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Offer extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _Offer();
  }
}

class _Offer extends State<Offer> {
  @override
  void initState() {
    super.initState();
    getUserId().then((value) {
      activeUserId = value;
      bacaData();
    });
    // bacaData();
  }

  String activeUserId = '';

  List<PopOffer> PMs = [];

  void refreshData() {
    bacaData();
  }

  Future<String> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_id') ?? '';
  }

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
        Uri.parse("https://ubaya.me/flutter/160420043/uas/Offer_by_User.php"),
        body: {
          'user_id': activeUserId.toString(),
        });
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
                  leading: const Icon(Icons.movie, size: 30),
                  title: GestureDetector(
                      child: Text(PMs[index].nama_binatang),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetailOffer(
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
        title: const Text('Offer'),
      ),
      body: ListView(
        children: <Widget>[
          // Text(activeUserId),
          Container(
            height: MediaQuery.of(context).size.height,
            child: DaftarPopOffer(PMs),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NewOffer(),
            ),
          );
        },
        tooltip: '',
        child: const Icon(Icons.add),
      ),
    );
  }
}
