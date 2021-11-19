import 'dart:convert';
import 'dart:io';
import 'package:balaji_repo_agency/component/alertdilog.dart';
import 'package:balaji_repo_agency/component/component.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
class AdminPanel extends StatefulWidget {
  const AdminPanel({Key? key}) : super(key: key);

  @override
  _AdminPanelState createState() => _AdminPanelState();
}

class _AdminPanelState extends State<AdminPanel> {
  CollectionReference phone = FirebaseFirestore.instance.collection('phone');
  FilePickerResult? result;
  String mobile='';
  bool loading=true;
var id;
String? status;
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(onPressed: (){
                      if(validate()) {
                        setState(() {
                          loading=false;
                        });
                        addPhoneNumber();
                      }
                      // setState(() {
                      //   loading=false;
                      // });
                      // addPhoneNumber(mobile!);

                    }, child:const Text("Invite User",style: TextStyle(
                        fontSize: 17
                    ),),
                      style: buttonStyle(),),
                    ElevatedButton(onPressed: (){
                  checkstatus();
                    }, child:const Text("check",style: TextStyle(
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
  Future<void> addPhoneNumber() {
    return phone
        .add({
      'number': mobile, // John Doe
      'status': "true", // Stokes and Sons
    }).then((value) {
          setState(() {
            loading=!loading;
            cmobile.clear();
          });
          return showSnackBar("Invited SuccessFully!", context);})
        .catchError((error) {
      setState(() {
        loading=!loading;
        cmobile.clear();
      });
      print(error.toString());
      return showMyDialog("Error", error.toString(), context);}  );
  }
  checkstatus()async{

    setState(() {
      loading=true;
      showSnackBar("This function is under development!", context);
    });
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

  void blockUser() {
    setState(() {
      loading=true;
      showSnackBar("This function is under development!", context);
    });
  }
  }
