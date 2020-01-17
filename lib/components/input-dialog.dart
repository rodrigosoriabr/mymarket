import 'package:MyMarket/constants/colors.dart';
import 'package:flutter/material.dart';

Future<String> asyncInputDialog(BuildContext context) async {
  String itemName = '';
  return showDialog<String>(
    context: context,
    barrierDismissible: false,
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
