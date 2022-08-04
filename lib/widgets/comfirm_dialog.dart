import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:login/models/user_model.dart';

//dialog box for confirming new user status
Future ConfirmStatus(BuildContext context, String status, UserModel user) {
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Confirm"),
          content:
              Text('Are you sure you want to update your COVID-19 status?'),
          actions: [
            TextButton(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("Confirm"),
              onPressed: () async {
                FirebaseFirestore firebaseFirestore =
                    FirebaseFirestore.instance;

                UserModel updatedUser = UserModel();

                DateTime now = DateTime.now();
                Timestamp time = Timestamp.fromDate(now);
                updatedUser.email = user.email;
                updatedUser.uid = user.uid;
                updatedUser.displayName = user.displayName;
                updatedUser.status = status;
                updatedUser.checkedPositive = user.checkedPositive;
                updatedUser.checkedPositiveTime = user.checkedPositiveTime;
                if (status == 'POSITIVE') {
                  updatedUser.checkedPositive = true;
                  updatedUser.checkedPositiveTime = time;
                } else if (user.status == 'POSITIVE' && status == 'NEGATIVE') {
                  updatedUser.checkedPositive = false;
                }
                try {
                  await firebaseFirestore
                      .collection('users')
                      .doc(user.uid)
                      .update(updatedUser.toMap());
                } catch (e) {
                  print(e.toString());
                }

                Navigator.of(context).pop(status);
              },
            )
          ],
        );
      });
}
