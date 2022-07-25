import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
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

buildSlideShow() {
  return ImageSlideshow(
    /// Width of the [ImageSlideshow].
    width: double.infinity,

    /// Height of the [ImageSlideshow].
    height: 400,

    /// The page to show when first creating the [ImageSlideshow].
    initialPage: 0,

    /// The color to paint the indicator.
    indicatorColor: Colors.blue,

    /// The color to paint behind th indicator.
    indicatorBackgroundColor: Colors.grey,

    /// The widgets to display in the [ImageSlideshow].
    /// Add the sample image file into the images folder
    children: [
      // Image.asset(
      //   'assets/images/logo.png',
      //   fit: BoxFit.contain,
      // ),
      Image.asset(
        'assets/images/logo2.jpeg',
        fit: BoxFit.contain,
      ),
      Image.asset(
        'assets/images/logo3.jpeg',
        fit: BoxFit.contain,
      ),
    ],

    /// Called whenever the page in the center of the viewport changes.
    onPageChanged: (value) {
      // print('Page changed: $value');
    },

    /// Auto scroll interval.
    /// Do not auto scroll with null or 0.
    autoPlayInterval: 1500,

    /// Loops back to first slide.
    isLoop: true,
  );
}
