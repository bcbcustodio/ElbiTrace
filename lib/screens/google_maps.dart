import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:login/models/google_maps_arguments.dart';
import 'package:login/widgets/appbar_widget.dart';
import 'package:login/widgets/navigation_drawer_widget.dart';
import 'package:uuid/uuid.dart';

class MapSample extends StatefulWidget {
  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  final Completer<GoogleMapController> _controller = Completer();
  GoogleMapController? newGoogleMapController;

  GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  Position? myPosition;

  //if app fails to get user's current location, map is centered at this location (UPLB PhySci Building)
  CameraPosition currentLocation = const CameraPosition(
    target:
        LatLng(14.164582277332801, 121.24200822467662), //UPLB Physci Building
    zoom: 22.5,
  );

  late Future getCurrentPosition;

  List<Circle> infectionSites = [];

  @override
  void initState() {
    //app uses FutureBuilder to query positive close contact records in firebase 
    getCurrentPosition =
        Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
            .then((position) {
      FirebaseFirestore.instance
          .collection('users')
          .where('status', isEqualTo: 'POSITIVE')
          .get()
          .then((users) {
        final userIds = users.docs.map((e) => e.data()['uid'].toString());

        FirebaseFirestore.instance
            .collection('contact_tracing')
            .where('receiverId', whereIn: userIds.toList())
            .get()
            .then((data) {
          setState(() {
            Iterable<GeoPoint> geopoints =
                data.docs.map((e) => e.data()['location']);
            Iterable<Circle> circles = geopoints.map((geopoint) =>
                createCircle(geopoint.latitude, geopoint.longitude));
            infectionSites.addAll(circles.toList());
          });
        });
      });
    });
    super.initState();
    Future.delayed(Duration(microseconds: 200), () {
      final args = ModalRoute.of(context)?.settings.arguments;
      //get user's current position 
      Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
          .then((position) {
        setState(() {
          if (args != null) {
            final GoogleMapsArguments location_args =
                args as GoogleMapsArguments;
            currentLocation = CameraPosition(
                target: LatLng(location_args.pass_latitude!,
                    location_args.pass_longitude!),
                zoom: 18);
          } else {
            currentLocation = CameraPosition(
                target: LatLng(position.latitude, position.longitude),
                zoom: 18);
          }
        });
      });
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final pageName = ModalRoute.of(context)?.settings.name;
    //build page, waits for firebase query to finish before building page
    return Scaffold(
        drawer: NavigationDrawerWidget(pageName: pageName ?? ''),
        appBar: buildAppBar(context, 'Profile Page'),
        body: FutureBuilder(
          future: getCurrentPosition,
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return Center(child: CircularProgressIndicator());
              default:
                return buildMap();
            }
          },
        ));
  }

  //returns google map widget in the page with circles for the positive close contact records
  Widget buildMap() {
    Set<Circle> myCircles = Set.from(infectionSites);
    return GoogleMap(
      mapType: MapType.normal,
      initialCameraPosition: currentLocation,
      onMapCreated: (GoogleMapController controller) {
        _controller.complete(controller);
        newGoogleMapController = controller;
      },
      circles: myCircles,
    );
  }

  Circle createCircle(double latitude, double longitude) {
    String randomUid = const Uuid().v4();
    return Circle(
      strokeColor: Colors.red,
      strokeWidth: 1,
      circleId: CircleId(randomUid),
      center: LatLng(latitude, longitude),
      radius: 4,
      fillColor: Color.fromARGB(255, 236, 181, 181),
    );
  }
}
