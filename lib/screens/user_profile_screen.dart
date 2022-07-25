import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../Screens/widgets/widget_build_functions.dart';
import '../firebase_services.dart';
import '../local_storage_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../component/snack_bar.dart';
import '../constant.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({Key? key}) : super(key: key);

  @override
  _LoginSignupState createState() => _LoginSignupState();
}

class _LoginSignupState extends State<UserProfile> {
  String name = '', city = '';
  bool loading = true;
  CollectionReference phone = FirebaseFirestore.instance.collection('phone');
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Palette.backgroundColor,
      appBar: buildAppBar(context),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 60,
              ),
              Container(
                margin: const EdgeInsets.only(),
                // padding: EdgeInsets.all(),
                child: const Center(
                  child: CircleAvatar(
                    radius: 73,
                    backgroundColor: Colors.teal,
                    child: CircleAvatar(
                      radius: 70,
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.person,
                        size: 77,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              const SizedBox(
                height: 20,
              ),
              TextField(
                onChanged: (val) {
                  name = val;
                },
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: primaryColor),
                    borderRadius: BorderRadius.all(Radius.circular(35.0)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: primaryColor),
                    borderRadius: BorderRadius.all(Radius.circular(35.0)),
                  ),
                  contentPadding: EdgeInsets.all(20),
                  hintText: "Enter Your Name",
                  hintStyle: TextStyle(fontSize: 14, color: primaryColor),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              TextField(
                onChanged: (val) {
                  city = val;
                },
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: primaryColor),
                    borderRadius: BorderRadius.all(Radius.circular(35.0)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: primaryColor),
                    borderRadius: BorderRadius.all(Radius.circular(35.0)),
                  ),
                  contentPadding: EdgeInsets.all(20),
                  hintText: "Enter Your City",
                  hintStyle: TextStyle(fontSize: 14, color: primaryColor),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              loading
                  ? GestureDetector(
                      onTap: () {
                        if (validate()) {
                          setState(() {
                            // updateProfile();
                            loading = false;
                          });
                          FirebaseServices()
                              .updateProfile(name, city, context)
                              .then((value) {
                            setState(() {
                              loading = true;
                            });
                          });
                        }
                      },
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: primaryColor,
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text("Save Profile"),
                      ),
                    )
                  : const Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Center(
                          child: SpinKitCircle(
                        color: Colors.green,
                        size: 50.0,
                      )),
                    ),
              SizedBox(
                height: 100,
              )
              // Container(
              //   height: 800,
              //   // color: Colors.yellow,
              //   child: Stack(
              //     children: [
              //       Positioned(
              //         top: 9,
              //         right: 0,
              //         left: 0,
              //         child: Container(
              //           height: 300,
              //           decoration: const BoxDecoration(
              //             image: DecorationImage(
              //                 image: AssetImage("assets/images/road2.jpg"),
              //                 fit: BoxFit.fill),
              //           ),
              //         ),
              //       ),

              //       // maIN CONTAINER CONTROL
              //       Positioned(
              //         top: 170,
              //         child: Container(
              //           height: 500,
              //           padding: const EdgeInsets.all(20),
              //           width: MediaQuery.of(context).size.width - 40,
              //           margin: const EdgeInsets.symmetric(horizontal: 20),
              //           decoration: BoxDecoration(
              //               color: Colors.white,
              //               borderRadius: BorderRadius.circular(15),
              //               boxShadow: [
              //                 BoxShadow(
              //                     color: Colors.black.withOpacity(0.3),
              //                     blurRadius: 15,
              //                     spreadRadius: 5),
              //               ]),
              //           child: Column(
              //             children: [],
              //           ),
              //         ),
              //       ),
              //       //Trick to add the submit button
              //       Positioned(
              //         top: 630,
              //         right: 0,
              //         left: 0,
              //         child: Center(
              //           child: Container(
              //             height: 90,
              //             width: 90,
              //             padding: const EdgeInsets.all(15),
              //             decoration: BoxDecoration(
              //                 color: Colors.white,
              //                 borderRadius: BorderRadius.circular(50),
              //                 boxShadow: [
              //                   BoxShadow(
              //                     color: Colors.black.withOpacity(.3),
              //                     spreadRadius: 1,
              //                     blurRadius: 2,
              //                     offset: const Offset(0, 1),
              //                   ),
              //                 ]),
              //             child: GestureDetector(
              //                 onTap: () {

              //                   }
              //                   // Navigator.push(
              //                   //     context,
              //                   //     MaterialPageRoute(
              //                   //         builder: (context) => UserScreenHome()));
              //                 },
              //                 child: loading
              //                     ? Container(
              //                         decoration: BoxDecoration(
              //                             gradient: const LinearGradient(
              //                                 colors: [Colors.orange, Colors.red],
              //                                 begin: Alignment.topLeft,
              //                                 end: Alignment.bottomRight),
              //                             borderRadius: BorderRadius.circular(30),
              //                             boxShadow: [
              //                               BoxShadow(
              //                                 color: Colors.black.withOpacity(.3),
              //                                 spreadRadius: 1,
              //                                 blurRadius: 2,
              //                                 offset: const Offset(0, 1),
              //                               ),
              //                             ]),
              //                         child: const Icon(
              //                           Icons.arrow_forward,
              //                           color: Colors.white,
              //                         ),
              //                       )
              //                     : const CircularProgressIndicator()),
              //           ),
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }

  bool validate() {
    if (name.isEmpty) {
      showSnackBar("Please Enter name", context);
      return false;
    } else if (city.isEmpty) {
      showSnackBar("Please Enter city", context);
      return false;
    }
    return true;
  }
}
