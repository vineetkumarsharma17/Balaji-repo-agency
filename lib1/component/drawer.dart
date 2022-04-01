import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class MyDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
          color: Colors.teal,
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  "Balaji Repo Agency",
                  style: TextStyle(
                      fontSize: 30,
                      color: Colors.white,
                      fontFamily: "Anton",
                      letterSpacing: 3),
                ),
                const SizedBox(
                  height: 10,
                ),
                const CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 62,
                  child: CircleAvatar(
                    backgroundImage: AssetImage("assets/images/pic.jpg"),
                    radius: 60,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  "Sumit Tiwari",
                  style: const TextStyle(
                      fontSize: 30,
                      color: Colors.white,
                      fontFamily: "Pacifico",
                      letterSpacing: 3),
                ),
                SizedBox(
                  width: 150,
                  child: Divider(
                    color: Colors.teal[100],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    launchCaller();
                  },
                  child: Card(
                    margin: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 30),
                    //padding: EdgeInsets.all(10),
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Row(
                        children: const [
                          Icon(
                            Icons.call,
                            color: Colors.teal,
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Text(
                            "+919452597341",
                            style: TextStyle(color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )),
    );
  }

  launchCaller() async {
    const url = "tel:9452597341";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
/*ListView(
children: const [
// ListTile(title: Text("Developer",style: TextStyle(
//     fontSize: 24,
//     color: Colors.white,
//     fontWeight: FontWeight.bold
// ),),
// ),
Center(
child: DrawerHeader(
padding: EdgeInsets.zero,
child: UserAccountsDrawerHeader(
currentAccountPicture:
accountEmail: Text("9452597341"),
accountName: Text("Sumit Tiwari"),
),
),
),],
),*/
