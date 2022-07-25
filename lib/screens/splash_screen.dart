import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../constant.dart';
import '../firebase_services.dart';
import 'widgets/widget_build_functions.dart';
// import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
// import 'package:parasnath_associates/httpservices.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool loading = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Timer(const Duration(seconds: 3), () {
      FirebaseServices().init(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            buildSlideShow(),
            // Container(
            //   width: 300,
            //   height: 300,
            //   child: Image.asset('assets/images/logo.jpeg'),
            // ),
            Text(
              companyName,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 40,
                  color: primaryColor,
                  fontFamily: "Pacifico",
                  letterSpacing: 3),
            ),
            const SizedBox(
              height: 20,
            ),
            loading
                ? const Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Center(
                        child: SpinKitCircle(
                      color: Colors.green,
                      size: 50.0,
                    )),
                  )
                : const SizedBox()
          ],
        ),
      ),
    );
  }
}
