import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:login/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/global_variables.dart' as globals;

class GoogleSignInProvider extends ChangeNotifier {
  final googleSignIn = GoogleSignIn();

  GoogleSignInAccount? _user;

  GoogleSignInAccount get user => _user!;

  Future googleLogin(BuildContext context) async {
    try {
      final googleUser = await googleSignIn.signIn();

      if (googleUser == null) return;
      _user = googleUser;

      final googleAuth = await googleUser.authentication;

      final Credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);

      await FirebaseAuth.instance
          .signInWithCredential(Credential)
          .then((value) => ValidateUser(context))
          .catchError((e) {
        print(e.toString());
      });
    } catch (e) {
      print(e.toString());
    }
  }

  void ValidateUser(BuildContext context) async {
    //Calling firestore
    //calling User model
    //sending values
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

    final _auth = FirebaseAuth.instance;
    User? user = _auth.currentUser;

    UserModel userModel = UserModel();

    DateTime now = DateTime.now();
    Timestamp time = Timestamp.fromDate(now);

    //create user in firebase store if account logged in for the first time
    await FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get()
        .then((value) async {
      globals.cameFromLogin = true;
      if (value.data() == null) {
        userModel.email = user.email;
        userModel.uid = user.uid;
        userModel.displayName = user.displayName;
        userModel.status = 'NEGATIVE';
        userModel.checkedPositive = false;
        userModel.checkedPositiveTime = time;

        await firebaseFirestore
            .collection("users")
            .doc(user.uid)
            .set(userModel.toMap())
            .then((value) async {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('uid', user.uid);
          Navigator.of(context)
              .pushNamedAndRemoveUntil("Home", (route) => false);
          notifyListeners();
        });
        Fluttertoast.showToast(msg: 'Account successfully created!');
      }
    });
  }

  Future logout(BuildContext context) async {
    try {
      await googleSignIn.disconnect();
    } catch (e) {
      print(e.toString());
    }

    final _auth = FirebaseAuth.instance;
    User? user = _auth.currentUser;
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacementNamed("Home");
  }
}
