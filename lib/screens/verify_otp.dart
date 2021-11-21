import 'package:balaji_repo_agency/component/component.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'admin_panel.dart';
import 'home_screen.dart';
class VerifyOTP extends StatefulWidget {
  final  verificationId,status;
  const VerifyOTP({Key? key, this.verificationId, this.status}) : super(key: key);

  @override
  _VerifyOTPState createState() => _VerifyOTPState(verificationId,status);
}
class _VerifyOTPState extends State<VerifyOTP> {
  final verificationId,status;
  _VerifyOTPState(this.verificationId, this.status);
  TextEditingController otp=TextEditingController();
  FirebaseAuth auth = FirebaseAuth.instance;
  bool loading=true;
  void verifyOTP()async {
    print("verify with"+otp.text);
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId, smsCode: otp.text);
    try{
      // await auth.signInWithCredential(credential);
      final User? user = (await auth.signInWithCredential(credential)).user;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool('login',false);
      showSnackBar("Verified Successfully",context);
      if(status=="admin") {
        prefs.setString('type',"admin");
        Navigator.push(context, MaterialPageRoute(builder:
            (context)=>const AdminPanel())).then((value) => SystemNavigator.pop());
      } else {
        prefs.setString('type',"user");
        Navigator.push(context, MaterialPageRoute(builder:
            (context)=>const HomeScreen())).then((value) => SystemNavigator.pop());
      }
      print("Successfully signed in UID: ${user!.uid}");
    }catch (e) {
      print("Failed to sign in: " + e.toString());
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Balaji Repo Agency"),
      ),
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage("assets/images/bg_blur.jpg")
            )
        ),
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.only(top: MediaQuery.of(context).size.height*.4,),
            width: double.infinity,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(40),
                    topRight:  Radius.circular(40))
            ),
            child: Column(
              children: [
                Center(
                  heightFactor: 3,
                  child: Text("Enter OTP",style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                      color: Colors.deepPurple
                  ),),
                ),
               loading?Container(
                  margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*.1),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.teal,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: TextFormField(
                      keyboardType: TextInputType.phone,
                      style: TextStyle(color: Colors.white),
                      controller: otp,
                      decoration:const InputDecoration(
                          icon: Icon(Icons.email_outlined,color: Colors.white,),
                          hintText: "OTP",
                          hintStyle: TextStyle(
                              color: Colors.white70
                          ),
                          border: InputBorder.none
                      ),
                    ),
                  ),
                ):CircularProgressIndicator(),
                SizedBox(height: 10,),
                ElevatedButton(onPressed: (){
                  print("clicked");
                  setState(() {
                    loading=false;
                  });
                  verifyOTP();
                  // }
                }, child: Text("Verify",style: TextStyle(
                    fontSize: 17
                ),),
                  style:buttonStyle()),
              ],
            ),

          ),
        ),
      ),
    );
  }

}
