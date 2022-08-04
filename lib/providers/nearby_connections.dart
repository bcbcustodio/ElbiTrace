import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:login/models/contact_tracing_model.dart';
import 'package:nearby_connections/nearby_connections.dart';
import 'package:uuid/uuid.dart';

List<String> inProgressIds = [];
final Strategy strategy = Strategy.P2P_STAR;
Map<String, String> endpointMap = Map();
void startNearbyDetection(User user) async {
  final deviceName = user.uid;
  //check if the application has enabled all necessary services and permissions
  bool locationPermission = await Nearby().checkLocationPermission();
  bool bluetooth = await Nearby().checkBluetoothPermission();
  bool checkLocation = await Nearby().checkLocationEnabled();
  try {
    if (!locationPermission) {
      await Nearby().askLocationPermission();
    }
    if (!bluetooth) {
      Nearby().askBluetoothPermission();
    }
    if (!locationPermission) {
      await Nearby().enableLocationServices();
    }
    //if all services and permissions are enabled, application starts advertising the device and starts discovering other devices 
    if (locationPermission && bluetooth && checkLocation) {
      bool a = await Nearby().startAdvertising(
        deviceName,
        strategy,
        onConnectionInitiated: (String id, ConnectionInfo info) {
          print('id: ' + id.toString());
          print('connection Info: ' + info.endpointName);
        },
        onConnectionResult: (id, status) {
          print(status);
        },
        onDisconnected: (id) {
          print('Disconnected from device');
        },
      );
      print("ADVERTISING: " + a.toString());

      bool b = await Nearby().startDiscovery(
        deviceName,
        strategy,
        onEndpointFound: (id, name, serviceId) {

          print('id: ' + id.toString());
          print('name: ' + name.toString());
          print('serviceId: ' + serviceId.toString());
          endpointMap[id] = name;
          //if device finds another device, run validation function
          validateDevice(name, user);
        },
        onEndpointLost: (id) {
          endpointMap.remove(id);
          print('lost connection to device' + id!);
        },
      );
      print("DISCOVERING: " + b.toString());
    } else {
      startNearbyDetection(user);
    }
  } catch (exception) {
    print(exception);
  }
}

//if device is not included in connected devices, starts internal timer for close contact (15 minutes - 900 seconds)
void validateDevice(String deviceName, User user) async {
  if (!inProgressIds.contains(deviceName)) {
    inProgressIds.add(deviceName);
  } else {
    return;
  }
  Fluttertoast.showToast(
      msg: 'Device: ' + deviceName + ' Time: ' + DateTime.now().toString());
  await Future.delayed(const Duration(seconds: 900));
  List idList = [];
  endpointMap.forEach((key, value) {
    if (!idList.contains(value)) {
      idList.add(value);
    }
  });
  inProgressIds.remove(deviceName);
  if (idList.contains(deviceName)) {
    Fluttertoast.showToast(
        msg: 'internal timer: device.deviceName, Time: ' +
            DateTime.now().toString());
    if (deviceName != user.uid) {
      //after 15 minutes, if device is still within range, create close contact record and send data to firebase
      SendData(deviceName);
    }
    //start internal timer again
    validateDevice(deviceName, user);
  }
}

//create close contact record document
void SendData(String senderId) async {
  DateTime now = DateTime.now();
  Timestamp time = Timestamp.fromDate(now);

  Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high);

  GeoPoint location = GeoPoint(position.latitude, position.longitude);

  User? user = FirebaseAuth.instance.currentUser;
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  ContactTracingModel contactTracingModel = ContactTracingModel();

  contactTracingModel.location = location;
  contactTracingModel.timestamp = time;
  contactTracingModel.senderId = senderId;
  contactTracingModel.receiverId = user!.uid;
  contactTracingModel.checked = false;

  String randomUid = const Uuid().v1();
  if (senderId != 'Null' && user.uid != 'Null')
    await firebaseFirestore
        .collection("contact_tracing")
        .doc(randomUid)
        .set(contactTracingModel.toMap());
}
