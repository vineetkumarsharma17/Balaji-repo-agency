import 'package:balaji_repo_agency/component/component.dart';
import 'package:flutter/material.dart';
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool loading = true;

  @override
  Widget build(BuildContext context) {
    var rc_number=TextEditingController();
    return Scaffold(
      backgroundColor: Colors.white,
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
                  child: Text("Welcome!", style: TextStyle(
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
                      child: TextFormField(
                        style: const TextStyle(color: Colors.white),
                        controller: rc_number,
                        decoration: const InputDecoration(
                            icon: Icon(Icons.email_outlined, color: Colors
                                .white,),
                            hintText: "Enter RC number",
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
                ElevatedButton(onPressed: () {
                  //  Navigator.push(context, MaterialPageRoute(builder: (context)=>()));
                  //   if(mobile.text.isNotEmpty){
                  print("clicked");
                  setState(() {
                    loading = false;
                  });
                  // addPhoneNumber(mobile.text);
                  // }
                }, child: const Text("Search", style: TextStyle(
                    fontSize: 17
                ),),
                  style: buttonStyle(),),
              ],
            ),
          ),
        ),
      ),
      floatingActionButtonLocation:  FloatingActionButtonLocation.centerDocked,
      floatingActionButton:Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0,vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            FloatingActionButton(
              child: const Icon(Icons.share),
              onPressed: (){
                showSnackBar("No Data", context);
              },
            ),
           logoutActionButton(context)
          ],
        ),
      )
    );
  }
}
