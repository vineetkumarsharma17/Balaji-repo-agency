import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
// import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
// import 'package:whatsapp_share/whatsapp_share.dart';

import '../constant.dart';
// import 'package:whatsapp_share/whatsapp_share.dart';

opentowhatsapp(String msg, context) async {
  // await WhatsappShare.share(
  //   text: msg,
  //   phone: '91$mob',
  // ).then((value) async {
  //   if (value == false) {
  //     await Share.share(msg);
  //   }
  // });
  // var whatsapp = "+919369640153";
  //var whatsappURl_android = "whatsapp://send?+91$mob&text=$msg";
  // var whatsappURl_android = "https://wa.me/${mob}?text=$msg";
  // showDialog<void>(
  //   context: context,
  //   barrierDismissible: false, // user must tap button!
  //   builder: (BuildContext context) {
  //     return AlertDialog(
  //       title: Text("Open  Whatsapp"),
  //       content: Text("Do you want share on whatsapp ?"),
  //       actions: <Widget>[
  //         TextButton(
  //           child: const Text('No'),
  //           onPressed: () {
  //             Navigator.of(context).pop();
  //           },
  //         ),
  //         TextButton(
  //           child: const Text('Yes'),
  //           onPressed: () async {
  //             await WhatsappShare.share(
  //               text: 'Whatsapp share text',
  //               linkUrl: 'https://flutter.dev/',
  //               phone: '91$mob',
  //             );
  // if (await canLaunch(whatsappURl_android)) {
  //   await launch(whatsappURl_android);
  // } else {
  //   ScaffoldMessenger.of(context)
  //       .showSnackBar(const SnackBar(content: Text("Something went wrong.")));
  // }
  //             Navigator.of(context).pop();
  //           },
  //         ),
  //       ],
  //     );
  //   },
  // );
}
