import 'package:flutter/material.dart';
import 'Views/AllListsView.dart';


void main() {
  runApp(App());
}

class App extends StatefulWidget {
  App({Key key}) : super(key: key);

  @override
  _AppState createState() => _AppState();
}


class _AppState extends State<App> {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Einkaufslisten',
      home: AllListsView()
    );
  }
}

