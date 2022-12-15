import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geolocator/geolocator.dart';
import 'package:share_plus/share_plus.dart';
import '../Screens/widgets/widget_build_functions.dart';
import '../component/drawer.dart';
import '../firebase_services.dart';
import '../httpservices.dart';
import '../local_storage_services.dart';
import 'package:geocoding/geocoding.dart';
import '../component/share_to_whatsapp.dart';
import '../constant.dart';

class DetailScreen extends StatefulWidget {
  final registration_no;
  final chasiss_no;

  const DetailScreen(
      {Key? key, required this.registration_no, required this.chasiss_no})
      : super(key: key);

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  Map data = {};
  double width = 0;
  bool loading = true;
  CollectionReference searchData =
      FirebaseFirestore.instance.collection('searchData');
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    searchDetail();
  }

  searchDetail() async {
    try {
      await HttpService.getDetail(context, widget.registration_no)
          .then((value) async {
        setState(() {
          loading = false;
          data = value;
        });
        Position position = await Geolocator.getCurrentPosition();
        await placemarkFromCoordinates(position.latitude, position.longitude)
            .then((placemarks) {
          String? name = placemarks.first.name;
          String? sublocality = placemarks.first.subLocality;
          String? locality = placemarks.first.locality;
          String? postalCode = placemarks.first.postalCode;
          String? state = placemarks.first.administrativeArea;
          String address = '';
          if (name != null) {
            address += name + ",";
          }
          if (sublocality != null) {
            address += sublocality + ",";
          }
          if (locality != null) {
            address += locality + ",";
          }
          if (postalCode != null) {
            address += postalCode + ",";
          }
          if (state != null) {
            address += state + "";
          }
          log("address:" + address);
          Map<String, dynamic> prm = {
            "rc": widget.registration_no,
            "dateTime": Timestamp.now(),
            "user": LocalStorage.getName,
            "location": address
          };
          if (LocalStorage.getRole == 'user')
            FirebaseServices().addFireStoreData(searchData, prm, context);
        });
      });
    } catch (e) {
      setState(() {
        loading = false;
      });
      log("Error:" + e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width - 40;
    return Scaffold(
      appBar: buildAppBar(context),
      // drawer: MyDrawer(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: primaryColor,
                      offset: const Offset(0.0, 0.0), //(x,y)
                      blurRadius: 12.0,
                    ),
                  ],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    width: .5,
                    color: primaryColor,
                  ),
                ),
                //height: 500,
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 30),
                padding: EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    buildRow("Name", data["Name"] ?? "NULL"),
                    buildRow("Father Name", data["Father"] ?? "NULL"),
                    buildRow("Address", data["Address"] ?? "NULL"),
                    buildRow("Registration No", widget.registration_no),
                    buildRow("Loan No", data["Loan_No"] ?? "NULL"),
                    buildRow("Asset", data["Asset"] ?? "NULL"),
                    buildRow("Engine No", data["Engine_No"] ?? "NULL"),
                    buildRow("Chasiss No", widget.chasiss_no ?? "Null"),
                    buildRow("Bucket", data["Bucket"] ?? "NULL"),
                    buildRow("EMI Ammount", data["EMI_Ammount"] ?? "NULL"),
                    buildRow("Total Pos", data["Total_Pos"] ?? "NULL"),
                    buildRow("Total Penalty", data["Total_Penalty"] ?? "NULL"),
                    buildRow("Company Name", data["Company"] ?? "NULL"),
                    buildRow("Agency Name", data["Agency_Name"] ?? "NULL"),
                  ],
                )),
          ),
          !loading
              ? buildButton("Share", () {
                  String msg = "$companyName";
                  data.forEach(((key, value) {
                    if (key != "id") msg += "\n$key :$value";
                  }));
                  log(msg);
                  Share.share(msg);
                  // opentowhatsapp(msg, context);
                })
              : const Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Center(
                      child: SpinKitCircle(
                    color: Colors.green,
                    size: 50.0,
                  )),
                ),
        ],
      ),
    );
  }

  buildRow(String txt1, String txt2) {
    return Row(
      children: [
        SizedBox(
          width: width * .3,
          child: Text(txt1),
        ),
        SizedBox(
          width: width * .1,
          child: Text(":"),
        ),
        SizedBox(
          width: width * .5,
          child: Text(txt2),
        ),
      ],
    );
  }
}
