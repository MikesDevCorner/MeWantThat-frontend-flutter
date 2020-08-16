import 'package:http/http.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../Classes/ShoppingList.dart';
import '../Libs/ApiService.dart';
import '../Libs/MenuService.dart';

class NewEntryView extends StatefulWidget {
  NewEntryView({Key key}) : super(key: key);
  @override
  NewEntryViewState createState() {
    return NewEntryViewState();
  }
}

class NewEntryViewState extends State<NewEntryView> {
  final _formKey = GlobalKey<FormState>();
  ShoppingList shoppingList;
  NewEntryViewState() : super();
  final myNameController = TextEditingController();
  final myAmountController = TextEditingController(text: '1');

  bool _autoValidate = false;

  void _validateInputs (BuildContext ctxt) async {
    if (_formKey.currentState.validate()) {
      Scaffold.of(ctxt).showSnackBar(SnackBar(content:Text('Creating entry...')));
      Response r = await ApiService.addListEntry(shoppingList.id,
          int.parse(myAmountController.text), myNameController.text);
      if(r.statusCode == 401) {
        Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
      } else Navigator.pop(ctxt, true);
    } else {
      //If all data are not valid then start auto validation.
      Scaffold.of(ctxt).showSnackBar(SnackBar(content:
      Text('Please check your input fields')));
      setState(() {
        _autoValidate = true;
      });
    }
  }


  String validateName(String value) {
    RegExp regex = RegExp('^[a-zA-Z0-9_ ]*\$');
    if (!regex.hasMatch(value)) {
      return 'Only characters and digits are allowed';
    }
    else if(value.length > 60) return 'Reduce name to less than 60 characters';
    else if(value == "") return 'Name should not be empty';
    return null;
  }

  String validatorAmount(String value) {
    if(int.parse(value) > 9999) return "value should be less than 9999";
    else return null;
  }

  @override
  Widget build(BuildContext context) {
    this.shoppingList = ModalRoute.of(context).settings.arguments;
    return Scaffold(
        endDrawer: MenuService.getDrawer(context),
        appBar: AppBar(
          title: Text(shoppingList.listname + ": New Entry"),
          actions: <Widget>[Builder(
              builder: (ctxt) => Container(
                  padding: const EdgeInsets.fromLTRB(0, 0, 15, 0),
                  child: IconButton(
                    icon: Icon(
                      Icons.menu,
                      color: Theme.of(context).backgroundColor,
                    ),
                    onPressed: () => Scaffold.of(ctxt).openEndDrawer(),
                  )
              ))
          ],
        ),
        body: SingleChildScrollView(
            child:Builder(
            builder: (ctxt) => Center(
                child: Padding(
                  padding: const EdgeInsets.all(40.0),
                  child:Form(
                    key: _formKey,
                    autovalidate: _autoValidate,
                    child: Column(
                        children: <Widget>[
                          TextFormField(
                            decoration: InputDecoration(labelText: 'Entryname'),
                            controller: myNameController,
                            validator: validateName
                          ),
                          TextFormField(
                            decoration: InputDecoration(
                                labelText: 'Amount'
                            ),
                            inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
                            keyboardType: TextInputType.number,
                            controller: myAmountController,
                            validator: validatorAmount
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
                                child: Text('Save'),
                              )
                          )
                        ]
                    )
                )
              )
            )
          )
        )
    );
  }
}