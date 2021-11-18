import 'dart:convert';
import 'dart:io';
import 'package:balaji_repo_agency/component/component.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
class AdminPanel extends StatefulWidget {
  const AdminPanel({Key? key}) : super(key: key);

  @override
  _AdminPanelState createState() => _AdminPanelState();
}

class _AdminPanelState extends State<AdminPanel> {
  FilePickerResult? result;
  bool loading=true;

  var mobile=TextEditingController();
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
            margin: EdgeInsets.only(top: MediaQuery.of(context).size.height*.4,),
            //  height: MediaQuery.of(context).size.height*.7,
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(40),
                    topRight:  Radius.circular(40))
            ),
            child: Column(
              children: [
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
                  // sendOTP();
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
              ],
            ),

          ),
        ),
      ),
      floatingActionButton: logoutActionButton(),
    );
  }
  }
