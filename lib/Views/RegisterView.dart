import '../Libs/ApiService.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RegisterView extends StatefulWidget {

  RegisterView({Key key}) : super(key: key);

  @override
  RegisterViewState createState() {
    return RegisterViewState();
  }

}

class RegisterViewState extends State<RegisterView> {
  final _formKey = GlobalKey<FormState>();
  RegisterViewState() : super();
  final myEMailController = TextEditingController();
  final myNameController = TextEditingController();
  final myPasswordController = TextEditingController();
  final myPasswordConfirmController = TextEditingController();
  bool _autoValidate = false;

  void _validateInputs (BuildContext ctxt) async {
    if (_formKey.currentState.validate()) {
      bool register = await ApiService.register(myEMailController.text,
        myPasswordController.text, myPasswordConfirmController.text, myNameController.text);
      if(!register) {
        Scaffold.of(ctxt).showSnackBar(SnackBar(content:
        Text('System says you are unauthenticated')));
      } else {
        Scaffold.of(ctxt).showSnackBar(SnackBar(content:
        Text('Login and Register Successful')));
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

  String validateName(String value) {
    if(value.length > 60) return 'Reduce name to less than 60 characters';
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
                              decoration: InputDecoration(labelText: 'Name'),
                              keyboardType: TextInputType.text,
                              obscureText: true,
                              controller: myNameController,
                              validator: validateName
                          ),
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
                          TextFormField(
                              decoration: InputDecoration(labelText: 'Password again'),
                              keyboardType: TextInputType.text,
                              obscureText: true,
                              controller: myPasswordConfirmController,
                              validator: validatePassword
                          ),
                          new SizedBox(
                            height: 10.0,
                          ),
                          RaisedButton(
                            onPressed: () {
                              _validateInputs(ctxt);
                            },
                            child: Text('Register'),
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
                Navigator.pop(context);
              },
              tooltip: 'Switch to Login',
              child: Text('Login')
            )
        )
    );
  }
}