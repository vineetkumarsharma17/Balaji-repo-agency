import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import '../Screens/widgets/widget_build_functions.dart';
import '../component/alert_box.dart';
import '../component/snack_bar.dart';
import '../firebase_services.dart';
import '../permission.dart';
import 'package:path/path.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';

import '../component/drawer.dart';
import '../constant.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class SearchHistoryScreen extends StatefulWidget {
  const SearchHistoryScreen({Key? key}) : super(key: key);

  @override
  State<SearchHistoryScreen> createState() => _SearchHistoryScreenState();
}

class _SearchHistoryScreenState extends State<SearchHistoryScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  CollectionReference searchData =
      FirebaseFirestore.instance.collection('searchData');
  DateFormat dateFormat = DateFormat("dd-MM-yyyy hh:mm");
  TextStyle keyTextStyle = const TextStyle(fontWeight: FontWeight.bold);
  List<QueryDocumentSnapshot> searchList = [];
  bool loading = false;

  exportToExcel(context) async {
    try {
      PermissionStatus status = await Permission.storage.request();
      log(status.toString());
      var excel = Excel.createExcel();
      Sheet sheetObject = excel[await excel.getDefaultSheet()];
      sheetObject
          .cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: 0))
          .value = "Registration_No";
      sheetObject
          .cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: 0))
          .value = "DateTime";
      sheetObject
          .cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: 0))
          .value = "User Mobile";
      sheetObject
          .cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: 0))
          .value = "Location";
      for (int i = 0; i < searchList.length; i++) {
        Map data = searchList[i].data() as Map;
        Timestamp timestamp = data["dateTime"];
        DateTime dt = timestamp.toDate();
        sheetObject
            .cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: i + 1))
            .value = data["rc"] ?? "NULL";
        sheetObject
            .cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: i + 1))
            .value = dt.toString();
        sheetObject
            .cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: i + 1))
            .value = data["user"] ?? "NULL";
        sheetObject
            .cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: i + 1))
            .value = data["location"] ?? "NULL";
        //i+1 means when the loop iterates every time it will write values in new row, e.g A1, A2, ...
        // cell.value = data["rc"]; // Insert value to selected cell;
        // cell.value = dt.toString(); // Insert value to selected cell;
        // cell.value = dt.toString(); // Insert value to selected cell;
      }
      const folderName = "Documents";
      final dir = Directory("storage/emulated/0/$folderName");
      if (status.isGranted && (await dir.exists())) {
        String filePath = dir.path;
        excel.encode().then((onValue) {
          File file =
              File(join("$filePath/searchHistory${DateTime.now()}.xlsx"))
                ..createSync(recursive: true)
                ..writeAsBytesSync(onValue);
          OpenFile.open(file.path);
        });
      } else if (status.isPermanentlyDenied) {
        showMyDialog(
            "Permission",
            "Please allow storage setting to save pdf.",
            context,
            "Open Setting",
            () async {
              await openAppSettings();
            },
            "Cancel",
            () {
              Navigator.pop(context);
            },
            true);
      } else {
        if (await requestPermission(Permission.storage)) {
          if (await dir.exists()) {
            String filePath = dir.path;
            excel.encode().then((onValue) {
              File file = File(join("$filePath/PE${DateTime.now()}.xlsx"))
                ..createSync(recursive: true)
                ..writeAsBytesSync(onValue);
              OpenFile.open(file.path);
            });
          } else {
            final folder = await dir.create();
            if (folder != null) {
              String filePath = dir.path;
              excel.encode().then((onValue) {
                File file = File(join("$filePath/PE${DateTime.now()}.xlsx"))
                  ..createSync(recursive: true)
                  ..writeAsBytesSync(onValue);
                OpenFile.open(file.path);
              });
            }
          }
        }

        log("not exist");
      }
    } catch (e) {
      showSnackBar(e.toString(), context);
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      // drawer: MyDrawer(),
      appBar: buildAppBar(context),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          GestureDetector(
            onTap: () {
              exportToExcel(context);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              margin: const EdgeInsets.symmetric(vertical: 20),
              decoration: BoxDecoration(
                  color: primaryColor,
                  border: Border.all(color: primaryColor),
                  borderRadius: BorderRadius.circular(200)),
              child: const Text(
                "Export to Excel",
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
      body: StreamBuilder(
        stream: searchData.orderBy("dateTime", descending: true).snapshots(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          //  log(snapshot.toString());
          if (!snapshot.hasData) {
            return const Padding(
              padding: EdgeInsets.all(80.0),
              child: Center(
                  child: SpinKitWanderingCubes(
                color: Colors.green,
                size: 50.0,
              )),
            );
          } else {
            searchList = snapshot.data.docs;
            if (searchList.isNotEmpty) {
              return ListView(
                children: [
                  ListView.builder(
                      shrinkWrap: true,
                      physics: const ScrollPhysics(),
                      itemCount: searchList.length,
                      itemBuilder: ((context, index) {
                        Map data = searchList[index].data() as Map;
                        Timestamp timestamp = data["dateTime"];
                        DateTime dt = timestamp.toDate();

                        if (dt
                            .add(const Duration(hours: 30))
                            .isBefore(DateTime.now())) {
                          FirebaseServices().deleteFireStoreData(
                              searchData, searchList[index].id, context);
                        }
                        String dateTime = dateFormat.format(dt);

                        // log(data.toString());
                        return Slidable(
                          startActionPane: ActionPane(
                            // A motion is a widget used to control how the pane animates.
                            motion: const ScrollMotion(),

                            // All actions are defined in the children parameter.
                            children: [
                              // A SlidableAction can have an icon and/or a label.
                              SlidableAction(
                                onPressed: (context) {
                                  FirebaseServices().deleteFireStoreData(
                                      searchData,
                                      searchList[index].id,
                                      context);
                                },
                                backgroundColor: const Color(0xFFFE4A49),
                                foregroundColor: Colors.white,
                                icon: Icons.delete,
                                label: 'Delete',
                              ),
                            ],
                          ),
                          endActionPane: ActionPane(
                            motion: const ScrollMotion(),
                            children: [
                              SlidableAction(
                                onPressed: (context) {
                                  FirebaseServices().deleteFireStoreData(
                                      searchData,
                                      searchList[index].id,
                                      context);
                                },
                                backgroundColor: const Color(0xFFFE4A49),
                                foregroundColor: Colors.white,
                                icon: Icons.delete,
                                label: 'Delete',
                              ),
                            ],
                          ),
                          child: Card(
                              child: ListTile(
                            onTap: (() {}),
                            title: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                          child: Text(
                                        "Registration No :",
                                        style: keyTextStyle,
                                      )),
                                      Text(data["rc"] ?? "Not Found"),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                          child: Text(
                                        "User :",
                                        style: keyTextStyle,
                                      )),
                                      Text(data["user"] ?? "Not Found"),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        flex: 3,
                                        child: Text(
                                          "Location :",
                                          style: keyTextStyle,
                                        ),
                                      ),
                                      Expanded(
                                          flex: 7,
                                          child: Text(
                                            data["location"] ?? "Not Found",
                                            textAlign: TextAlign.right,
                                          )),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                          child: Text(
                                        "Date :",
                                        style: keyTextStyle,
                                      )),
                                      Text(dateTime.toString()),
                                    ],
                                  ),
                                ]),
                          )),
                        );
                      })),
                  const SizedBox(
                    height: 100,
                  )
                ],
              );
            } else {
              return const Center(
                child: const Text("No Data Searched in Last 5 Days."),
              );
            }
          }
        },
      ),
    );
  }
}
