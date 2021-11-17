import 'dart:async';

import 'package:balaji_repo_agency/screens/mobile_login.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: SpalshPage(),
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
            () {
          Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginMobile()));
          // check_if_already_login_faculty();

        });
    // context, MaterialPageRoute(builder: (context) => DirectorLogIn())));
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
}

