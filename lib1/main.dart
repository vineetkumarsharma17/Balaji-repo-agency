import 'dart:async';
import 'dart:developer';

import 'package:balaji_repo_agency/screens/admin_panel.dart';
// import 'package:balaji_repo_agency/screens/home_screen.dart';
// import 'package:balaji_repo_agency/screens/mobile_login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'component/alertdilog.dart';
import 'screens/admin_panel.dart';
import 'screens/home_screen.dart';
import 'screens/mobile_login.dart';

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
    //home: SpalshPage(),
    //home: AdminPanel(),
  ));
}

class SpalshPage extends StatefulWidget {
  const SpalshPage({Key key}) : super(key: key);

  @override
  State<SpalshPage> createState() => _SpalshPageState();
}

class _SpalshPageState extends State<SpalshPage> {
  String status;
  String id = "";
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
        if (querySnapshot.size > 0) {
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
              preferences?.setBool("login", true);
              String msg =
                  "You are not authorized to use this app\nPlease Contact to Sumit Tiwari().";
              showMyDialog("Failed", msg, context);
            } else {
              setState(() {
                loading = false;
              });
              check_if_already();
            }
          });
        } else {
          setState(() {
            loading = false;
          });
          preferences.setBool("login", true);
          String msg =
              "You are not authorized to use this app\nPlease Contact to Sunil Pal.";
          showMyDialog("Failed", msg, context);
        }
      }).timeout(const Duration(seconds: 15), onTimeout: () {
        showMyDialog("Timeout", "Sorry", context);
      });
    } else {
      Navigator.push(
              context, MaterialPageRoute(builder: (context) => LoginMobile()))
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
              width: 250,
              height: 250,
              child: const Image(
                image: AssetImage('assets/images/logo.png'),
              ),
            ),
            loading ? CircularProgressIndicator() : SizedBox()
          ],
        ),
      ),
    );
  }

  void check_if_already() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    // print("data=============");
    // print(await preferences.getBool('login'));
    bool loginstatus = await preferences.getBool('login') ?? true;
    if (loginstatus == false) {
      if (preferences.getString("type") == "admin") {
        Navigator.push(
                context, MaterialPageRoute(builder: (context) => AdminPanel()))
            .then((value) => SystemNavigator.pop());
      } else if (preferences.getString("type") == "user") {
        Navigator.push(
                context, MaterialPageRoute(builder: (context) => HomeScreen()))
            .then((value) => SystemNavigator.pop());
      } else {
        Navigator.push(
                context, MaterialPageRoute(builder: (context) => LoginMobile()))
            .then((value) => SystemNavigator.pop());
      }
    } else {
      Navigator.push(
              context, MaterialPageRoute(builder: (context) => LoginMobile()))
          .then((value) => SystemNavigator.pop());
    }
  }
}
