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
  bool loading=true;
var id;
String? status;
  var mobile=TextEditingController();
  var cmobile=TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar("Admin Panel"),
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
                Center(
                  heightFactor: 3,
                  child: Text("Welcome!",style: TextStyle(
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
                ):Container(
                    child: const CircularProgressIndicator()),
                const SizedBox(height: 10,),
                ElevatedButton(onPressed: (){
                  //  Navigator.push(context, MaterialPageRoute(builder: (context)=>()));
                  //   if(mobile.text.isNotEmpty){
                  print("clicked");
                  setState(() {
                    loading=false;
                  });
                  addPhoneNumber(mobile.text);
                  // }
                }, child:const Text("Invite User",style: TextStyle(
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
                        style:const TextStyle(color: Colors.white),
                        controller: cmobile,
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
                ),
                const SizedBox(height: 10,),
                ElevatedButton(onPressed: (){
                  //  Navigator.push(context, MaterialPageRoute(builder: (context)=>()));
                  //   if(mobile.text.isNotEmpty){
                  print("clicked");
                  setState(() {
                    loading=false;
                  });
                  checkstatus();
                  // }
                }, child:const Text("check status",style: TextStyle(
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
      floatingActionButton: logoutActionButton(),
    );
  }
  Future<void> addPhoneNumber(String num) {
    return phone
        .add({
      'number': num, // John Doe
      'status': "true", // Stokes and Sons
    })
        .then((value) {
          setState(() {
            loading=!loading;
          });
          return showMyDialog("Success", "Addedd", context);})
        .catchError((error) {
      setState(() {
        loading=!loading;
      });
      print(error.toString());
      return showMyDialog("Error", error.toString(), context);}  );
  }
  checkstatus()async{
    print("chek status");

}
  }
