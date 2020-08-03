import '../Classes/ShoppingList.dart';
import '../Views/NewEntryView.dart';
import '../Classes/ShoppingEntry.dart';
import '../Libs/ApiService.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class SingleListView extends StatefulWidget {

  final ShoppingList shoppingList;
  SingleListView({Key key, @required this.shoppingList}) : super(key: key);

  @override
  SingleListViewState createState() => new SingleListViewState(shoppingList: shoppingList);

}


class SingleListViewState extends State<SingleListView> {

  final ShoppingList shoppingList;

  // In the constructor, require a ShoppingList.
  SingleListViewState({@required this.shoppingList}) : super();


  navigateNewEntry(BuildContext context, BuildContext snackbarContext) async {
    final bool result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NewEntryView(shoppingList: shoppingList),
      ),
    );
    if(result == true) Scaffold
        .of(snackbarContext)
        .showSnackBar(SnackBar(content: Text('Entry added successfully.')));
    this.setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('List: ' + shoppingList.listenname),
        ),
        body: Center(
        child: FutureBuilder(
          future: ApiService.fetchShoppingEntries(shoppingList.id),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return _singleListView(snapshot.data);
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }
            // By default, show a loading spinner
            return CircularProgressIndicator();
          },
        )
      ),
      floatingActionButton: Builder(
        builder: (ctxt) => FloatingActionButton(
          onPressed: () => navigateNewEntry(context, ctxt),
          tooltip: 'add new shopping list',
          child: const Icon(Icons.add),
        )
      )
    );
  }

  ListView _singleListView(data) {
    return ListView.builder(
        itemCount: data.length,
        itemBuilder: (context, index) {
          return _tile(data[index], Icons.local_offer, context);
        });
  }


  ListTile _tile(ShoppingEntry entry, IconData icon, BuildContext context) => ListTile(
    title: Text(entry.postenname,
        style: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 20,
        )),
    subtitle: Text('Amount: '+entry.anzahl.toString() + 'x'),
    leading: Icon(
      icon,
      color: Colors.blue[500],
    ),
    trailing: IconButton(icon: Icon(Icons.delete), onPressed: () async {
      await ApiService.deleteListEntry(entry.id);
      Scaffold.of(context).showSnackBar(SnackBar(content: Text('Entry deleted successfully.')));
      this.setState(() {});
    }),
  );
} //end class SingleListViewState