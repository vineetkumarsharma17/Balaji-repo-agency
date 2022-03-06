import 'package:flutter/material.dart';
class MyDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Colors.blue,
        child: ListView(
          children: [
            ListTile(title: Text("Developer Team",style: TextStyle(
                fontSize: 24,
                color: Colors.white,
                fontWeight: FontWeight.bold
            ),),
            ),
            DrawerHeader(
              padding: EdgeInsets.zero,
              child: UserAccountsDrawerHeader(
              currentAccountPicture: CircleAvatar(backgroundImage: AssetImage("assets/images/vineet.jpg"),),
              accountEmail: Text("Vineetsha@student.iul.ac.in"),
              accountName: Text("Vineet kumar sharma"),
          ),
            ),],
        ),
      ),

    );
  }
}
