import '../Classes/ShoppingList.dart';
import '../Views/NewEntryView.dart';
import '../Classes/ShoppingEntry.dart';
import '../Libs/ApiService.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class SingleListView extends StatefulWidget {
  SingleListView({Key key}) : super(key: key);
  @override
  SingleListViewState createState() => new SingleListViewState();
}


class SingleListViewState extends State<SingleListView> {

  ShoppingList shoppingList;
  SingleListViewState() : super();

  navigateNewEntry(BuildContext context, BuildContext snackbarContext) async {
    final bool result = await Navigator.pushNamed(context, '/new-entry', arguments: shoppingList);
    if(result == true) Scaffold
        .of(snackbarContext)
        .showSnackBar(SnackBar(content: Text('Entry added successfully.')));
    this.setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    this.shoppingList = ModalRoute.of(context).settings.arguments;
    return Scaffold(
        appBar: AppBar(
          title: Text('List: ' + shoppingList.listname),
        ),
        body: Center(
        child: FutureBuilder(
          future: ApiService.fetchShoppingEntries(shoppingList.id),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return _singleListView(snapshot.data);
            } else if (snapshot.hasError) {
              if(snapshot.error.toString() == '401') {
                Navigator.pushNamedAndRemoveUntil(context,'/login', (route) => false);
              }
              else return Text("${snapshot.error}");
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
    title: Text(entry.entryname,
        style: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 20,
        )),
    subtitle: Text('Amount: '+entry.amount.toString() + 'x'),
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