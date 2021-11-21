import 'dart:convert';
import 'dart:io';
import 'package:balaji_repo_agency/component/alertdilog.dart';
import 'package:balaji_repo_agency/component/component.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
class AdminPanel extends StatefulWidget {
  const AdminPanel({Key? key}) : super(key: key);

  @override
  _AdminPanelState createState() => _AdminPanelState();
}

class _AdminPanelState extends State<AdminPanel> {
  CollectionReference phone = FirebaseFirestore.instance.collection('phone');
  String mobile='';
  bool loading=true;
var id;
String status="false";
  var cmobile=TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Admin Panel"),
        automaticallyImplyLeading: false,
      ),
      body: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage("assets/images/bg_blur.jpg")
            )
        ),
        child: SingleChildScrollView(
          child: Container(
            width: double.infinity,
            margin: EdgeInsets.only(top: MediaQuery.of(context).size.height*.3,),
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
                  child: Text("Welcome Admin",style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                      color: Colors.deepPurple
                  ),),
                ),
                SizedBox(height: 10,),
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
                        style:const TextStyle(color: Colors.white),
                        controller: cmobile,
                        onChanged: (val)=>mobile=val,
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
                ):Container(
                    child: const CircularProgressIndicator()),
                const SizedBox(height: 10,),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(onPressed: (){
                      mobile=cmobile.text;
                      if(validate()) {
                        setState(() {
                          loading=false;
                        });
                        addPhoneNumber();
                      }
                    }, child:const Text("Invite User",style: TextStyle(
                        fontSize: 17
                    ),),
                      style: buttonStyle(),),
                    ElevatedButton(onPressed: (){
                      if(validate()) {
                        setState(() {
                          loading=false;
                        });
                        checkstatus();
                      }
                    }, child:const Text("Check Mobile Status",style: TextStyle(
                        fontSize: 17
                    ),),
                      style: buttonStyle(),),
                    ElevatedButton(onPressed: (){
                      blockUser();
                    }, child:const Text("Block",style: TextStyle(
                        fontSize: 17
                    ),),
                      style: buttonStyle(),),
                  ],
                ),

              ],
            ),
          ),
        ),
      ),
      floatingActionButton: logoutActionButton(context),
    );
  }
 addPhoneNumber()async {
    mobile=cmobile.text;
   status =await userStatus(mobile) as String;
    if (status == "false") {
     phone
         .add({
       'number': mobile, // John Doe
       'status': "true", // Stokes and Sons
     }).then((value) {
       setState(() {
         loading = !loading;
       });
       showSnackBar("Invited SuccessFully!", context);
     })
         .catchError((error) {
       setState(() {
         loading = !loading;
         cmobile.clear();
       });
       print(error.toString());
       showMyDialog("Error", error.toString(), context);
     });
   }
   else {
      setState(() {
        loading = !loading;
      });
      showSnackBar("This number is already addedd.", context);
    }
 }
  checkstatus()async{
    mobile=cmobile.text;
    status =await userStatus(mobile) as String;
    if (status == "true"||status=="admin") {
      setState(() {
        loading=true;
      });
      String msg="This user is  authorized to use this app";
      showSnackBar(msg,context);
      // phone
      //     .doc(id)
      //     .get()
      //     .then((DocumentSnapshot documentSnapshot) {
      //   if (documentSnapshot.exists) {
      //     setState(() {
      //       loading=true;
      //     });
      //     showSnackBar("This number is authorized", context);
      //     // showMyDialog("Success", "Authorised", context);
      //   } else {
      //     print("not exist");
      //     // Navigator.push(context,
      //     // MaterialPageRoute(builder: (context) => Home()));
      //   }
      // });
    } else {
      setState(() {
        loading=true;
      });
      String msg="This User is not authorized to use this app\nDo you want to authorized";
      AddUserDialog("Not Authorized",msg,mobile,context);
    }
}
bool validate(){
    if(mobile.isEmpty) {
      showSnackBar("Empty Mobile", context);
      return false;
    }else
    if(mobile.length!=10){
      showSnackBar("Invalid mobile number!", context);
      return false;
    }
    return true;
}

  void blockUser() async{
    setState(() {
      loading=false;
    });
    status="false";
    await phone
        .where('number', isEqualTo: mobile)
        .get()
        .then((QuerySnapshot querySnapshot) {
      // print(querySnapshot.toString());
      querySnapshot.docs.forEach((doc) {
        id = doc.id;
        Map<String, dynamic> data =
        doc.data()! as Map<String, dynamic>;
        status = data['status'];
        print("this is status ${status}");
        print(id);
      });
    });
    if(status=="true"){
      phone
          .doc(id)
          .delete()
          .then((value) => showSnackBar("Blocked Successfully", context))
          .catchError((error) => showSnackBar("Error=$error", context));
    }
    else
      showSnackBar("User not found", context);
    setState(() {
      loading=true;
    });
  }
 Future<String> userStatus(String mobile)async{
    status="false";
    await phone
        .where('number', isEqualTo: mobile)
        .get()
        .then((QuerySnapshot querySnapshot) {
      // print(querySnapshot.toString());
      querySnapshot.docs.forEach((doc) {
        id = doc.id;
        Map<String, dynamic> data =
        doc.data()! as Map<String, dynamic>;
        status = data['status'];
        print(id);
        print("status=$data");
      });
    }).catchError((e){
      showSnackBar(e.toString(), context);
    });
    return status;
  }
  }
