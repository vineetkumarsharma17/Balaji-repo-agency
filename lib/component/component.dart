import 'package:flutter/material.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
 appBar(String title){
  return AppBar(title: Text(title),);
}
logoutActionButton(){
  return FloatingActionButton(
    child: const Text("Log Out"),
      onPressed:()async{
   SharedPreferences preferences=await SharedPreferences.getInstance();
   preferences.setBool("login", false);
   exit(0);
  });
}