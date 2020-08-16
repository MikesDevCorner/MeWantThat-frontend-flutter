import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
//import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../Libs/ApiService.dart';

class LoginView extends StatefulWidget {

  LoginView({Key key}) : super(key: key);

  @override
  LoginViewState createState() {
    return LoginViewState();
  }

}

class LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();
  LoginViewState() : super();
  final myEMailController = TextEditingController();
  final myPasswordController = TextEditingController();
  bool _autoValidate = false;

  void _validateInputs (BuildContext ctxt) async {
    if (_formKey.currentState.validate()) {
      bool login = false;
      login = await ApiService.login(myEMailController.text, myPasswordController.text);
      if(!login) {
        Scaffold.of(ctxt).showSnackBar(SnackBar(content:
        Text('Please check username and password and try again')));
      } else {
        Scaffold.of(ctxt).showSnackBar(SnackBar(content:
        Text('Login Successful')));
        Navigator.pushNamedAndRemoveUntil(context,
            '/', (route) => false);
      }
    } else {
      //If all data are not valid then start auto validation.
      Scaffold.of(ctxt).showSnackBar(SnackBar(content:
      Text('Please check your input fields')));
      setState(() {
        _autoValidate = true;
      });
    }
  }

  String validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return 'Enter Valid Email';
    else
      return null;
  }

  String validatePassword(String value) {
      return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        body: SingleChildScrollView(
          child:Builder(
            builder: (ctxt) => Center(
              child: Padding(
                padding: const EdgeInsets.all(35.0),
                child:Form(
                  key: _formKey,
                  autovalidate: _autoValidate,
                  child: Column(
                    children: <Widget>[
                      new SizedBox(
                        height: 40.0,
                      ),
                      //Text('Shopping List', style: Theme.of(context).primaryTextTheme.headline3),
                      Image.asset('assets/logosm.png', height: 200, filterQuality:FilterQuality.high),
                      new SizedBox(
                        height: 40.0,
                      ),
                      TextFormField(
                        style: TextStyle(color: Theme.of(context).backgroundColor),
                        decoration: InputDecoration(labelText: 'E-Mail', labelStyle: Theme.of(context).primaryTextTheme.bodyText2),
                        keyboardType: TextInputType.emailAddress,
                        controller: myEMailController,
                        validator: validateEmail,
                      ),
                      TextFormField(
                        style: TextStyle(color: Theme.of(context).backgroundColor),
                        decoration: InputDecoration(labelText: 'Password', labelStyle: Theme.of(context).primaryTextTheme.bodyText2),
                        keyboardType: TextInputType.text,
                        obscureText: true,
                        controller: myPasswordController,
                        validator: validatePassword
                      ),
                      new SizedBox(
                        height: 20.0,
                      ),
                      ConstrainedBox(
                        constraints: const BoxConstraints(minWidth: double.infinity),
                        child: RaisedButton(
                          onPressed: () {
                            _validateInputs(ctxt);
                          },
                          child: Text('LOGIN'),
                        )
                      )
                    ]
                  )
                )
              )
            )
          )
        ),
        floatingActionButton: Builder(
            builder: (ctxt) => FloatingActionButton(
              onPressed: () {
                Navigator.pushNamed(context, '/register');
              },
              tooltip: 'Switch to Register',
              child: Icon(MdiIcons.accountPlus)
            )
        )
    );
  }
}