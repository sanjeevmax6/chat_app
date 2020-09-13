import 'package:chat_app/screens/convos.dart';
import 'package:flutter/material.dart';

class Dialogs {
  information(BuildContext context, String title, String description) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(description),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              onPressed: () => Navigator.pop(context),
                child: Text("No")
            ),
            FlatButton(
                onPressed: () => {

                },
                child: Text("Yes")
            ),
          ],
        );
      }
    );
  }
}