import 'package:http/http.dart';

import '../Classes/ShoppingList.dart';
import '../Libs/ApiService.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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

  @override
  Widget build(BuildContext context) {
    this.shoppingList = ModalRoute.of(context).settings.arguments;
    return Scaffold(
        appBar: AppBar(
          title: Text(shoppingList.listname + ": New Entry"),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.power_settings_new,
                color: Colors.white,
              ),
              onPressed: () {
                ApiService.logout();
                Navigator.pushNamedAndRemoveUntil(context,'/login', (route) => false);
              },
            )
          ],
        ),
        body: Builder(
            builder: (ctxt) => Center(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child:Form(
                    key: _formKey,
                    child: Column(
                        children: <Widget>[
                          TextFormField(
                            decoration: InputDecoration(labelText: 'New Entry'),
                            controller: myNameController,
                            validator: (value) {
                              if (value.isEmpty) {return 'Please enter a name';}
                              return null;
                            },
                          ),
                          TextFormField(
                            decoration: InputDecoration(
                                labelText: 'Amount'
                            ),
                            inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
                            keyboardType: TextInputType.number,
                            controller: myAmountController,
                            validator: (value) {
                              if (value.isEmpty) { return 'Please enter an amount';}
                              return null;
                            },
                          ),
                          RaisedButton(
                            onPressed: () async {
                              if (_formKey.currentState.validate() == false) {
                                Scaffold.of(ctxt).showSnackBar(SnackBar(content:
                                Text('Fields should not be empty.')));
                              } else {
                                Scaffold.of(ctxt).showSnackBar(SnackBar(content:
                                Text('Creating entry...')));
                                Response r = await ApiService.addListEntry(shoppingList.id,
                                    int.parse(myAmountController.text), myNameController.text);
                                if(r.statusCode == 401) {
                                  Navigator.pushNamedAndRemoveUntil(context,
                                      '/login', (route) => false);
                                }
                                else Navigator.pop(ctxt, true);
                              }
                            },
                            child: Text('Save'),
                          )
                        ]
                    )
                )
              )
            )
        )
    );
  }
}