import 'dart:convert';
import 'package:MyMarket/components/input-dialog.dart';
import 'package:MyMarket/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:MyMarket/models/item.dart';

var othersItems = new List<Item>();
final tescoKey = "OTHERS_DATA";

class OthersPage extends StatefulWidget {
  @override
  _OthersPageState createState() => _OthersPageState();
}

class _OthersPageState extends State<OthersPage> {
  _OthersPageState() {
    _load();
  }

  void _add(String _title, String _subTitle) {
    if (!mounted) return;
    setState(() {
      othersItems.add(
        Item(
          id: othersItems.length + 1,
          title: _title,
          subtitle: _subTitle,
          done: false,
        ),
      );
      _save();
    });
  }

  void _remove(int index) {
    if (!mounted) return;
    setState(() {
      othersItems.removeAt(index);
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
        othersItems = result;
      });
    }
  }

  _save() async {
    var prefs = await SharedPreferences.getInstance();
    await prefs.setString(tescoKey, jsonEncode(othersItems));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Scrollbar(
          child: ListView.separated(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              separatorBuilder: (context, index) =>
                  Divider(color: Colors.black12),
              itemCount: othersItems.length,
              itemBuilder: (context, index) {
                final item = othersItems[index];
                return Dismissible(
                  child: CheckboxListTile(
                    title: Text(item.title),
                    subtitle: Text(item.subtitle ?? ""),
                    secondary: Icon(
                      Icons.shopping_cart,
                    ),
                    value: item.done,
                    onChanged: (value) {
                      if (!mounted) return;
                      setState(() {
                        item.done = value;
                        _save();
                      });
                    },
                  ),
                  key: Key((othersItems.length + 1).toString()),
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
        color: defaultMaterialColor,
        child: new Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            IconButton(
              icon: Icon(
                Icons.add_circle,
                color: Colors.white,
                size: 32,
              ),
              onPressed: () async {
                var result = await asyncInputDialog(context);
                if (result != null) {
                  _add(result['title'], result['subtitle']);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
