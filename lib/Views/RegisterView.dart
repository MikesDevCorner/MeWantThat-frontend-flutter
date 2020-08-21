import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../Libs/ApiService.dart';

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
      String register = await ApiService.register(myEMailController.text,
        myPasswordController.text, myPasswordConfirmController.text,
          myNameController.text);
      if(register == "success") {
        Scaffold.of(ctxt).showSnackBar(SnackBar(content:
        Text('Login and Register Successful')));
        Navigator.pushNamedAndRemoveUntil(context,
            '/', (route) => false);
      } else {
        Scaffold.of(ctxt).showSnackBar(SnackBar(content:
        Text(register)));
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
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\'
        r'.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return 'Enter valid Email';
    else if(value == "") return 'E-Mail should not be empty';
    else return null;
  }

  String validatePassword(String value) {
      if(value.length < 8) return 'Password should at least be 8 characters';
      else if(value.length == 0) return 'Password should not be empty';
      else return null;
  }

  String validatePassword2(String value) {
    if(myPasswordController.text != value) return "Passwords do not match";
    else return validatePassword(value);
  }

  String validateName(String value) {
    RegExp regex = RegExp('^[a-zA-Z0-9üÜäÄöÖß_ ]*\$');
    if (!regex.hasMatch(value)) {
      return 'Only characters and digits are allowed';
    }
    else if(value.length > 60) return 'Reduce name to less than 60 characters';
    else if(value.length == 0) return 'Name should not be empty';
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
                padding: const EdgeInsets.fromLTRB(35.0, 50.0, 35.0, 35.0),
                child:Form(
                  key: _formKey,
                  autovalidate: _autoValidate,
                  child: Column(
                    children: <Widget>[
                      RichText(
                        textAlign: TextAlign.center,
                        text: new TextSpan( style: Theme.of(context)
                            .primaryTextTheme.headline5,
                          children: <TextSpan>[
                            TextSpan(text: 'Sign up for '),
                            TextSpan(text: 'ME WANT THAT',
                                style: new TextStyle(fontWeight: FontWeight.bold)),
                            TextSpan(text: ' and create an account:')
                          ]
                        )
                      ),
                      new SizedBox(
                        height: 20.0,
                      ),
                      TextFormField(
                        style: TextStyle(color: Theme.of(context).backgroundColor),
                        decoration: InputDecoration(labelText: 'Name',
                            labelStyle: Theme.of(context).primaryTextTheme.bodyText2),
                        keyboardType: TextInputType.text,
                        controller: myNameController,
                        validator: validateName
                      ),
                      TextFormField(
                        style: TextStyle(color: Theme.of(context).backgroundColor),
                        decoration: InputDecoration(labelText: 'E-Mail',
                            labelStyle: Theme.of(context).primaryTextTheme.bodyText2),
                        keyboardType: TextInputType.emailAddress,
                        controller: myEMailController,
                        validator: validateEmail,
                      ),
                      TextFormField(
                        style: TextStyle(color: Theme.of(context).backgroundColor),
                        decoration: InputDecoration(labelText: 'Password',
                            labelStyle: Theme.of(context).primaryTextTheme.bodyText2),
                        keyboardType: TextInputType.text,
                        obscureText: true,
                        controller: myPasswordController,
                        validator: validatePassword
                      ),
                      TextFormField(
                        style: TextStyle(color: Theme.of(context).backgroundColor),
                        decoration: InputDecoration(labelText: 'Password again',
                            labelStyle: Theme.of(context).primaryTextTheme.bodyText2),
                        keyboardType: TextInputType.text,
                        obscureText: true,
                        controller: myPasswordConfirmController,
                        validator: validatePassword2
                      ),
                      new SizedBox(
                        height: 30.0,
                      ),
                      ConstrainedBox(
                        constraints: const BoxConstraints(minWidth: double.infinity),
                        child: RaisedButton(
                          color: Theme.of(context).accentColor,
                          textColor: Theme.of(context).backgroundColor,
                          onPressed: () {
                            _validateInputs(ctxt);
                          },
                          child: Text('REGISTER'),
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
              backgroundColor: Theme.of(context).accentColor,
              onPressed: () {
                Navigator.pop(context);
              },
              tooltip: 'Switch to Login',
              child: Icon(Icons.arrow_back),
            )
        )
    );
  }
}