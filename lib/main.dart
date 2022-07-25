import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import '../Screens/splash_screen.dart';
import '../constant.dart';
// arch -x86_64 pod install
import 'local_storage_services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  LocalStorage.init();
  runApp(MaterialApp(
    theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: AppBarTheme(backgroundColor: primaryColor)),
    debugShowCheckedModeBanner: false,
    home: const SplashScreen(),
    //home: UserProfile(),
    //home: UserProfile(),
  ));
}
