import '../Libs/ApiService.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
      //login = await ApiService.login(myEMailController.text, myPasswordController.text);
      login = await ApiService.test();
      if(!login) {
        Scaffold.of(ctxt).showSnackBar(SnackBar(content:
        Text('Please check username and password and try again')));
      } else {
        Scaffold.of(ctxt).showSnackBar(SnackBar(content:
        Text('Login Successful')));
        final bool result = await Navigator.pushNamed(context, '/');
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
        body: Builder(
            builder: (ctxt) => Center(
                child: Padding(
                  padding: const EdgeInsets.all(35.0),
                  child:Form(
                    key: _formKey,
                    autovalidate: _autoValidate,
                    child: Column(
                        children: <Widget>[
                          TextFormField(
                            decoration: InputDecoration(labelText: 'E-Mail'),
                            keyboardType: TextInputType.emailAddress,
                            controller: myEMailController,
                            validator: validateEmail,
                          ),
                          TextFormField(
                            decoration: InputDecoration(labelText: 'Password'),
                            keyboardType: TextInputType.text,
                            obscureText: true,
                            controller: myPasswordController,
                            validator: validatePassword
                          ),
                          new SizedBox(
                            height: 10.0,
                          ),
                          RaisedButton(
                            onPressed: () {
                              _validateInputs(ctxt);
                            },
                            child: Text('Login'),
                          )
                        ]
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
              child: Text('Register')
            )
        )
    );
  }
}