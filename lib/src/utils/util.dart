import 'package:flutter/material.dart';

bool isNumeric(String s) {
  if (s.isEmpty) return false;

  final n = num.parse(s);

  return (n == null) ? false : true;
}

void showAlert(BuildContext context, String message) {
  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Incorrect information'),
          content: Text(message),
          actions: [
            FlatButton(
                onPressed: () => Navigator.of(context).pop(), child: Text('ok'))
          ],
        );
      });
}
