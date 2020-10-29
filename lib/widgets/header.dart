import 'package:flutter/material.dart';

AppBar header(context, {bool isAppTitle = false, String titleText,bool removeBackButton=false}) {
  return AppBar(
    automaticallyImplyLeading: removeBackButton ? false : true,
    title: isAppTitle
        ? Text(
            'FlutterShare',
            style: TextStyle(
                color: Colors.white, fontFamily: 'Signatra', fontSize: 50),
          )
        : Text(
            titleText,
            style: TextStyle(color: Colors.white, fontSize: 22.0),
          ),
    centerTitle: true,
    backgroundColor: Theme.of(context).accentColor,
  );
}
