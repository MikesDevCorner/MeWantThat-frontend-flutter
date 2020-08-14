import '../Classes/ShoppingList.dart';
import '../Libs/ApiService.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../Views/SingleListView.dart';
import '../Views/NewListView.dart';
import 'package:moment/moment.dart';

class AllListsView extends StatefulWidget {
  @override
  AllListsViewState createState() => new AllListsViewState();
}

class AllListsViewState extends State<AllListsView> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Shopping Lists'),
      ),
      body: Center(
        child: FutureBuilder(
          future: ApiService.fetchShoppingLists(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return _shoppingListView(snapshot.data);
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
          onPressed: () async {
            final bool result = await Navigator.pushNamed(context, '/new-list');
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
    subtitle: Text(Moment(shoppingList.created_at).format("YYYY-MM-DD HH:mm")),
    leading: Icon(
      icon,
      color: Colors.blue[500],
    ),
    trailing: IconButton(icon: Icon(Icons.delete), onPressed: () async {
      await ApiService.deleteShoppingList(shoppingList.id);
      Scaffold
          .of(context)
          .showSnackBar(SnackBar(content: Text('List deleted successfully.')));
      this.setState(() {});
    }),
    onTap: () async {
      await Navigator.pushNamed(context, '/single-list', arguments: shoppingList);
      this.setState(() {});
    },
  );

}