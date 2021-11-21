import 'dart:async';

import 'package:balaji_repo_agency/screens/admin_panel.dart';
import 'package:balaji_repo_agency/screens/home_screen.dart';
import 'package:balaji_repo_agency/screens/mobile_login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
//https://csvjson.com/csv2json
// https://beautifytools.com/excel-to-sql-converter.php
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp( MaterialApp(
    theme: ThemeData(
      scaffoldBackgroundColor: Colors.white,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.teal
      )
    ),
    debugShowCheckedModeBanner: false,
    // home: SpalshPage(),
    // home: SpalshPage(),
    home: AdminPanel(),
  ));
}
class SpalshPage extends StatefulWidget {
  const SpalshPage({Key? key}) : super(key: key);

  @override
  State<SpalshPage> createState() => _SpalshPageState();
}
class _SpalshPageState extends State<SpalshPage> {
  void initState() {
    super.initState();
    Timer(
        Duration(seconds: 2),
            (){
              check_if_already();
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: 250,
          height: 250,
          child: const Image(
            image: AssetImage('assets/images/logo.png'),
          ),
        ),
      ),
    );
  }
  void  check_if_already() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    print("data=============");
    print(await preferences.getBool('login'));
    bool loginstatus = await preferences.getBool('login')??true;
    if (loginstatus == false) {
      if (preferences.getString("type") == "admin") {
        Navigator.push(
            context, MaterialPageRoute(builder:
            (context) => const AdminPanel())).then((value) =>
            SystemNavigator.pop());
      } else if (preferences.getString("type") == "user") {
        Navigator.push(
            context, MaterialPageRoute(builder:
            (context) => const HomeScreen())).then((value) =>
            SystemNavigator.pop());
      } else {
        Navigator.push(context, MaterialPageRoute(builder:
            (context) => LoginMobile())).then((value) => SystemNavigator.pop());
      }
    }
    else {
      Navigator.push(context, MaterialPageRoute(builder:
          (context)=>LoginMobile())).then((value) => SystemNavigator.pop());
    }
  }
}

