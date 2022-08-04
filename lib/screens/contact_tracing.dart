import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:login/models/user_model.dart';
import 'package:login/widgets/appbar_widget.dart';
import 'package:login/widgets/navigation_drawer_widget.dart';
import 'package:login/widgets/profile_card.dart';

class ContactTracingScreen extends StatefulWidget {
  const ContactTracingScreen({Key? key}) : super(key: key);

  @override
  _ContactTracingScreenState createState() => _ContactTracingScreenState();
}

class _ContactTracingScreenState extends State<ContactTracingScreen> {
  List<QueryDocumentSnapshot<Map<String, dynamic>>> contactTracingHistory = [];
  List<QueryDocumentSnapshot<Map<String, dynamic>>> filteredData = [];
  List<QueryDocumentSnapshot<Map<String, dynamic>>> filteredData2 = [];
  List<UserModel> users = [];
  Iterable<String> userIds = [];

  UserModel currentUser = UserModel();
  WriteBatch batch = FirebaseFirestore.instance.batch();
  late Future getData;
  @override
  void initState() {
    User? user = FirebaseAuth.instance.currentUser;
    bool update_user_status = false;
    try {
      //get all close contact records concerning the user
      getData = FirebaseFirestore.instance
          .collection("contact_tracing")
          .where('receiverId', isEqualTo: user!.uid)
          .get()
          .then((data) => {
                FirebaseFirestore.instance
                    .collection('users')
                    .doc(user.uid)
                    .get()
                    .then((value) => {
                          if (mounted)
                            {
                              setState(() {
                                currentUser = UserModel.fromMap(value.data());
                              })
                            }
                        }),
                filteredData = data.docs,
                batch = FirebaseFirestore.instance.batch(),

                //checks if each record does not exceed 14 days. If so, record is deleted
                filteredData.where((record) {
                  final DateTime now = DateTime.now();
                  final DateTime record_time = GetDateTime(record['timestamp']);
                  final time_difference = now.difference(record_time).inDays;
                  if (time_difference > 14) {
                    var docRef = FirebaseFirestore.instance
                        .collection('contact_tracing')
                        .doc(record.reference.id);
                    batch.delete(docRef);
                    return false;
                  }
                  return true;
                }),
                setState(() {
                  contactTracingHistory.clear();
                  contactTracingHistory.addAll(filteredData);
                }),
                FirebaseFirestore.instance
                    .collection("contact_tracing")
                    .where('senderId', isEqualTo: user.uid)
                    .get()
                    .then((trackers) => {
                          filteredData2 = trackers.docs,
                          batch = FirebaseFirestore.instance.batch(),
                          filteredData2.where((record) {
                            final DateTime now = DateTime.now();
                            final DateTime record_time =
                                GetDateTime(record['timestamp']);
                            final time_difference =
                                now.difference(record_time).inDays;
                            if (time_difference > 14) {
                              var docRef = FirebaseFirestore.instance
                                  .collection('contact_tracing')
                                  .doc(record.reference.id);
                              batch.delete(docRef);
                              return false;
                            }
                            return true;
                          }),
                          setState(() {
                            contactTracingHistory.addAll(filteredData2);
                          }),
                          if (filteredData.isNotEmpty ||
                              filteredData2.isNotEmpty)
                            {
                              //get userIds and remove duplicates
                              userIds = filteredData
                                      .map((e) =>
                                          e.data()['senderId'].toString())
                                      .toSet()
                                      .toList() +
                                  filteredData2
                                      .map((e) =>
                                          e.data()['receiverId'].toString())
                                      .toSet()
                                      .toList(),
                              FirebaseFirestore.instance
                                  .collection('users')
                                  .where('uid', whereIn: userIds.toList())
                                  .get()
                                  .then((value) {
                                //parse User Data
                                Iterable<UserModel> parsed = value.docs
                                    .map((e) => UserModel.fromMap(e.data()));
                                setState(() {
                                  //update users with all users from query
                                  users.addAll(parsed.toList());
                                });
                                if (parsed
                                    .any((user) => user.status == 'POSITIVE')) {
                                  var positiveUserIds = parsed
                                      .where(
                                          (user) => user.status == 'POSITIVE')
                                      .map((e) => e.uid)
                                      .toList();
                                  var new_batch =
                                      FirebaseFirestore.instance.batch();
                                  const updateBody = {'checked': true};
                                  var count = 1;
                                  filteredData.forEach((record) {
                                    if (record['checked'] == false) {
                                      var docRef = FirebaseFirestore.instance
                                          .collection('contact_tracing')
                                          .doc(record.reference.id);
                                      batch.update(docRef, updateBody);
                                      if (positiveUserIds
                                          .contains(record['senderId'])) {
                                        update_user_status = true;
                                      }
                                    }
                                  });
                                  //if there is a close contact record with a user with a positive status and the user's current status is NEGATIVE,
                                  // user status is updated to EXPOSED
                                  if (currentUser.status == 'NEGATIVE' &&
                                      update_user_status) {
                                    FirebaseFirestore.instance
                                        .collection('users')
                                        .doc(user.uid)
                                        .update({'status': 'EXPOSED'});
                                  }
                                }
                                batch.commit().then((value) {});
                              }),
                            }
                        }),
              });
    } catch (e) {
      print('Error: ' + e.toString());
    }

    super.initState();
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
                  if (snapshot.hasError) {
                    return Center(
                      child: Text(snapshot.error.toString()),
                    );
                  } else {
                    return buildTracingHistory();
                  }
              }
            }));
  }

  Widget buildTracingHistory() {
    //sort records from most recent to least recent
    contactTracingHistory.sort((a, b) {
      var aDate = GetDateTime(a.data()['timestamp']);
      var bDate = GetDateTime(b.data()['timestamp']);
      return -aDate.compareTo(bDate);
    });
    return Column(
      children: <Widget>[
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(
              left: 25.0,
              right: 25.0,
              bottom: 10.0,
              top: 30.0,
            ),
            child: Container(
              height: 100.0,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.blue[500],
                borderRadius: BorderRadius.circular(20.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black,
                    blurRadius: 4.0,
                    spreadRadius: 0.0,
                    offset: Offset(2.0, 2.0), // shadow direction: bottom right
                  )
                ],
              ),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Image(
                      image: AssetImage('assets/logo.png'),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      'Your Contact Traces',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 21.0,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        SizedBox(height: 35),
        Expanded(
          flex: 2,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 25.0),
            child: ListView.builder(
              itemCount: contactTracingHistory.length,
              itemBuilder: (context, index) {
                final record = contactTracingHistory[index];
                var uidChecker;
                if (record['senderId'] == currentUser.uid) {
                  uidChecker = record['receiverId'];
                } else {
                  uidChecker = record['senderId'];
                }
                UserModel user = users
                    .firstWhere((user) => user.uid == uidChecker, orElse: () {
                  return UserModel();
                });
                return ProfileCard(
                  imagePath: 'assets/logo.png',
                  email: user.email,
                  infection: user.status ?? '',
                  contactUid: user.uid,
                  contactTime: GetDateTime(record['timestamp']),
                  contactLocation: record['location'],
                  background: getCardColor(user.status ?? ''),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Color getCardColor(String status) {
    switch (status) {
      case 'NEGATIVE':
        return Color.fromARGB(255, 243, 146, 139);
      case 'POSITIVE':
        return Color.fromARGB(255, 133, 255, 137);
      case 'EXPOSED':
        return Color.fromARGB(255, 236, 223, 99);
      default:
        return Color.fromARGB(255, 243, 146, 139);
    }
  }

  DateTime GetDateTime(Timestamp time) {
    return time.toDate();
  }
}
