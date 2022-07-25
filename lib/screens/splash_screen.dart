import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../constant.dart';
import '../firebase_services.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
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

  buildSlideShow() {
    return ImageSlideshow(
      /// Width of the [ImageSlideshow].
      width: double.infinity,

      /// Height of the [ImageSlideshow].
      height: 400,

      /// The page to show when first creating the [ImageSlideshow].
      initialPage: 0,

      /// The color to paint the indicator.
      indicatorColor: Colors.blue,

      /// The color to paint behind th indicator.
      indicatorBackgroundColor: Colors.grey,

      /// The widgets to display in the [ImageSlideshow].
      /// Add the sample image file into the images folder
      children: [
        Image.asset(
          'assets/images/logo.jpeg',
          fit: BoxFit.contain,
        ),
        Image.asset(
          'assets/images/logo2.jpeg',
          fit: BoxFit.contain,
        ),
        Image.asset(
          'assets/images/logo3.jpeg',
          fit: BoxFit.contain,
        ),
      ],

      /// Called whenever the page in the center of the viewport changes.
      onPageChanged: (value) {
        // print('Page changed: $value');
      },

      /// Auto scroll interval.
      /// Do not auto scroll with null or 0.
      autoPlayInterval: 1500,

      /// Loops back to first slide.
      isLoop: true,
    );
  }
}
