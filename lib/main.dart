import 'package:flutter/material.dart';
import 'pages/aldi.dart';
import 'pages/lidl.dart';
import 'pages/tesco.dart';
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
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            title: Text("MyMarket List"),
            bottom: TabBar(
              indicatorWeight: 5,
              indicatorColor: defaultMaterialColor[900],
              tabs: [
                Tab(text: "TESCO"),
                Tab(text: "LIDL"),
                Tab(text: "ALDI"),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              TescoPage(),
              LidlPage(),
              AldiPage(),
            ],
          ),
        ),
      ),
    );
    return materialApp;
  }
}
