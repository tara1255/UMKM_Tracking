import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ListBidangUsaha extends StatefulWidget {
  @override
  _ListBidangUsahaState createState() => new _ListBidangUsahaState();
}

class _ListBidangUsahaState extends State<ListBidangUsaha> {
  Future<List> getData() async {
    // final response = await http.get("http://192.168.43.74/umkm/getdata.php");
    // return json.decode(response.body);
    final res = [
      {
        "id": "0",
        "nama_usaha": "Oak's Cafe & Resto",
        "profil": "tess",
        "alamat_usaha": "Majalengka",
        "bidang_usaha": "Pengolahan makanan",
        "latitude": "-6.835478977954564",
        "longitude": "108.23205821878568",
        "gambar": ""
      },
      {
        "id": "1",
        "nama_usaha": "BJ-Cell",
        "profil": "tess",
        "alamat_usaha": "Majalengka",
        "bidang_usaha": "Pengolahan makanan",
        "latitude": "-6.8371549056353516",
        "longitude": "108.23307097586108",
        "gambar": ""
      },
      {
        "id": "2",
        "nama_usaha": "Ijopink Cutting Sticker",
        "profil": "tess",
        "alamat_usaha": "Majalengka",
        "bidang_usaha": "Pengolahan makanan",
        "latitude": "-6.834748095178841",
        "longitude": "108.21611639877146",
        "gambar": ""
      }
    ];
    return res;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: Text('Bidang Usaha'),
      ),
      body: new FutureBuilder<List>(
          future: getData(),
          builder: (context, snapshot) {
            if (snapshot.hasError) print(snapshot.error);

            return snapshot.hasData
                ? new ItemList(
                    list: snapshot.data,
                  )
                : new Center(
                    child: new CircularProgressIndicator(),
                  );
          }),
    );
  }
}

class ItemList extends StatelessWidget {
  final List list;
  ItemList({this.list});

  @override
  Widget build(BuildContext context) {
    return new ListView.builder(
      itemCount: list == null ? 0 : list.length,
      itemBuilder: (context, i) {
        return new Container(
          padding: const EdgeInsets.all(10.0),
          child: new Card(
            child: new ListTile(
              title: new Text(list[i]['nama_usaha']),
              leading: new Icon(Icons.widgets),
              subtitle: new Text("Jumlah :"),
            ),
          ),
        );
      },
    );
  }
}
