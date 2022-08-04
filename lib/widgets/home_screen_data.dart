// ignore_for_file: deprecated_member_use

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info/device_info.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
// import 'package:flutter_nearby_connections/flutter_nearby_connections.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:login/models/contact_tracing_model.dart';
import 'package:login/models/user_model.dart';
import 'package:login/providers/nearby_connections.dart';
import 'package:login/widgets/appbar_widget.dart';
import 'package:login/widgets/build_circle.dart';
import 'package:login/widgets/button_widget.dart';
import 'package:login/widgets/navigation_drawer_widget.dart';
import 'package:login/widgets/profile_widget.dart';
import 'package:login/widgets/quarantine_guidelines_widget.dart';
import 'package:login/widgets/update_data.dart';
import 'package:nearby_connections/nearby_connections.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_blue/flutter_blue.dart';
import '../models/global_variables.dart' as globals;

class HomeScreenData extends StatefulWidget {
  HomeScreenData({Key? key}) : super(key: key);

  @override
  State<HomeScreenData> createState() => _HomeScreenDataState();
}

class _HomeScreenDataState extends State<HomeScreenData> {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  User? user = FirebaseAuth.instance.currentUser;
  UserModel currentUser = UserModel();

  final Strategy strategy = Strategy.P2P_STAR;
  Map<String, String> endpointMap = Map();

  late Future getData;
  @override
  void initState() {
    if (!globals.isLoggedIn) {
      globals.isLoggedIn = true;

    }
    getData = firebaseFirestore
        .collection('users')
        .doc(user!.uid)
        .get()
        .then(((value) => {
              if (mounted)
                {
                  setState(() {
                    currentUser = UserModel.fromMap(value.data());
                    Future.delayed(Duration.zero, () => showAlert(context));
                  })
                }
            }));

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pageName = ModalRoute.of(context)?.settings.name;
    return Scaffold(
        drawer: NavigationDrawerWidget(pageName: pageName ?? ''),
        appBar: buildAppBar(context, 'Profile Page'),
        body: FutureBuilder(
          future: getData,
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return Center(child: CircularProgressIndicator());
              default:
                return buildHomeScreenData();
            }
          },
        ));
  }

  Widget buildHomeScreenData() {
    final _mediaQueryData = MediaQuery.of(context);
    final screenWidth = _mediaQueryData.size.width;
    final screenHeight = _mediaQueryData.size.height;
    final color = Theme.of(context).colorScheme.primary;
    const placeholder_image =
        'https://firebasestorage.googleapis.com/v0/b/login-8c8d0.appspot.com/o/files%2Flogo.png?alt=media&token=9681b6c4-dc21-4a15-b409-7f3f2aea4214';

    return ListView(
      physics: BouncingScrollPhysics(),
      children: [
        ProfileWidget(
            imagePath:
                user?.photoURL ?? currentUser.photoUrl ?? placeholder_image,
            onclicked: () async {}),
        SizedBox(height: screenHeight / 40),
        buildUserInfo(),
        SizedBox(height: screenHeight / 40),
        Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  BuildCircle(
                    color: color,
                    all: 12,
                    child: IconButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed("Map");
                      },
                      iconSize: screenHeight / 7,
                      icon: Icon(FontAwesomeIcons.locationPin),
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Virus Heatmap',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ],
              ),
              const SizedBox(width: 40),
              Column(
                children: [
                  BuildCircle(
                    color: color,
                    all: 12,
                    child: IconButton(
                      onPressed: () async {
                        Navigator.of(context).pushNamed("Tracing");
                      },
                      iconSize: screenHeight / 7,
                      icon: Icon(FontAwesomeIcons.shieldVirus),
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Tracing History',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ],
              )
            ],
          ),
        )
      ],
    );
  }

  Widget buildUserInfo() {
    final _mediaQueryData = MediaQuery.of(context);
    final screenWidth = _mediaQueryData.size.width;
    final screenHeight = _mediaQueryData.size.height;

    return Column(
      children: [
        Text(
          currentUser.displayName ?? user!.displayName ?? '',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        SizedBox(height: screenHeight / 200),
        Text(
          currentUser.email ?? user!.email ?? '',
          style: TextStyle(color: Colors.grey),
        ),
        SizedBox(height: screenHeight / 50),
        UpdateUserData(
          currentUser: currentUser,
          updateButtonPressed: false,
        )
      ],
    );
  }

  void showAlert(BuildContext context) {
    final _mediaQueryData = MediaQuery.of(context);
    final screenWidth = _mediaQueryData.size.width;
    final screenHeight = _mediaQueryData.size.height;
    if (currentUser.status == 'EXPOSED' || currentUser.status == 'POSITIVE') {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("QUARANTINE GUIDELINES"),
              content: Container(
                height: screenHeight,
                width: screenWidth,
                child: SingleChildScrollView(child: QuarantineGuidelinesData()),
              ),
              actions: [
                ButtonWidget(
                  text: "I Understand",
                  onClicked: () async {
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          });
    }
  }
}
