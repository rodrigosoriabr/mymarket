import 'package:MyMarket/pages/others.dart';
import 'package:flutter/material.dart';
import 'pages/aldi.dart';
import 'pages/lidl.dart';
import 'pages/tesco.dart';
import 'pages/others.dart';
import 'constants/colors.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var materialApp = MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MyMarket',
      theme: ThemeData(
        primarySwatch: defaultMaterialColor,
        bottomAppBarColor: defaultMaterialColor,
      ),
      home: DefaultTabController(
        length: 4,
        child: Scaffold(
          appBar: AppBar(
            title: Text("MyMarket List"),
            leading: Icon(
              Icons.shopping_cart,
              color: Colors.white,
            ),
            titleSpacing: 0.0,
            bottom: TabBar(
              indicatorWeight: 5,
              indicatorColor: defaultMaterialColor[900],
              tabs: [
                Tab(text: "TESCO"),
                Tab(text: "LIDL"),
                Tab(text: "ALDI"),
                Tab(text: "Others"),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              TescoPage(),
              LidlPage(),
              AldiPage(),
              OthersPage(),
            ],
          ),
        ),
      ),
    );
    return materialApp;
  }
}
