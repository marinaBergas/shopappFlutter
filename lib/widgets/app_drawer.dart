import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            title: const Text('hello friend'),
            //it will never add back button here
            automaticallyImplyLeading: false,
          ),
          const Divider(),
          const ListTile(leading:Icon(Icons.shop) ,)
        ],
      ),
    );
  }
}
