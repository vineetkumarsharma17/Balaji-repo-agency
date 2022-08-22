import 'dart:async';
import 'dart:developer';
import 'package:background_fetch/background_fetch.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../constant.dart';
import '../firebase_services.dart';
import '../local_storage_services.dart';
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
    initPlatformState();
    Timer(const Duration(seconds: 3), () {
      FirebaseServices().init(context);
    });
  }

  Future<void> initPlatformState() async {
// Configure BackgroundFetch.
    var status = await BackgroundFetch.configure(
        BackgroundFetchConfig(
          minimumFetchInterval: 15,
          forceAlarmManager: false,
          stopOnTerminate: false,
          startOnBoot: true,
          enableHeadless: true,
          requiresBatteryNotLow: false,
          requiresCharging: false,
          requiresStorageNotLow: false,
          requiresDeviceIdle: false,
          requiredNetworkType: NetworkType.NONE,
        ),
        _onBackgroundFetch,
        _onBackgroundFetchTimeout);
    print('[BackgroundFetch] configure success: $status');
// Schedule backgroundfetch for the 1st time it will execute with 1000ms delay.
// where device must be powered (and delay will be throttled by the OS).
    BackgroundFetch.scheduleTask(TaskConfig(
        taskId: "fetchData",
        delay: 1000,
        periodic: false,
        stopOnTerminate: false,
        enableHeadless: true));
  }

  void _onBackgroundFetchTimeout(String taskId) {
    log("BackgroundFetch] TIMEOUT: $taskId");
    BackgroundFetch.finish(taskId);
  }

  void _onBackgroundFetch(String taskId) async {
    if (taskId == 'fetchData') {
      LocalStorage.checkCountAndFetchData();
// print(‘[BackgroundFetch] Event received’);
//TODO: perform your task like : call the API’s, call the DB and local notification.
    }
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
