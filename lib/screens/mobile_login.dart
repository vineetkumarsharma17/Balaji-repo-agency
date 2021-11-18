import 'package:balaji_repo_agency/screens/admin_panel.dart';
import 'package:balaji_repo_agency/screens/verify_otp.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home_screen.dart';
class LoginMobile extends StatefulWidget {
  const LoginMobile({Key? key}) : super(key: key);

  @override
  _LoginMobileState createState() => _LoginMobileState();
}
class _LoginMobileState extends State<LoginMobile> {
  TextEditingController mobile=TextEditingController();
  TextEditingController _codeController=TextEditingController();
  bool loading=true;
  FirebaseAuth auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    // mobile.text=await _autoFill.hint;
    return Scaffold(
      appBar: AppBar(
        title: Text("Balaji Repo"),
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
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(40),
                    topRight:  Radius.circular(40))
            ),
            child: Column(
              children: [
                const Center(
                  heightFactor: 3,
                  child: Text("Sign In",style: TextStyle(
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
                      style:const TextStyle(color: Colors.white),
                      controller: mobile,
                      decoration: const InputDecoration(
                          icon: Icon(Icons.email_outlined,color: Colors.white,),
                          hintText: "Mobile",
                          hintStyle: TextStyle(
                              color: Colors.white70
                          ),
                          border: InputBorder.none
                      ),
                    )
                  ),
                ):const CircularProgressIndicator(),
                const SizedBox(height: 10,),
                ElevatedButton(onPressed: (){
                //  Navigator.push(context, MaterialPageRoute(builder: (context)=>()));
                //   if(mobile.text.isNotEmpty){
                    print("clicked");
                    setState(() {
                      loading=false;
                    });
                      sendOTP();
                    // }
                  }, child:const Text("Send OTP",style: TextStyle(
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
/*  loginUser(String phone)async{
    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phone,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await FirebaseAuth.instance
              .signInWithCredential(credential)
              .then((value) async {
            if (value.user != null) {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => HomeScreen()),
                      (route) => false);
            }
          });
        },
        verificationFailed: (FirebaseAuthException e) {
          print(e.message);
        },
        codeSent: (String verficationID, int? resendToken) {
          setState(() {
            verficationID = verficationID;
          });
        },
        codeAutoRetrievalTimeout: (String verificationID) {
          setState(() {
            _verificationCode = verificationID;
          });
        },
        timeout: Duration(seconds: 120));
  }*/
 /* Future loginUser(String phone) async{
    print("=======================login"+phone);
    FirebaseAuth _auth = FirebaseAuth.instance;
    _auth.verifyPhoneNumber(
        phoneNumber: phone,
        timeout:const Duration(seconds: 10),
        verificationCompleted: (AuthCredential credential) async{
          Navigator.of(context).pop();
          await auth.signInWithCredential(credential);
          final User? user = (await auth.signInWithCredential(credential)).user;
          if(user != null){
            Navigator.push(context, MaterialPageRoute(
                builder: (context) =>const HomeScreen()
            ));
          }else{
            print("Error");
          }
          //This callback would gets called when verification is done auto maticlly
        },
        verificationFailed: (FirebaseAuthException e) {
          if (e.code == 'invalid-phone-number') {
            print('The provided phone number is not valid.');
            print("=============================verified");
            print(e);}
        },
        codeSent: (String verificationId, int? resendToken){
          print("Send");
          // showDialog(
          //     context: context,
          //     barrierDismissible: false,
          //     builder: (context) {
          //       return AlertDialog(
          //         title: Text("Give the code?"),
          //         content: Column(
          //           mainAxisSize: MainAxisSize.min,
          //           children: <Widget>[
          //             TextField(
          //               controller: _codeController,
          //             ),
          //           ],
          //         ),
          //         actions: <Widget>[
          //           FlatButton(
          //             child: Text("Confirm"),
          //             textColor: Colors.white,
          //             color: Colors.blue,
          //             onPressed: () async{
          //               final code = _codeController.text.trim();
          //               PhoneAuthCredential credential = PhoneAuthProvider.credential(
          //                   verificationId: verificationId, smsCode: code);
          //               await auth.signInWithCredential(credential);
          //               final User? user = (await auth.signInWithCredential(credential)).user;
          //               if(user != null){
          //                 Navigator.push(context, MaterialPageRoute(
          //                     builder: (context) => HomeScreen()
          //                 ));
          //               }else{
          //                 print("Error");
          //               }
          //             },
          //           )
          //         ],
          //       );
          //     }
          // );
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          print("=============================timeout");
          print("Timeout");
        },
    );
  }*/
  void sendOTP()async{
      auth.verifyPhoneNumber(
      phoneNumber: '+918874327867',
        verificationCompleted: (PhoneAuthCredential credential) async {
          await auth.signInWithCredential(credential);
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setBool('login',false);
          Navigator.push(context, MaterialPageRoute(builder:
              (context)=>const AdminPanel())).then((value) => SystemNavigator.pop());
        },
      verificationFailed: (FirebaseAuthException e) {
        loading=true;
    if (e.code == 'invalid-phone-number') {
    print('The provided phone number is not valid.');
        //print("=============================verified");
        print(e);}
      },
      codeSent: (String verificationId, int? resendToken)async {
        loading=true;
        print("code sent to "+mobile.text);
        print(verificationId);
        Navigator.push(context, MaterialPageRoute(builder:
            (context)=>VerifyOTP(verificationId: verificationId,)));
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        print("=============================timeout");
        print("Timeout");
      },
    );
  }
}
