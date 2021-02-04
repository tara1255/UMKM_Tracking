import 'package:flutter/material.dart';

import './list_bidang_usaha.dart' as listbidangusaha;
import './tempat_terdekat.dart' as tempatterdekat;
import './peta.dart' as petausaha;
import 'my_here_map.dart';

class Home extends StatefulWidget {
  @override
  HomePage createState() => HomePage();
}

class HomePage extends State<Home> with SingleTickerProviderStateMixin {
  TabController controller;

  @override
  void initState() {
    controller = new TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        backgroundColor: Colors.amber,
        title: new Text("Pemetaan UMKM"),
        bottom: new TabBar(
          controller: controller,
          tabs: <Widget>[
            new Tab(
              child: Text("Bidang Usaha UMKM"),
            ),
            new Tab(
              child: Text("Tempat Terdekat"),
            ),
            new Tab(
              child: Text("Peta lokasi UMKM"),
            ),
          ],
        ),
      ),
      // drawer: new Drawer(
      //     child: new ListView(
      //   children: <Widget>[
      //     new UserAccountsDrawerHeader(
      //       accountName: new Text("Restu Panji Amarta"),
      //       accountEmail: new Text("panjirestu29@gmail.com"),
      //       currentAccountPicture: new CircleAvatar(),
      //     ),
      //     new ListTile(
      //       trailing: new Icon(Icons.settings),
      //       title: new Text("Setting"),
      //     ),
      //     new ListTile(
      //       trailing: new Icon(Icons.logout),
      //       title: new Text("Logout"),
      //     ),
      //   ],
      // )),
      body: new TabBarView(
        controller: controller,
        children: [
          listbidangusaha.ListBidangUsaha(),
          tempatterdekat.TempatTerdekat(),
          // petausaha.PetaUsaha(),
          MyHereMap(),
        ],
      ),
    );
  }
}
