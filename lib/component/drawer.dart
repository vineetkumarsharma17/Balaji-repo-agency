import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class MyDrawer extends StatefulWidget {
  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  String buildNo = '';

  appVer() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {});
    buildNo = packageInfo.version + "(" + packageInfo.buildNumber + ")";
  }

  initState() {
    appVer();
  }

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
                  "Bala ji Repo",
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
                    backgroundImage: AssetImage("assets/images/pic.jpeg"),
                    radius: 60,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  "Sumit Tiwari",
                  style: TextStyle(
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
                    launchCaller("9634123672");
                  },
                  child: Card(
                    margin:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 30),
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
                            "+919634123672",
                            style: TextStyle(color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    launchCaller("9634123672");
                  },
                  child: Card(
                    margin:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 30),
                    //padding: EdgeInsets.all(10),
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Row(
                        children: const [
                          Icon(
                            Icons.email_outlined,
                            color: Colors.teal,
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Text(
                            "sumit35@gmail.com",
                            style: TextStyle(color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                    child: GestureDetector(
                  onTap: () {
                    launchCaller("8874327867");
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    // color: Colors.white,
                    alignment: Alignment.bottomCenter,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const Text(
                          "App is developed by",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                          ),
                        ),
                        const Text(
                          "vSafe Software Solution",
                          style: TextStyle(
                              fontSize: 17,
                              color: Colors.white,
                              fontFamily: "Pacifico",
                              letterSpacing: 3),
                        ),
                        const Text(
                          "Contact:+918874327867",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          buildNo,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ))
              ],
            ),
          )),
    );
  }

  launchCaller(String num) async {
    String url = "tel:$num";
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
