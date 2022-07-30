import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../Screens/widgets/widget_build_functions.dart';
import '../component/drawer.dart';
import '../constant.dart';
import '../firebase_services.dart';

import '../component/snack_bar.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var numberCtrl = TextEditingController();
  var passwordCtrl = TextEditingController();
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        // drawer: MyDrawer(),
        appBar: AppBar(title: Text(companyName)),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              buildTextField(
                  numberCtrl, true, "Enter Mobile", "Mobile", Icons.phone),
              SizedBox(
                height: 20,
              ),
              buildTextField(passwordCtrl, false, "Enter Password", "Password",
                  Icons.lock),
              !loading
                  ? buildButton("Log In", () {
                      if (validate()) {
                        setState(() {
                          loading = true;
                        });
                        FirebaseServices()
                            .login(numberCtrl.text, passwordCtrl.text, context)
                            .then((value) {
                          setState(() {
                            loading = false;
                          });
                        });
                      }
                    })
                  : const Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Center(
                          child: SpinKitCircle(
                        color: Colors.green,
                        size: 50.0,
                      )),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  bool validate() {
    if (numberCtrl.text.isEmpty) {
      showSnackBar("Empty Mobile", context);
      return false;
    } else if (numberCtrl.text.length != 10) {
      showSnackBar("Mobile number should be 10 digits.", context);
      return false;
    } else if (passwordCtrl.text.isEmpty) {
      showSnackBar("Empty password", context);
      return false;
    }
    FocusManager.instance.primaryFocus?.unfocus();
    return true;
  }
}
