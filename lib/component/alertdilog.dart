import 'dart:async';
import 'dart:io';

import 'package:balaji_repo_agency/component/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../Screens/login_screen.dart';

Future<void> showMyDialog(
    String msg, String detail, BuildContext context) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(msg),
        content: Text(detail),
        actions: <Widget>[
          TextButton(
            child: const Text('ok'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

Future<void> showExitDialog(
    String msg, String detail, BuildContext context) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(msg),
        content: Text(detail),
        actions: <Widget>[
          TextButton(
            child: const Text('NO'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: const Text('Yes'),
            onPressed: () async {
              SharedPreferences preferences =
                  await SharedPreferences.getInstance();
              preferences.clear();
              Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginScreen()))
                  .then((value) => SystemNavigator.pop());
              showSnackBar(
                  "Thanks for using our app\nThis app is developed by Vineet Kumar Sharma(8874327867)",
                  context);
            },
          ),
        ],
      );
    },
  );
}

Future<void> showUpdateDialog(BuildContext context) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text("New Update Available!"),
        content: const Text("Please  download new app and install."),
        actions: <Widget>[
          TextButton(
            child: const Text('Download App'),
            onPressed: () async {
              String url = "http://balajirepo.agency/";
              if (await canLaunch(url)) {
                await launch(url);
              } else {
                Navigator.pop(context);
                throw 'Could not launch $url';
              }
            },
          ),
        ],
      );
    },
  );
}
