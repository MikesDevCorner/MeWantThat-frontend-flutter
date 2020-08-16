import 'package:ShoppingList_Flutter/Views/LoginView.dart';
import 'package:ShoppingList_Flutter/Views/NewEntryView.dart';
import 'package:ShoppingList_Flutter/Views/NewListView.dart';
import 'package:ShoppingList_Flutter/Views/RegisterView.dart';
import 'package:ShoppingList_Flutter/Views/SingleListView.dart';
import 'package:flutter/material.dart';
import 'Views/AllListsView.dart';
import './Libs/AuthService.dart';
import './Libs/ThemeService.dart';

void main() {
  runApp(App());
}

class App extends StatefulWidget {
  App({Key key}) : super(key: key);

  @override
  _AppState createState() => _AppState();
}


class _AppState extends State<App> {

  bool alreadyInitiated = false;

  @override
  void initState() {
    doInitiation();
    super.initState();
  }

  doInitiation() async {
    alreadyInitiated = await AuthService.init();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if(alreadyInitiated == false) return new Container(color: ThemeService.prime);
    else return MaterialApp(
      title: 'Shopping Lists',
      initialRoute: '/',
      routes: {
        '/': (context) => AuthService.isAuth() ? AllListsView() : LoginView(),
        '/login': (context) => LoginView(),
        '/register': (context) => RegisterView(),
        '/single-list': (context) => AuthService.isAuth() ? SingleListView() : LoginView(),
        '/new-list': (context) => AuthService.isAuth() ? NewListView() : LoginView(),
        '/new-entry': (context) => AuthService.isAuth() ? NewEntryView() : LoginView()
      },
      theme: ThemeService.getTheme(context),
    );
  }
}

