import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import 'alertdilog.dart';
logoutActionButton(context){
  return FloatingActionButton(
    child: Icon(Icons.logout),
      onPressed:()async{
  showExitDialog("Alert!", "Are you sure to exit?", context);
   //exit(0);
  });
}
showSnackBar(msg,context){
   return  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
     content: Text(msg),
     behavior: SnackBarBehavior.floating,
     shape: RoundedRectangleBorder(
       borderRadius: BorderRadius.circular(10.0),
     ),
     duration: const Duration(milliseconds: 2000),
   ));
}
buttonStyle(){
  return ButtonStyle(
      minimumSize: MaterialStateProperty.all(Size(120, 40)),
      backgroundColor: MaterialStateProperty.all(Colors.teal),
      shape:MaterialStateProperty.all(RoundedRectangleBorder(
          borderRadius:BorderRadius.circular(20),
          side: BorderSide.none
      ))
  );
}
Future<void> showExitDialog(String msg,String detail,BuildContext context) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title:  Text(msg),
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
              SharedPreferences preferences=await SharedPreferences.getInstance();
              preferences.setBool("login", true);
              showSnackBar("Thanks for using our app\nThis app is developed by Vineet Kumar Sharma",context);
              Navigator.of(context).pop();
             // exit(0);
            },
          ),
        ],
      );
    },
  );
}
Future<void> showDataDialog(String msg,String detail,BuildContext context) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title:  Text(msg),
        content: Text(detail),
        actions: <Widget>[
          TextButton(
            child: const Text('Ok'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: const Text('Share'),
            onPressed: () async {
              print("clicked");
              Navigator.of(context).pop();
              openwhatsapp(detail, context);
            },
          ),
        ],
      );
    },
  );
}
openwhatsapp(String msg,context) async{

  // var whatsapp = "+919369640153";
  var whatsappURl_android = "whatsapp://send?&text=$msg";
   showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("Open  Whatsapp"),
        content: Text("Do you want share on whatsapp ?"),
        actions: <Widget>[
          TextButton(
            child: const Text('No'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: const Text('Yes'),
            onPressed: () async {
              if (await canLaunch(whatsappURl_android)) {
                await launch(whatsappURl_android);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: new Text("whatsapp no installed")));
              }
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
Future<void> AddUserDialog( msg, detail,mobile, context) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title:  Text(msg),
        content: Text(detail),
        actions: <Widget>[
          TextButton(
            child: const Text('No'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: const Text('Add'),
            onPressed: () async {
              print("clicked");
              addPhoneNumber(mobile, context);
              // Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
 addPhoneNumber(mobile,context){
   CollectionReference phone = FirebaseFirestore.instance.collection('phone');
   phone.add({
     'number': mobile, // John Doe
     'status': "true", // Stokes and Sons
   }).then((value) {
     Navigator.of(context).pop();
     showSnackBar("Invited SuccessFully!", context);
     String msg = "I Invited you on balaji repo agency app.Download our app from https://www.mediafire.com/file/5ocrwwjmwne4nnb/BalajiRepo.apk/file";
     openwhatsapp(msg, context);
     // Navigator.of(context).pop();
   }).catchError((error) {
     print(error.toString());
     Navigator.of(context).pop();
     return showMyDialog("Error", error.toString(), context);
   });
 }