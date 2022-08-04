import 'package:cloud_firestore/cloud_firestore.dart';
//firebase model for user accounts
class UserModel {
  String? uid;
  String? email;
  String? photoUrl;
  String? displayName;
  String? status;
  bool? checkedPositive;
  Timestamp? checkedPositiveTime;

  UserModel(
      {this.uid, this.email, this.photoUrl, this.displayName, this.status, this.checkedPositive, this.checkedPositiveTime});

  //receiving data from the server
  factory UserModel.fromMap(map) {
    return UserModel(
        uid: map['uid'],
        email: map['email'],
        photoUrl: map['photoUrl'],
        displayName: map['displayName'],
        status: map['status'],
        checkedPositive: map['checkedPositive'],
        checkedPositiveTime: map['checkedPositiveTime']);
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'photoUrl': photoUrl,
      'displayName': displayName,
      'status': status,
      'checkedPositive': checkedPositive,
      'checkedPositiveTime': checkedPositiveTime
    };
  }
}
