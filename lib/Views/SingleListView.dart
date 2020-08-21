import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../Classes/ShoppingList.dart';
import '../Classes/ShoppingEntry.dart';
import '../Libs/ApiService.dart';
import '../Libs/MenuService.dart';
import '../Libs/ThemeService.dart';

class SingleListView extends StatefulWidget {
  SingleListView({Key key}) : super(key: key);
  @override
  SingleListViewState createState() => new SingleListViewState();
}
class SingleListViewState extends State<SingleListView> {

  ShoppingList shoppingList;
  SingleListViewState() : super();

  navigateNewEntry(BuildContext context, BuildContext snackbarContext) async {
    final dynamic result = await Navigator.pushNamed(context,
        '/new-entry', arguments: shoppingList);
    if(result == true) Scaffold
        .of(snackbarContext)
        .showSnackBar(SnackBar(content: Text('Entry added successfully.')));
    this.setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    this.shoppingList = ModalRoute.of(context).settings.arguments;
    return Scaffold(
        endDrawer: MenuService.getDrawer(context),
        appBar: AppBar(
          title: Text('List: ' + shoppingList.listname),
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
        body: Center(
        child: FutureBuilder(
          future: ApiService.fetchShoppingEntries(shoppingList.id),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if(snapshot.data.length == 0) {
                return Column(
                    children: <Widget>[
                      Expanded(
                          child: Container(
                              padding: const EdgeInsets.all(50.0),
                              child: Text("vast emptyness",
                                  style: ThemeService.getAlternativeTextTheme().headline6)
                          )
                      ),
                      Container(
                          alignment: Alignment.bottomRight,
                          padding: const EdgeInsets.fromLTRB(0, 0, 30.0, 50.0),
                          child:Image.asset('assets/first_entry_hint.png',
                              height: 300, filterQuality:FilterQuality.high)
                      )
                    ]
                );
              } else return _singleListView(snapshot.data);
            } else if (snapshot.hasError) {
              if(snapshot.error.toString() == '401') {
                Navigator.pushNamedAndRemoveUntil(context,'/login', (route) => false);
              }
              else {
                Scaffold.of(context).showSnackBar(SnackBar(content: Text('network error on loading lists')));
                return null; //Text("${snapshot.error}");
              }
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
      color: Theme.of(context).primaryColor,
    ),
    trailing: IconButton(icon: Icon(Icons.delete, color: Theme.of(context)
        .indicatorColor), onPressed: () async {
      await ApiService.deleteListEntry(entry.id);
      Scaffold.of(context).showSnackBar(SnackBar(content: Text('Entry deleted successfully.')));
      this.setState(() {});
    }),
  );
} //end class SingleListViewState