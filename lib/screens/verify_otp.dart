import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'admin_panel.dart';
class VerifyOTP extends StatefulWidget {
  final  verificationId;
  const VerifyOTP({Key? key, this.verificationId}) : super(key: key);

  @override
  _VerifyOTPState createState() => _VerifyOTPState(verificationId);
}
class _VerifyOTPState extends State<VerifyOTP> {
  final verificationId;
  _VerifyOTPState(this.verificationId);
  TextEditingController otp=TextEditingController();
  FirebaseAuth auth = FirebaseAuth.instance;
  void verifyOTP()async {
    print("verify with"+otp.text);
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId, smsCode: otp.text);
    try{
      await auth.signInWithCredential(credential);
      final User? user = (await auth.signInWithCredential(credential)).user;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool('login',false);
      Navigator.push(context, MaterialPageRoute(builder:
          (context)=>const AdminPanel())).then((value) => SystemNavigator.pop());
      print("Successfully signed in UID: ${user!.uid}");
    }catch (e) {
      print("Failed to sign in: " + e.toString());
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Verify Mobile"),
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
            //  height: MediaQuery.of(context).size.height*.7,
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
                Container(
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
                      decoration: InputDecoration(
                          icon: Icon(Icons.email_outlined,color: Colors.white,),
                          hintText: "OTP",
                          hintStyle: TextStyle(
                              color: Colors.white70
                          ),
                          border: InputBorder.none
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10,),
                ElevatedButton(onPressed: (){
                  //  Navigator.push(context, MaterialPageRoute(builder: (context)=>()));
                  //   if(mobile.text.isNotEmpty){
                  print("clicked");
                  verifyOTP();
                  // }
                }, child: Text("Verify",style: TextStyle(
                    fontSize: 17
                ),),
                  style: ButtonStyle(
                      minimumSize: MaterialStateProperty.all(Size(120, 40)),
                      backgroundColor: MaterialStateProperty.all(Colors.teal),
                      shape:MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius:BorderRadius.circular(20),
                          side: BorderSide.none
                      ))
                  ),),
              ],
            ),

          ),
        ),
      ),
    );
  }

}
