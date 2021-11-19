import 'package:flutter/material.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
logoutActionButton(context){
  return FloatingActionButton(
    child: Icon(Icons.logout),
      onPressed:()async{
   SharedPreferences preferences=await SharedPreferences.getInstance();
   preferences.setBool("login", true);
   showSnackBar("Logout successfully!",context);
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
     duration: const Duration(milliseconds: 1000),
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