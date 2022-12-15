import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
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
  Map profile = {};
  String? role;
  var nameCtrl = TextEditingController();
  var address = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  XFile? profileImage;
  XFile? selfie;
  CollectionReference phone = FirebaseFirestore.instance.collection('phone');
  FirebaseAuth auth = FirebaseAuth.instance;
  String? profileImageURL;
  String? selfieURL;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    profile = LocalStorage.getUserProfile;
    if (profile.isNotEmpty) {
      setState(() {
        nameCtrl.text = profile["name"] ?? "";
        address.text = profile["city"] ?? "";
        profileImageURL = profile["profilePic"];
        selfieURL = profile["selfie"];
      });
    }
  }

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
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                Column(
                  children: [
                    GestureDetector(
                        onTap: () {
                          showImagePicker(context, true);
                        },
                        child: profileImage == null && profileImageURL == null
                            ? defaultPRofile()
                            : profileImage != null
                                ? Container(
                                    width: 100,
                                    height: 100,
                                    decoration: BoxDecoration(
                                        color: Colors.teal,
                                        borderRadius:
                                            BorderRadius.circular(1000),
                                        image: DecorationImage(
                                            image: FileImage(File(
                                                profileImage!.path.toString())),
                                            fit: BoxFit.cover)),
                                  )
                                : Container(
                                    width: 100,
                                    height: 100,
                                    decoration: BoxDecoration(
                                        color: Colors.teal,
                                        borderRadius:
                                            BorderRadius.circular(1000),
                                        image: DecorationImage(
                                            image:
                                                NetworkImage(profileImageURL!),
                                            fit: BoxFit.cover)),
                                  )
                        //

                        ),
                    Text("Profile Pic"),
                  ],
                ),
                Column(
                  children: [
                    GestureDetector(
                        onTap: () {
                          showImagePicker(context, false);
                        },
                        child: selfie == null && selfieURL == null
                            ? defaultPRofile()
                            : selfie != null
                                ? Container(
                                    width: 100,
                                    height: 100,
                                    decoration: BoxDecoration(
                                        color: Colors.teal,
                                        borderRadius:
                                            BorderRadius.circular(1000),
                                        image: DecorationImage(
                                            image: FileImage(
                                                File(selfie!.path.toString())),
                                            fit: BoxFit.cover)),
                                  )
                                : Container(
                                    width: 100,
                                    height: 100,
                                    decoration: BoxDecoration(
                                        color: Colors.teal,
                                        borderRadius:
                                            BorderRadius.circular(1000),
                                        image: DecorationImage(
                                            image: NetworkImage(selfieURL!),
                                            fit: BoxFit.cover)),
                                  )
                        //

                        ),
                    Text("Selfie"),
                  ],
                )
              ]),
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
                  hintText: "Enter Your Address",
                  hintStyle: TextStyle(fontSize: 14, color: primaryColor),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Container(
                width: double.infinity,
                // decoration:
                //     BoxDecoration(border: Border.all(color: Colors.black)),
                child: DropdownButton<String>(
                  isExpanded: true,
                  value: role,
                  items: <String>[
                    'Sizer',
                    'Collection',
                  ].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  hint: Text("Select Role"),
                  onChanged: (val) {
                    setState(() {
                      role = val;
                    });
                  },
                ),
              ),
              loading
                  ? GestureDetector(
                      onTap: () {
                        if (validate()) {
                          setState(() {
                            // updateProfile();
                            loading = false;
                          });
                          Map<String, Object> data = {
                            "name": name,
                            "city": city,
                            "degignation": role ?? ""
                          };
                          if (profileImage != null && selfie != null) {
                            if (profileImage != null) {
                              FirebaseServices()
                                  .uploadFile(File(profileImage!.path),
                                      "profilepic.jpg")
                                  .then((value) {
                                if (value != null) {
                                  data["profilePic"] = value;
                                  FirebaseServices()
                                      .uploadFile(
                                          File(selfie!.path), "selfie.jpg")
                                      .then((value) {
                                    if (value != null) {
                                      data["selfie"] = value;
                                      FirebaseServices()
                                          .updateProfile(data, context)
                                          .then((value) {
                                        setState(() {
                                          loading = true;
                                        });
                                      });
                                    }
                                  });
                                }
                              });
                            }
                          } else {
                            data["profilePic"] = profileImageURL!;
                            data["selfie"] = selfieURL!;
                            FirebaseServices()
                                .updateProfile(data, context)
                                .then((value) {
                              setState(() {
                                loading = true;
                              });
                            });
                          }
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
            ],
          ),
        ),
      ),
    );
  }

  void showImagePicker(context, bool isprofile) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Wrap(
              children: <Widget>[
                if (isprofile)
                  ListTile(
                      leading: const Icon(Icons.photo_library),
                      title: const Text('Photo Library'),
                      onTap: () {
                        chooseImageFromGalary(isprofile);
                        Navigator.of(context).pop();
                      }),
                ListTile(
                  leading: const Icon(Icons.photo_camera),
                  title: const Text('Camera'),
                  onTap: () {
                    chooseImageFromCamera(isprofile);
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        });
  }

  bool validate() {
    if (name.isEmpty) {
      showSnackBar("Please Enter name", context);
      return false;
    } else if (city.isEmpty) {
      showSnackBar("Please Enter city", context);
      return false;
    } else if (role == null) {
      showSnackBar("Please select Degignation", context);
      return false;
    } else if (profileImageURL == null && profileImage == null) {
      showSnackBar("Please select Profile Image", context);
      return false;
    } else if (selfie == null && selfieURL == null) {
      showSnackBar("Please select selfie Image", context);
      return false;
    }

    return true;
  }

  Widget defaultPRofile() => Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.teal, width: 2),
          borderRadius: BorderRadius.circular(1000),
        ),
        child: Icon(Icons.person_add),
      );
  Future<void> chooseImageFromGalary(bool isPropfile) async {
    XFile? choosedimage = await _picker.pickImage(source: ImageSource.gallery);
    //set source: ImageSource.camera to get image from camera
    setState(() {
      if (isPropfile)
        profileImage = choosedimage;
      else {
        selfie = choosedimage;
      }
    });
    // var status = Permission.photos.isGranted;
    // if (await status) {

    // } else {
    //   var status = Permission.photos.request();
    //   if (await status.isGranted || await status.isLimited) {
    //     XFile? choosedimage =
    //         await _picker.pickImage(source: ImageSource.gallery);
    //     //set source: ImageSource.camera to get image from camera
    //     setState(() {
    //       log(choosedimage.toString());
    //       if (choosedimage != null) profileImage = choosedimage;
    //     });
    //   } else if (await status.isPermanentlyDenied) {
    //     getOpenSettingDialog("Photos Permission",
    //         "We'll need photos permission to update profile picture");
    //   }
    // }
  }

  Future<void> chooseImageFromCamera(bool isPropfile) async {
    // var status = Permission.camera.isGranted;
    // if (await status) {
    XFile? choosedimage =
        await _picker.pickImage(source: ImageSource.camera, imageQuality: 25);
    //set source: ImageSource.camera to get image from camera
    setState(() {
      if (isPropfile)
        profileImage = choosedimage;
      else {
        selfie = choosedimage;
      }
    });
    // } else {
    //   var status = Permission.camera.request();
    //   if (await status.isGranted) {
    //     XFile? choosedimage = await _picker.pickImage(
    //         source: ImageSource.camera, imageQuality: 25);
    //     //set source: ImageSource.camera to get image from camera
    //     setState(() {
    //       profileImage = choosedimage;
    //     });
    //   }
    // }
  }

  getOpenSettingDialog(String title, String detail) {
    // Get.defaultDialog(
    //   title: title,
    //   titlePadding: EdgeInsets.only(top: 10, bottom: 20),
    //   titleStyle:
    //       AppTextStyle.h1.copyWith(color: AppColors.primary, fontSize: 24),
    //   middleTextStyle:
    //       AppTextStyle.heading.copyWith(color: AppColors.borderColor),
    //   middleText: "",
    //   content: Center(
    //     child: Text(
    //       detail,
    //       textAlign: TextAlign.center,

    //     ),
    //   ),
    //   contentPadding: EdgeInsets.symmetric(horizontal: 20),
    //   cancel: GestureDetector(
    //     onTap: () => Get.back(),
    //     child: Padding(
    //       padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
    //       child: Text(
    //         "Cancel",
    //         // style: AppTextStyle.heading.copyWith(color: AppColors.borderColor),
    //       ),
    //     ),
    //   ),
    //   confirm: GestureDetector(
    //     onTap: () {
    //       openAppSettings();

    //     },
    //     child: Padding(
    //       padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
    //       child: Text(
    //         "Open Settings",
    //         // style: AppTextStyle.heading.copyWith(color: AppColors.borderColor),
    //       ),
    //     ),
    //   ),
    // );
  }
}
