import 'dart:convert';
import 'dart:io';

import 'package:balaji_repo_agency/component/component.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool loading = true;
  bool log_out_btn = true;
  var rc_number=TextEditingController();
  String ?query;
  search()async{
    setState(() {
      loading=false;
    });
    query=rc_number.text;
    var data = {
      "data": query,
    };
    var response = await http.post(
        Uri.parse(
            "http://vkwilson.live/getdata.php"),
        body: json.encode(data)).catchError((e){
      setState(() {
        loading=true;
      });
      if(e is SocketException)
        return showSnackBar("No internet connection", context);

    });
    var obj = jsonDecode(response.body);
    if(obj["status"]==1){
      Map tmp=obj["data"];
      print("Data========================");
      String detail='';
      for( var x in tmp.keys) {
        detail=detail+"$x=${tmp[x]}\n";
        // print("$x=${tmp[x]}");

      }
      showDataDialog("Data Found!",detail,context);
      // print(detail);
    }
    else{
      showSnackBar("No data found", context);
    }
    setState(() {
      rc_number.clear();
      loading=true;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          decoration: const BoxDecoration(
              image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage("assets/images/bg_blur.jpg")
              )
          ),
          child: Container(
            width: double.infinity,
            margin: EdgeInsets.only(top: MediaQuery
                .of(context)
                .size
                .height * .4,),
            //  height: MediaQuery.of(context).size.height*.7,
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(40),
                    topRight: Radius.circular(40))
            ),
            child: Column(
              children: [
                const Center(
                  heightFactor: 3,
                  child: Text("Welcome! User", style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                      color: Colors.deepPurple
                  ),),
                ),
                SizedBox(height: 10,),
                loading ? Container(
                  margin: EdgeInsets.symmetric(horizontal: MediaQuery
                      .of(context)
                      .size
                      .width * .1),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.teal,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: TextField(
                        onTap: ()=>setState(() {
                          log_out_btn=false;
                        }),
                        style: const TextStyle(color: Colors.white),
                        controller: rc_number,
                        decoration: const InputDecoration(
                            icon: Icon(Icons.email_outlined, color: Colors
                                .white,),
                            hintText: "Enter Data",
                            hintStyle: TextStyle(
                                color: Colors.white70
                            ),
                            border: InputBorder.none
                        ),
                      )
                  ),
                ) : Container(
                    child: const CircularProgressIndicator()),
                const SizedBox(height: 10,),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      log_out_btn=true;
                    });
                  print("butn click");
                  if(validate()){
                    search();
                  }
                }, child: const Text("Search", style: TextStyle(
                    fontSize: 17
                ),),
                  style: buttonStyle(),),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton:Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0,vertical: 10),
        child: log_out_btn?logoutActionButton(context):Text("")
      )
    );
  }
  bool validate(){
    String mobile=this.rc_number.text;
    if(mobile.isEmpty) {
      showSnackBar("Please insert Data", context);
      return false;
    }
    return true;
  }

}
