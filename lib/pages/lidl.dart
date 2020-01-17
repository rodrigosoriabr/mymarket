import 'dart:convert';
import 'package:MyMarket/components/input-dialog.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
              padding: const EdgeInsets.all(16.0),
              separatorBuilder: (context, index) =>
                  Divider(color: Colors.black12),
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
      floatingActionButton: FloatingActionButton(
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
