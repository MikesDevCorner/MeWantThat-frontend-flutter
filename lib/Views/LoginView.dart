import '../Libs/ApiService.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
                      Text('Shopping List', style: Theme.of(context).textTheme.headline3.merge(TextStyle(color: Colors.white))),
                      new SizedBox(
                        height: 40.0,
                      ),
                      TextFormField(
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(labelText: 'E-Mail', labelStyle: TextStyle(color: Colors.white)),
                        keyboardType: TextInputType.emailAddress,
                        controller: myEMailController,
                        validator: validateEmail,
                      ),
                      TextFormField(
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(labelText: 'Password', labelStyle: TextStyle(color: Colors.white)),
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
                          color: const Color(0xff062f77),
                          textColor: Colors.white,
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
              backgroundColor: const Color(0xff062f77),
              onPressed: () {
                Navigator.pushNamed(context, '/register');
              },
              tooltip: 'Switch to Register',
              child: FaIcon(FontAwesomeIcons.userPlus)
            )
        )
    );
  }
}