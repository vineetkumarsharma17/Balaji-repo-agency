import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../component/alert_box.dart';
import '../../constant.dart';
import '../../local_storage_services.dart';

import '../../firebase_services.dart';

Widget buildTextField(TextEditingController controller, bool isNumber,
    String hint, String lable, var icon) {
  return Container(
    child: TextField(
      controller: controller,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      inputFormatters: [LengthLimitingTextInputFormatter(10)],
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      decoration: InputDecoration(
        prefixIcon: Icon(
          icon,
          color: primaryColor,
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: primaryColor),
          borderRadius: const BorderRadius.all(Radius.circular(35.0)),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.teal),
          borderRadius: BorderRadius.all(Radius.circular(35.0)),
        ),
        prefix: isNumber
            ? const Text(
                "+91",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              )
            : const SizedBox(),
        contentPadding: const EdgeInsets.symmetric(vertical: 12),
        hintText: hint,
        labelText: lable,
        hintStyle: const TextStyle(fontSize: 14, color: Colors.green),
      ),
    ),
  );
}

buildAppBar(context) {
  return AppBar(
    title: Text(
      companyName,
      style: TextStyle(fontSize: 15),
    ),
    actions: [
      Padding(
          padding: const EdgeInsets.only(right: 15.0),
          child: TextButton(
              onPressed: () {
                showMyDialog(
                    "Alert!",
                    "Please confirm to log out.",
                    context,
                    "Log Out",
                    () {
                      LocalStorage.logOut().then((value) =>
                          FirebaseServices().navigateToHome(context));
                    },
                    "No",
                    () {
                      Navigator.pop(context);
                    },
                    true);
              },
              child: const Text(
                "Logout",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold),
              ))),
    ],
    // automaticallyImplyLeading: false,
  );
}

Widget buildButton(String text, var function) {
  return GestureDetector(
    onTap: function,
    child: Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      margin: EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
          border: Border.all(color: primaryColor),
          borderRadius: BorderRadius.circular(200)),
      child: Text(text),
    ),
  );
}
