import '../Libs/ApiService.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NewListView extends StatefulWidget {
  @override
  NewListFormState createState() {
    return NewListFormState();
  }
}

// Define a corresponding State class.
// This class holds data related to the form.
class NewListFormState extends State<NewListView> {
  final _formKey = GlobalKey<FormState>();
  final myNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New List'),
        actions: <Widget>[
        Container(
        padding: const EdgeInsets.fromLTRB(0, 0, 16, 0),
        child: IconButton(
            icon: Icon(
              Icons.power_settings_new,
              color: Colors.white,
            ),
            onPressed: () {
              ApiService.logout();
              Navigator.pushNamedAndRemoveUntil(context,'/login', (route) => false);
            })
          )
        ],
      ),
      body: SingleChildScrollView(
        child:Builder(
          builder: (ctxt) => Center(
            child: Padding(
            padding: const EdgeInsets.all(40.0),
            child:Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Listname'
                    ),
                    controller: myNameController,
                    // The validator receives the text that the user has entered.
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter a list name';
                      }
                      return null;
                    },
                  ),
                  new SizedBox(
                    height: 20.0,
                  ),
                  ConstrainedBox(
                    constraints: const BoxConstraints(minWidth: double.infinity),
                      child: RaisedButton(
                      color: Colors.blue,
                      textColor: Colors.white,
                      onPressed: () async {
                        // Validate returns true if the form is valid, otherwise false.
                        if (_formKey.currentState.validate() == false) {
                            Scaffold.of(ctxt)
                              .showSnackBar(SnackBar(content: Text('Field should not be empty.')));
                          } else {
                            Scaffold.of(ctxt)
                              .showSnackBar(SnackBar(content: Text('Creating list...')));
                            await ApiService.addShoppingList(myNameController.text);
                            Navigator.pop(ctxt, true);
                          }
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