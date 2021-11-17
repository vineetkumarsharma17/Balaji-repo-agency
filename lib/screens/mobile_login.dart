import 'package:flutter/material.dart';
class LoginMobile extends StatefulWidget {
  const LoginMobile({Key? key}) : super(key: key);

  @override
  _LoginMobileState createState() => _LoginMobileState();
}
TextEditingController mobile=TextEditingController();
class _LoginMobileState extends State<LoginMobile> {
  @override
  Widget build(BuildContext context) {
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
        child: Column(
          children: [
            Expanded(child: Container(
              alignment: Alignment.centerLeft,
              width: MediaQuery.of(context).size.width,
              // color: Colors.red,
              child: Padding(
                padding: const EdgeInsets.only(left: 68.0),
                child: Text("Welcome!!",style: TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.bold
                ),),
              ),
            )),
            Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(40),
                      topRight:  Radius.circular(40))
              ),
              child: Column(
                children: [
                  Center(
                    heightFactor: 2,
                    child: Text("Sign In",style: TextStyle(
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
                        style: TextStyle(color: Colors.white),
                        controller: mobile,
                        decoration: InputDecoration(
                            icon: Icon(Icons.email_outlined,color: Colors.white,),
                            hintText: "Mobile",
                            hintStyle: TextStyle(
                                color: Colors.white70
                            ),
                            border: InputBorder.none
                        ),
                      ),
                    ),
                  ),
                  ElevatedButton(onPressed: (){
                  //  Navigator.push(context, MaterialPageRoute(builder: (context)=>()));

                  }, child: Text("Sign In",style: TextStyle(
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
          ],
        ),
      ),
    );
  }
}
