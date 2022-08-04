import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:login/models/google_maps_arguments.dart';

//card for each contact tracing record in the Contact Tracing History
class ProfileCard extends StatelessWidget {
  ProfileCard(
      {this.imagePath,
      this.email,
      required this.infection,
      this.contactUid,
      this.contactTime,
      this.contactLocation,
      required this.background});

  final String? imagePath;
  final String? email;
  final String infection;
  final String? contactUid;
  final DateTime? contactTime;
  final GeoPoint? contactLocation;
  final Color background;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 7.5),
      color: Colors.white,
      elevation: 5.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.white,
          backgroundImage: AssetImage(imagePath!),
        ),
        trailing: Text(infection, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: background),),
        title: Text(
          (DateFormat.jm().format(contactTime!)),
          style: TextStyle(
            color: Colors.blue[700],
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(DateFormat.yMMMMd().format(contactTime!)),
        onTap: () {
          Navigator.of(context).pushNamed("Map", arguments: GoogleMapsArguments(contactLocation!.latitude, contactLocation!.longitude));
        },
      ),
    );
  }
}
