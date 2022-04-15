import 'dart:developer';

import 'package:balaji_repo_agency/component/alertdilog.dart';
import 'package:balaji_repo_agency/component/drawer.dart';
import 'package:flutter/material.dart';

class VehicleDetailScreen extends StatelessWidget {
  String Vehicle;
  VehicleDetailScreen(this.Vehicle);
  @override
  Widget build(BuildContext context) {
    log(Vehicle);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Bala ji Repo Agency"),
        actions: [
          Padding(
              padding: const EdgeInsets.only(right: 15.0),
              child: IconButton(
                  onPressed: () => showExitDialog(
                      "Alert!", "Are you sure to exit?", context),
                  icon: const Icon(Icons.logout))),
        ],
        // automaticallyImplyLeading: false,
      ),
      drawer: MyDrawer(),
    );
  }
}
