import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import 'ApiService.dart';

class MenuService {

  static Drawer getDrawer(BuildContext context) {
    return Drawer(
        child: Builder(
          builder: (ctxt) =>Container(
            color: Theme.of(context).backgroundColor,
            child: ListView(
                padding: EdgeInsets.zero,
                children: <Widget>[
                  DrawerHeader(
                    child: Container(
                        padding: const EdgeInsets.fromLTRB(16.0, 10.0, 16.0, 22.0),
                        child: Image.asset('assets/logosm.png', filterQuality:FilterQuality.high, fit: BoxFit.fitHeight),
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  ListTile(
                    leading: Icon(MdiIcons.power,
                      color: Theme.of(context).primaryColor,
                    ),
                    title: Text('Logout', style: Theme.of(context).textTheme.subtitle1),
                    onTap: () {
                      ApiService.logout();
                      Navigator.pushNamedAndRemoveUntil(context,'/login', (route) => false);
                    },
                  ),
                  ListTile(
                    leading: Icon(MdiIcons.accountMinus,
                      color: Theme.of(context).primaryColor,
                    ),
                    title: Text("Delete Account", style: Theme.of(context).textTheme.subtitle1),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext alertContext) {
                          return AlertDialog(
                            title: Text("Unregister"),
                            content: Text("Would you really like to delete your account and all its data permanently from our databases? You cannot undo this action."),
                            actions: [
                              FlatButton(
                                child: Text("Cancel"),
                                onPressed:  () {
                                  Navigator.pop(context);
                                },
                              ),
                              FlatButton(
                                child: Text("Delete Account"),
                                onPressed:  () {
                                  ApiService.unregister();
                                  //Scaffold.of(ctxt).showSnackBar(
                                  //    SnackBar(content: Text('Sorry to see you leave. Account deleted successfully.')));
                                  Navigator.pushNamedAndRemoveUntil(context,'/login', (route) => false);
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                  )
                ]
            )
          )
        )
    );
  }
}