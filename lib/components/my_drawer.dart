import 'package:chat_app/auth_service/auth_service.dart';
import 'package:chat_app/pages/settings_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    void _logout() {
      //auth logout function
      final AuthService _auth = AuthService();

      try {
        _auth.signOut();
      } catch (e) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(e.toString()),
          ),
        );
      }
    }

    return Drawer(
      
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          //logo
          Column(
            children: [
              DrawerHeader(
                  child: Center(
                child: Icon(
                  Icons.message,
                  size: 40,
                  color: Theme.of(context).colorScheme.primary,
                ),
              )),

              //home list tile
              Padding(
                padding: EdgeInsets.only(left: 25),
                child: ListTile(
                  title: Text(
                    "H O M E",
                  ),
                  leading: Icon(Icons.home),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ),

              //settings list tile
              Padding(
                padding: EdgeInsets.only(left: 25),
                child: ListTile(
                  title: Text(
                    "S E T T I N G S",
                  ),
                  leading: Icon(Icons.settings),
                  onTap: () {
                    Navigator.push(
                        context,
                        CupertinoPageRoute(
                            builder: (context) => SettingsPage()));
                  },
                ),
              ),
            ],
          ),
          //logout list tile
          Padding(
            padding: EdgeInsets.only(left: 25),
            child: ListTile(
              title: Text(
                "L O G O U T",
              ),
              leading: Icon(Icons.logout),
              onTap: _logout,
            ),
          ),
        ],
      ),
    );
  }
}
