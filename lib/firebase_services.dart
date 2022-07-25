import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../Screens/admin_panel.dart';
import '../Screens/search_screen.dart';
import '../Screens/user_profile_screen.dart';
import '../component/snack_bar.dart';
import '../constant.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:geolocator/geolocator.dart';
import 'Screens/loginscreen.dart';
import 'component/alert_box.dart';
import 'local_storage_services.dart';

FirebaseAuth auth = FirebaseAuth.instance;
CollectionReference users = FirebaseFirestore.instance.collection('users');

class FirebaseServices {
  void init(context) async {
    if (LocalStorage.isLogin) {
      checkVersion(context);
      log("user Found");
      final userAuth = await checkUser(context);
      if (userAuth == true) {
        navigateToHome(context);
      } else {
        showNotAuthorisedDialog(context);
      }
    } else {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => LoginScreen()));
    }
  }

  Future<void> login(String num, String pass, context) async {
    try {
      final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
      var androidId = await deviceInfoPlugin.androidInfo.then((value) {
        // log(value.toMap().toString()!);
        return value.id;
      });
      log("Android hhid:" + androidId!);
      DocumentSnapshot snapshot = await users.doc(num).get().catchError((e) {
        if (e is FirebaseException) {
          switch (e.code) {
            case "unavailable":
              showSnackBar("No Internet Connection", context);
              break;
            default:
              showSnackBar(e.message, context);
          }
        }
      });
      if (snapshot.exists) {
        Map data = snapshot.data() as Map;
        if (data["device_id"] != '' && data["device_id"] != androidId) {
          log("Not Authoriged");
          showNotAuthorisedDialog(context);
        } else if (data["password"] != pass) {
          log("Pass not mathc your pass:$pass online pass:" +
              data["password"].toString());
          showSnackBar("Wrong Password.", context);
        } else if (data["device_id"] == '' || data["device_id"] == androidId) {
          users.doc(num).update({"device_id": androidId}).then(
              (value) => log("device is updated"));
          LocalStorage.setLogin();
          LocalStorage.setNumber(num);
          showSnackBar("Log In Success", context);
          LocalStorage.setRole(data["role"]);
          navigateToHome(context);
        }
        log("Snap:" + data.toString());
      } else {
        log("not exixt");
        showNotAuthorisedDialog(context);
      }
    } catch (e) {
      log("Error :$e");
      return;
    }
  }

  Future<bool> checkUser(context) async {
    String mobile = LocalStorage.getNumber;
    log("number found in local:$mobile");
    try {
      DocumentSnapshot snapshot = await users.doc(mobile).get().catchError((e) {
        if (e is FirebaseException) {
          showSnackBar(e.code, context);
        }

        log("firebase error" + e.toString());
      });
      if (snapshot.exists) {
        Map data = snapshot.data() as Map;
        log("foundjhh" + data.toString());
        LocalStorage.setLogin();
        LocalStorage.setNumber(snapshot.id);
        LocalStorage.setRole(data["role"]);
        return true;
      } else {
        return false;
      }
    } catch (e) {
      log("Error");
      showSnackBar(e.toString(), context);
      return false;
    }
  }

  Future<void> getUserDetails(context, String mobile) async {
    try {
      DocumentSnapshot snapshot = await users.doc(mobile).get().catchError((e) {
        if (e is FirebaseException) {
          showSnackBar(e.code, context);
        }

        log("firebase error" + e.toString());
      });
      if (snapshot.exists) {
        Map data = snapshot.data() as Map;
        showMyDialog(
            "Success",
            "$mobile is added as ${data["role"].toUpperCase()}.\nDo you want to share detail with user?",
            context,
            "Share Details",
            () async {
              String msg =
                  "Hi I Invited you on $companyName app as ${data["role"].toUpperCase()}.Please download our app from $webLink\n";
              msg += "Your User id-$mobile\n";
              msg += "Your password-${data["password"]}";
              await Share.share(msg);
            },
            "No",
            () {
              Navigator.pop(context);
            },
            false);
        return;
      } else {
        showSnackBar("No User Found for this number:$mobile", context);
        return;
      }
    } catch (e) {
      log("Error");
      showSnackBar(e.toString(), context);
      return;
    }
  }

  Future<void> deleteUser(context, String mobile) async {
    try {
      await users
          .doc(mobile)
          .delete()
          .then((value) =>
              showSnackBar("$mobile is blocked successfully.", context))
          .catchError((e) {
        if (e is FirebaseException) {
          showSnackBar(e.code, context);
        }
        log("firebase error" + e.toString());
      });
    } catch (e) {
      log("Error");
      showSnackBar(e.toString(), context);
      return;
    }
  }

  Future<void> addUser(String mobile, String pass, String role, context) async {
    try {
      Map<String, dynamic> data = {
        "device_id": "",
        "password": pass,
        "role": role,
      };
      await users
          .doc(mobile)
          .set(data)
          .then((value) => showMyDialog(
              "Success",
              "$mobile is added as ${role.toUpperCase()}.\nDo you want to share detail with user?",
              context,
              "Share Details",
              () async {
                String msg =
                    "Hi I Invited you on $companyName app as ${role.toUpperCase()}.Please download our app from $webLink\n";
                msg += "Your User id-$mobile\n";
                msg += "Your password-$pass";
                await Share.share(msg);
              },
              "No",
              () {
                Navigator.pop(context);
              },
              false))
          .catchError((e) {
        if (e is FirebaseException) {
          showSnackBar(e.code, context);
        }
        log("firebase error" + e.toString());
        return;
      });
    } catch (e) {
      log("error:$e");
      return;
    }
  }

  void navigateToHome(context) {
    String role = LocalStorage.getRole;
    log("role:$role");
    if (role == 'admin') {
      LocalStorage.setRole(role);
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => AdminPanelScreen()));
    } else if (role == 'user') {
      LocalStorage.setRole(role);
      final isProfileSaved = LocalStorage.isRegistered;
      if (isProfileSaved) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => SearchScreen()));
      } else {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => UserProfile()));
      }
    } else {
      LocalStorage.clearLogin();
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => LoginScreen()));
    }
  }

  Future<void> updateProfile(String name, String city, context) async {
    String number = LocalStorage.getNumber;
    log(number);
    Map<String, Object> data = {"name": name, "city": city};
    users.doc(number).update(data).then((value) {
      log("success");
      showSnackBar("Profile updated", context);
      LocalStorage.setRegistered();
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => const SearchScreen()));
    }).catchError((e) {
      log(e.toString());

      if (e is SocketException)
        return showSnackBar("No internet connection", context);
    });
  }

  void checkVersion(context) async {
    CollectionReference appdata =
        FirebaseFirestore.instance.collection('appData');
    log("run---------");
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    int myversion = int.parse(packageInfo.buildNumber);
    DocumentSnapshot snapshot =
        await appdata.doc("version").get().catchError((e) {
      if (e is FirebaseException) {
        switch (e.code) {
          case "unavailable":
            showSnackBar("No Internet Connection", context);
            break;
          default:
            showSnackBar(e.message, context);
        }
      }
    });
    log(snapshot.data().toString());
    if (snapshot.exists) {
      Map data = snapshot.data() as Map;
      int onlineVersion = data["version"];
      log("online $onlineVersion");
      if (onlineVersion > myversion) {
        showMyDialog(
            "Update Available!",
            "Please Update Your App.",
            context,
            "Update",
            () {
              final Uri url = Uri.parse(webLink);
              launchUrl(url, mode: LaunchMode.externalNonBrowserApplication);
            },
            "Not Now",
            () {
              Navigator.pop(context);
            },
            true);
      }
    }
  }

  void deleteFireStoreData(CollectionReference ref, String id, context) {
    try {
      ref.doc(id).delete().catchError((e) {
        if (e is FirebaseException) {
          switch (e.code) {
            case "unavailable":
              showSnackBar("No Internet Connection", context);
              break;
            default:
              showSnackBar(e.message, context);
          }
        }
      });
    } catch (e) {}
  }

  Future<void> addFireStoreData(
      CollectionReference ref, Map<String, dynamic> data, context) async {
    try {
      log("run======");
      await ref.add(data).catchError((e) {
        if (e is FirebaseException) {
          showSnackBar(e.code, context);
        }
        log("firebase error" + e.toString());
      });
    } catch (e) {
      log("error:$e");
      return;
    }
  }

  checkLocationPermisson(context) async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      showMyDialog(
          "Allow Location service",
          "Please allow Location service to search data",
          context,
          "Open Setting",
          () async {
            await Geolocator.openLocationSettings();
          },
          "Cancel",
          () {
            // Navigator.pop(context);
          },
          false);
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.

    } else {
      log(serviceEnabled.toString());
      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          showMyDialog(
              "Permission Denied",
              "Please allow Location permission to search data",
              context,
              "Open Setting",
              () async {
                await openAppSettings();
              },
              "Cancel",
              () {
                // Navigator.pop(context);
              },
              false);
          // Permissions are denied, next time you could try
          // requesting permissions again (this is also where
          // Android's shouldShowRequestPermissionRationale
          // returned true. According to Android guidelines
          // your App should show an explanatory UI now.
          //return Future.error('Location permissions are denied');
        }
      }
      if (permission == LocationPermission.deniedForever) {
        showMyDialog(
            "Permission Denied",
            "Please allow Location permission to search data",
            context,
            "Open Setting",
            () async {
              await openAppSettings();
            },
            "Cancel",
            () {
              // Navigator.pop(context);
            },
            false);
        // Permissions are denied forever, handle appropriately.
        // return Future.error(
        //     'Location permissions are permanently denied, we cannot request permissions.');
      }
      try {
        await Geolocator.getCurrentPosition();
        // log(position.toJson().toString());
      } catch (e) {
        showMyDialog(
            "Permission Denied",
            e.toString(),
            context,
            "Open Setting",
            () async {
              try {
                await Geolocator.getCurrentPosition()
                    .then((value) => Navigator.pop(context));
              } catch (e) {}
              // await Geolocator.openLocationSettings();
            },
            "",
            () {
              // Navigator.pop(context);
            },
            false);
      }
    }
  }
}
