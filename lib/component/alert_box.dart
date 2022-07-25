import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../constant.dart';
import '../local_storage_services.dart';

Future<void> showMyDialog(
    String msg,
    String detail,
    BuildContext context,
    String okText,
    var okFun,
    String cancelText,
    var cancelFun,
    bool isDismissible) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: isDismissible, // user must tap button!
    builder: (BuildContext context) {
      return WillPopScope(
        onWillPop: () async => false,
        child: AlertDialog(
          title: Center(child: Text(msg)),
          content: Text(
            detail,
            textAlign: TextAlign.center,
          ),
          alignment: Alignment.center,
          actions: <Widget>[
            TextButton(child: Text(cancelText), onPressed: cancelFun),
            TextButton(child: Text(okText), onPressed: okFun),
          ],
        ),
      );
    },
  );
}

Future<void> showNotAuthorisedDialog(context) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Center(child: Text("Alert!")),
        content: const Text(
            "You are noth authorised to use this app in this Device.For help contact your admin."),
        actions: <Widget>[
          TextButton(
              child: Text("Ok"),
              onPressed: () {
                Navigator.pop(context);
              }),
          TextButton(
              child: Text("Call To Admin"),
              onPressed: () async {
                LocalStorage.logOut();
                String url = "tel:$mob";
                if (await canLaunch(url)) {
                  await launch(url);
                } else {
                  throw 'Could not launch $url';
                }
              }),
        ],
      );
    },
  );
}
