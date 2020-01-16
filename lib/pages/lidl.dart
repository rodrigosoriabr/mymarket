import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:MyMarket/constants/colors.dart';
import 'package:MyMarket/models/item.dart';

var lidlItems = new List<Item>();
final lidlKey = "LIDL_DATA";

class LidlPage extends StatefulWidget {
  @override
  _LidlPageState createState() => _LidlPageState();
}

class _LidlPageState extends State<LidlPage> {
  _LidlPageState() {
    _load();
  }

  Future<String> _asyncInputDialog(BuildContext context) async {
    String itemName = '';
    return showDialog<String>(
      context: context,
      barrierDismissible:
          false, // dialog is dismissible with a tap on the barrier
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Enter a new item'),
          content: new Row(
            children: <Widget>[
              new Expanded(
                  child: new TextField(
                autofocus: true,
                decoration: new InputDecoration(
                  labelText: 'Item name',
                  hintText: 'eg. Tomato',
                ),
                onChanged: (value) {
                  itemName = value;
                },
              ))
            ],
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(null);
              },
            ),
            FlatButton(
              child: Text('Ok'),
              color: defaultMaterialColor,
              onPressed: () {
                if (itemName != "") {
                  Navigator.of(context).pop(itemName);
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _add(String _title) {
    if (!mounted) return;
    setState(() {
      lidlItems.add(
        Item(
          id: lidlItems.length + 1,
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
      lidlItems.removeAt(index);
      _save();
    });
  }

  Future _load() async {
    var prefs = await SharedPreferences.getInstance();
    var data = prefs.getString(lidlKey);
    if (data != null) {
      Iterable decoded = jsonDecode(data);
      var result = decoded.map((x) => Item.fromJson(x)).toList();
      if (!mounted) return;
      setState(() {
        lidlItems = result;
      });
    }
  }

  _save() async {
    var prefs = await SharedPreferences.getInstance();
    await prefs.setString(lidlKey, jsonEncode(lidlItems));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: ListView.separated(
              separatorBuilder: (context, index) => Divider(
                    color: Colors.black12,
                  ),
              itemCount: lidlItems.length,
              itemBuilder: (context, index) {
                final item = lidlItems[index];
                return Dismissible(
                  child: CheckboxListTile(
                    secondary: Icon(Icons.shopping_cart),
                    title: Text(item.title),
                    value: item.done,
                    onChanged: (value) {
                      if (!mounted) return;
                      setState(() {
                        item.done = value;
                        _save();
                      });
                    },
                  ),
                  key: Key((lidlItems.length + 1).toString()),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    color: Colors.green,
                    child: Icon(Icons.check),
                  ),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          var itemName = await _asyncInputDialog(context);
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
