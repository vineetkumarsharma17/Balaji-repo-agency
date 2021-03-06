import 'dart:async';
import 'dart:developer';
import 'package:balaji_repo_agency/Screens/admin_search.dart';
import 'package:balaji_repo_agency/Screens/otp_screen.dart';
import 'package:balaji_repo_agency/Screens/user_list.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:balaji_repo_agency/Screens/admin_panel.dart';

import 'package:balaji_repo_agency/Screens/user_profile_screen.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Screens/login_screen.dart';
import 'Screens/user_homepage.dart';
import 'component/alertdilog.dart';

//https://csvjson.com/csv2json
// https://beautifytools.com/excel-to-sql-converter.php
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(backgroundColor: Colors.teal)),
    debugShowCheckedModeBanner: false,
    home: SpalshPage(),
    //home: UserProfile(),
    //home: UserProfile(),
  ));
}

class SpalshPage extends StatefulWidget {
  @override
  State<SpalshPage> createState() => _SpalshPageState();
}

class _SpalshPageState extends State<SpalshPage> {
  var id;
  String status = "";
  String mobile = "";
  SharedPreferences preferences;
  CollectionReference phone = FirebaseFirestore.instance.collection('phone');

  bool loading = false;
  @override
  void initState() {
    super.initState();

    Timer(const Duration(seconds: 2), () {
      setState(() {
        checkUser();
        loading = true;
      });
    });
  }

  checkUser() async {
    preferences = await SharedPreferences.getInstance();
    mobile = preferences.getString("number") ?? "";
    log("number:$mobile");
    status = "false";
    if (mobile.isNotEmpty) {
      await phone
          .where('number', isEqualTo: mobile)
          .get()
          .then((QuerySnapshot querySnapshot) {
        log("found:" + querySnapshot.size.toString());
        // print(querySnapshot.toString());
        if (querySnapshot.size > 0)
          querySnapshot.docs.forEach((doc) {
            id = doc.id;
            Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
            status = data['status'];
            log("this is status ${status}");
            log(id);
            if (status == "false") {
              setState(() {
                loading = false;
              });
              preferences.setBool("login", true);
              String msg =
                  "You are not authorized to use this app\nPlease Contact to Sunil Pal.";
              showMyDialog("Failed", msg, context);
            } else {
              setState(() {
                loading = false;
              });
              check_if_already();
            }
          });
        else {
          setState(() {
            loading = false;
          });
          preferences.setBool("login", true);
          String msg =
              "You are not authorized to use this app\nPlease Contact to Sumit Tiwari.";
          showMyDialog("Failed", msg, context);
        }
      }).timeout(const Duration(seconds: 15), onTimeout: () {
        showMyDialog("Timeout", "Sorry", context);
      });
    } else {
      Navigator.push(
              context, MaterialPageRoute(builder: (context) => LoginScreen()))
          .then((value) => SystemNavigator.pop());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 300,
              height: 300,
              child: Image.asset('assets/images/logo.png'),
            ),
            loading ? CircularProgressIndicator() : SizedBox()
          ],
        ),
      ),
    );
  }

  void check_if_already() async {
    print("data=============");
    print(await preferences.getBool('login'));
    bool loginstatus = preferences.getBool('login') ?? true;
    bool isregisterd = preferences.getBool('isResister') ?? false;
    if (loginstatus == false) {
      if (preferences.getString("type") == "admin") {
        Navigator.push(context,
                MaterialPageRoute(builder: (context) => AdminPanelScreen()))
            .then((value) => SystemNavigator.pop());
      } else if (preferences.getString("type") == "user") {
        if (isregisterd) {
          Navigator.push(context,
                  MaterialPageRoute(builder: (context) => UserScreenHome()))
              .then((value) => SystemNavigator.pop());
        } else
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => UserProfile()));
      } else {
        Navigator.push(
                context, MaterialPageRoute(builder: (context) => LoginScreen()))
            .then((value) => SystemNavigator.pop());
      }
    } else {
      Navigator.push(
              context, MaterialPageRoute(builder: (context) => LoginScreen()))
          .then((value) => SystemNavigator.pop());
    }
  }
}
