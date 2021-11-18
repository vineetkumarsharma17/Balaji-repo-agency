import 'package:balaji_repo_agency/component/alertdilog.dart';
import 'package:balaji_repo_agency/screens/admin_panel.dart';
import 'package:balaji_repo_agency/screens/verify_otp.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
  String? id,status;
  CollectionReference phone = FirebaseFirestore.instance.collection('phone');
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
                      keyboardType: TextInputType.phone,
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
                      checkUser();
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
  void checkUser()async{
    await phone
        .where('number', isEqualTo: mobile.text)
        .get()
        .then((QuerySnapshot querySnapshot) {
          print(querySnapshot.toString());
          loading=!loading;
      // querySnapshot.docs.forEach((doc) {
      //   id = doc.id;
      //   Map<String, dynamic> data =
      //   doc.data()! as Map<String, dynamic>;
      //   status = data['status'];
      //   print("this is status ${status}");
      //   print(id);
      // });
    });
    // if (status == "true") {
    //   phone
    //       .doc(id)
    //       .get()
    //       .then((DocumentSnapshot documentSnapshot) {
    //     if (documentSnapshot.exists) {
    //       showMyDialog("Success", "Authorised", context);
    //     } else {
    //       // Navigator.push(context,
    //       // MaterialPageRoute(builder: (context) => Home()));
    //     }
    //   });
    // } else {
    //   showMyDialog("fail", "unAuthorised", context);
    // }
  }
  void sendOTP()async{
      auth.verifyPhoneNumber(
      phoneNumber: '+91'+mobile.text,
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
