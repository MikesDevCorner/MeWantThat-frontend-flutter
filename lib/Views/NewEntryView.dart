import '../Classes/ShoppingList.dart';
import '../Libs/ApiService.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NewEntryView extends StatefulWidget {

  final ShoppingList shoppingList;
  NewEntryView({Key key, @required this.shoppingList}) : super(key: key);

  @override
  NewEntryViewState createState() {
    return NewEntryViewState(shoppingList: shoppingList);
  }

}

class NewEntryViewState extends State<NewEntryView> {
  final _formKey = GlobalKey<FormState>();
  final ShoppingList shoppingList;
  NewEntryViewState({@required this.shoppingList}) : super();
  final myNameController = TextEditingController();
  final myAmountController = TextEditingController(text: '1');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(shoppingList.listenname + ": New Entry"),
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
                                await ApiService.addListEntry(shoppingList.id,
                                    int.parse(myAmountController.text), myNameController.text);
                                Navigator.pop(ctxt, true);
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