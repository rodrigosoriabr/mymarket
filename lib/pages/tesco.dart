import 'dart:convert';
import 'package:MyMarket/components/input-dialog.dart';
import 'package:MyMarket/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:MyMarket/models/item.dart';

var tescoItems = new List<Item>();
final tescoKey = "TESCO_DATA";

class TescoPage extends StatefulWidget {
  @override
  _TescoPageState createState() => _TescoPageState();
}

class _TescoPageState extends State<TescoPage> {
  _TescoPageState() {
    _load();
  }

  void _add(String _title) {
    if (!mounted) return;
    setState(() {
      tescoItems.add(
        Item(
          id: tescoItems.length + 1,
          title: _title,
          done: false,
        ),
      );
      _save();
    });
  }

  void _remove(int index) {
    if (!mounted) return;
    setState(() {
      tescoItems.removeAt(index);
      _save();
    });
  }

  Future _load() async {
    var prefs = await SharedPreferences.getInstance();
    var data = prefs.getString(tescoKey);
    if (data != null) {
      Iterable decoded = jsonDecode(data);
      var result = decoded.map((x) => Item.fromJson(x)).toList();
      if (!mounted) return;
      setState(() {
        tescoItems = result;
      });
    }
  }

  _save() async {
    var prefs = await SharedPreferences.getInstance();
    await prefs.setString(tescoKey, jsonEncode(tescoItems));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Scrollbar(
          child: ListView.separated(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              separatorBuilder: (context, index) =>
                  Divider(color: Colors.black12),
              itemCount: tescoItems.length,
              itemBuilder: (context, index) {
                final item = tescoItems[index];
                return Dismissible(
                  child: CheckboxListTile(
                    title: Text(item.title),
                    secondary: CircleAvatar(child: Text(item.title[0])),
                    value: item.done,
                    onChanged: (value) {
                      if (!mounted) return;
                      setState(() {
                        item.done = value;
                        _save();
                      });
                    },
                  ),
                  key: Key((tescoItems.length + 1).toString()),
                  direction: DismissDirection.endToStart,
                  background: Container(child: null),
                  secondaryBackground: Container(
                    color: Colors.red,
                    child: const ListTile(
                        trailing: const Icon(
                      Icons.delete,
                      color: Colors.white,
                    )),
                  ),
                  onDismissed: (direction) {
                    _remove(index);
                  },
                );
              })),
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        color: defaultMaterialColor,
        notchMargin: 2.0,
        clipBehavior: Clip.antiAlias,
        child: Text(""),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: FloatingActionButton(
        backgroundColor: defaultMaterialColor,
        onPressed: () async {
          var itemName = await asyncInputDialog(context);
          if (itemName != null) {
            _add(itemName);
          }
        },
        tooltip: 'Add new item',
        child: Icon(Icons.add),
      ),
    );
  }
}
