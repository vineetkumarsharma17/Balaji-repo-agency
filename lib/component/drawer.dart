// import 'package:balaji_repo_agency/component/constant.dart';
// import 'package:balaji_repo_agency/screens/user_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path/path.dart';
// import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
// import 'package:url_launcher/url_launcher.dart';

import '../constant.dart';
import '../httpservices.dart';
import '../local_storage_services.dart';
import '../screens/widgets/widget_build_functions.dart';

class MyDrawer extends StatefulWidget {
  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  int buildNo = 0;
  String name = '';
  bool isAdmin = false;
  String city = '';
  int count = 0;
  String onlineCount = "Fetching..";
  appVer() async {
    await PackageInfo.fromPlatform().then((value) {
      setState(() {
        buildNo = int.parse(value.buildNumber);
      });
    });
    await LocalStorage.getLocalDataCount().then((value) {
      setState(() {
        count = value;
      });
    });
    HttpService.getOnlineCount(context).then((data) {
      setState(() {
        onlineCount = data.toString();
      });
    });
  }

  initState() {
    appVer();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
          color: primaryColor,
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // const SizedBox(
                //   height: 20,
                // ),
                // Image.asset(
                //   'assets/images/logo.png',
                //   width: 100,
                //   height: 100,
                // ),
                const SizedBox(
                  height: 20,
                ),
                Center(
                  child: Text(
                    companyName,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 25,
                      letterSpacing: 3,
                      color: Colors.white,
                      fontFamily: "Pacifico",
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  height: 300,
                  //  width: 200,
                  decoration: BoxDecoration(
                    color: Colors.amber,
                    border: Border.all(
                      color: Colors.white,
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: buildSlideShow(),
                ),
                const SizedBox(
                  height: 10,
                ),
                // GestureDetector(
                //   onTap: () {
                //     launchCaller(mob);
                //   },
                //   child: Card(
                //     margin:
                //         const EdgeInsets.symmetric(vertical: 5, horizontal: 30),
                //     //padding: EdgeInsets.all(10),
                //     color: Colors.white,
                //     child: Padding(
                //       padding: const EdgeInsets.all(15.0),
                //       child: Row(
                //         children: [
                //           const Icon(
                //             Icons.call,
                //             color: Colors.teal,
                //           ),
                //           const SizedBox(
                //             width: 20,
                //           ),
                //           Text(
                //             "+91$mob",
                //             style: const TextStyle(color: Colors.black),
                //           ),
                //         ],
                //       ),
                //     ),
                //   ),
                // ),
                SizedBox(height: 10),
                Text(
                  "Server Data:$onlineCount",
                  style: TextStyle(
                      fontSize: 19,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  "Offline Data:$count",
                  style: TextStyle(
                      fontSize: 19,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
                Expanded(
                    child: GestureDetector(
                        onTap: () {
                          // launchCaller("8874327867");
                        },
                        child: Container(
                            margin: const EdgeInsets.only(bottom: 20),
                            // color: Colors.white,
                            alignment: Alignment.bottomCenter,
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  // const Text(
                                  //   "App is developed by",
                                  //   style: TextStyle(
                                  //     fontSize: 12,
                                  //     color: Colors.white,
                                  //   ),
                                  // ),
                                  // const Text(
                                  //   "vSafe Software Solution",
                                  //   style: TextStyle(
                                  //       fontSize: 17,
                                  //       color: Colors.white,
                                  //       fontFamily: "Pacifico",
                                  //       letterSpacing: 3),
                                  // ),
                                  // const Text(
                                  //   "Contact:+918874327867",
                                  //   style: TextStyle(
                                  //     fontSize: 12,
                                  //     color: Colors.white,
                                  //   ),
                                  // ),
                                  Text(
                                    "1.0.0(" + buildNo.toString() + ")",
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.white,
                                    ),
                                  ),
                                ])))),

                //       ],
                //     ),
                //   ),
                // ))
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

  // launchEmail() async {
  //   final Uri emailLaunchUri = Uri(
  //     scheme: 'mailto',
  //     path: email,
  //   );

  //   // launchUrl(emailLaunchUri);
  // }
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
