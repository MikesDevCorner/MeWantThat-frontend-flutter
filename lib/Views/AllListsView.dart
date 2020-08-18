import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../Classes/ShoppingList.dart';
import '../Libs/ApiService.dart';
import '../Libs/MenuService.dart';
import '../Libs/ThemeService.dart';


class AllListsView extends StatefulWidget {
  @override
  AllListsViewState createState() => new AllListsViewState();
}

class AllListsViewState extends State<AllListsView> {

  final DateFormat myDFormat = DateFormat('yyyy-MM-dd HH:mm');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: MenuService.getDrawer(context),
      appBar: AppBar(
        title: Text('Shopping Lists'),
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
          future: ApiService.fetchShoppingLists(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if(snapshot.data.length == 0) {
                return Column(
                  children: <Widget>[
                    Expanded(
//                      padding: const EdgeInsets.fromLTRB(0, 0, 30, 50),
                      child: Container(
                          padding: const EdgeInsets.all(50.0),
                          child: Text("vast emptyness", style: ThemeService.getAlternativeTextTheme().headline6)
                      )
                    ),
                    Container(
                        alignment: Alignment.bottomRight,
                        padding: const EdgeInsets.fromLTRB(0, 0, 30.0, 50.0),
                        child:Image.asset('assets/first_list_hint.png', height: 300, filterQuality:FilterQuality.high)
                    )
                  ]
                );
              } else return _shoppingListView(snapshot.data);
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
          onPressed: () async {
            final dynamic result = await Navigator.pushNamed(context, '/new-list');
            if(result == true) {
              Scaffold.of(ctxt).showSnackBar(
                  SnackBar(content: Text('List added successfully.')));
            }
            this.setState(() {});
          },
          tooltip: 'add new shopping list',
          child: const Icon(Icons.add),
        )
      )
    );
  }

  ListView _shoppingListView(data) {
    return ListView.builder(
        itemCount: data.length,
        itemBuilder: (context, index) {
          return _tile(data[index], Icons.list, context);
        });
  }

  ListTile _tile(ShoppingList shoppingList, IconData icon,
      BuildContext context) => ListTile(
    title: Text(shoppingList.listname,
        style: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 20,
        )),
    subtitle: Text(myDFormat.format(DateTime.parse(shoppingList.created_at).toLocal()), style: Theme.of(context).textTheme.subtitle2),
    leading: Icon(
      icon,
      color: Theme.of(context).primaryColor,
    ),
    trailing: IconButton(icon: Icon(Icons.delete, color: Theme.of(context).indicatorColor), onPressed: () async {
      await ApiService.deleteShoppingList(shoppingList.id);
      Scaffold
          .of(context)
          .showSnackBar(SnackBar(content: Text('List deleted successfully.')));
      this.setState(() {});
    }),
    onTap: () async {
      Navigator.pushNamed(context, '/single-list', arguments: shoppingList);
      this.setState(() {});
    },
  );

}