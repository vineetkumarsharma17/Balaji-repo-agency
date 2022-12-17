import 'package:background_fetch/background_fetch.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import '../Screens/splash_screen.dart';
import '../constant.dart';
// arch -x86_64 pod install
import 'local_storage_services.dart';

void backgroundFetchHeadlessTask(HeadlessTask task) async {
  String taskId = task.taskId;
  bool isTimeout = task.timeout;
  if (isTimeout) {
    // This task has exceeded its allowed running-time.  You must stop what you're doing and immediately .finish(taskId)
    print("[BackgroundFetch] Headless task timed-out: $taskId");
    LocalStorage.checkCountAndFetchData();
    // BackgroundFetch.finish(taskId);
    return;
  }
  if (taskId == 'fetchData') {
    LocalStorage.checkCountAndFetchData();
//TODO: perform your task like : call the API’s, call the DB and local notification.
  }
  print("[BackgroundFetch] Headless event received in main file: $taskId");
  // BackgroundFetch.finish(taskId);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  LocalStorage.init().then((value) {
    runApp(MaterialApp(
      theme: ThemeData(
          scaffoldBackgroundColor: Colors.white,
          appBarTheme: AppBarTheme(backgroundColor: primaryColor)),
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
      //home: UserProfile(),
      //home: UserProfile(),
    ));
  });
  BackgroundFetch.registerHeadlessTask(backgroundFetchHeadlessTask);
}
