import 'package:cloud_firestore/cloud_firestore.dart';
//model for close contact records 
class ContactTracingModel {
  GeoPoint? location;
  Timestamp? timestamp;
  String? senderId;
  String? receiverId;
  bool? checked;
  ContactTracingModel(
      {this.location, this.timestamp, this.senderId, this.receiverId, this.checked});

  //receiving data from the server
  factory ContactTracingModel.fromMap(map) {
    return ContactTracingModel(
        location: map['location'],
        timestamp: map['timestamp'],
        senderId: map['senderId'],
        receiverId: map['receiverId'],
        checked: map['checked'],);
  }

  Map<String, dynamic> toMap() {
    return {
      'location': location,
      'timestamp': timestamp,
      'senderId': senderId,
      'receiverId': receiverId,
      'checked': checked
    };
  }
}
