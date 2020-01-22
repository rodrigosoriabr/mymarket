import 'package:MyMarket/constants/colors.dart';
import 'package:flutter/material.dart';

Future<Map<String, dynamic>> asyncInputDialog(BuildContext context) async {
  final Map<String, dynamic> result = new Map<String, dynamic>();
  return showDialog<Map<String, dynamic>>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Enter a new item'),
        content: new Wrap(
          children: <Widget>[
            new TextField(
              autofocus: true,
              decoration: new InputDecoration(
                labelText: 'Name',
                hintText: 'eg. Tomato',
              ),
              onChanged: (value) {
                result['title'] = value;
              },
            ),
            new TextField(
              autofocus: true,
              decoration: new InputDecoration(
                labelText: 'Quantity',
                hintText: 'eg. 4 units',
              ),
              onChanged: (value) {
                result['subtitle'] = value;
              },
            ),
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
              if (result['title'] != null) {
                Navigator.of(context).pop(result);
              }
            },
          ),
        ],
      );
    },
  );
}
