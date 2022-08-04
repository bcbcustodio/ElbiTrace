import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:login/models/user_model.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegistrationScreen extends StatefulWidget {
  RegistrationScreen({Key? key}) : super(key: key);

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  //form key
  final formKey = GlobalKey<FormState>();

  final _auth = FirebaseAuth.instance;

  final displayNameEditingController = TextEditingController();
  final emailEditingController = TextEditingController();
  final passwordEditingController = TextEditingController();
  final confirmPasswordEditingController = TextEditingController();

  File? file;
  @override
  Widget build(BuildContext context) {
    bool signUpButtonPressed = false;
    final fileName = file != null ? basename(file!.path) : 'No File Selected';

    final displayNameField = TextFormField(
      autofocus: false,
      controller: displayNameEditingController,
      keyboardType: TextInputType.name,
      validator: (value) {
        RegExp regex = RegExp(r'^.{3,}$');
        if (value!.isEmpty) {
          return ("Last Name cannot be empty");
        }
        if (!regex.hasMatch(value)) {
          return ("Enter Valid Name (Min. 3 Characters)");
        }
        return null;
      },
      onSaved: (value) {
        displayNameEditingController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          prefixIcon: Icon(Icons.account_circle),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: 'Display Name',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
    );

    final emailField = TextFormField(
      autofocus: false,
      controller: emailEditingController,
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value!.isEmpty) {
          return ("Please enter your email");
        }
        //regex for email validation
        if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]").hasMatch(value)) {
          return ("Please Enter a valid email");
        }
        return null;
      },
      onSaved: (value) {
        emailEditingController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          prefixIcon: Icon(Icons.mail),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: 'Email',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
    );

    final passwordField = TextFormField(
      autofocus: false,
      controller: passwordEditingController,
      obscureText: true,
      validator: (value) {
        RegExp regex = RegExp(r'^.{6,}$');
        if (value!.isEmpty) {
          return ("Password is required for login");
        }
        if (!regex.hasMatch(value)) {
          return ("Enter Valid Password(Min. 6 Characters)");
        }
      },
      onSaved: (value) {
        passwordEditingController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          prefixIcon: Icon(Icons.vpn_key),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: 'Password',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
    );

    final confirmPasswordField = TextFormField(
      autofocus: false,
      controller: confirmPasswordEditingController,
      obscureText: true,
      validator: (value) {
        if (confirmPasswordEditingController.text !=
            passwordEditingController.text) {
          return ("Passwords don't match");
        }
        return null;
      },
      onSaved: (value) {
        confirmPasswordEditingController.text = value!;
      },
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
          prefixIcon: Icon(Icons.vpn_key),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: 'Confirm Password',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
    );

    final addImageButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: Theme.of(context).colorScheme.primary,
      child: MaterialButton(
        onPressed: () {
          selectFile();
        },
        child: Text(
          'Add User Image',
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 14, color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
    final signUpButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: Theme.of(context).colorScheme.primary,
      child: MaterialButton(
        padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        minWidth: MediaQuery.of(context).size.width,
        onPressed: () {
          setState(() {
            signUpButtonPressed = true;
          });
          signup(context, emailEditingController.text,
              passwordEditingController.text);
        },
        child: Text(
          'Sign Up',
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back,
                color: Theme.of(context).colorScheme.primary),
            onPressed: () {
              Navigator.of(context).pushReplacementNamed("Home");
            },
          )),
      body: Center(
          child: SingleChildScrollView(
        child: Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(36.0),
              child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      if (signUpButtonPressed) ...[
                        Text(
                          'Creating your Account...',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 24),
                        ),
                        CircularProgressIndicator()
                      ] else ...[
                        SizedBox(
                          height: 200,
                          child: Image.asset('assets/logo.png',
                              fit: BoxFit.contain),
                        ),
                        SizedBox(height: 25),
                        displayNameField,
                        SizedBox(height: 15),
                        emailField,
                        SizedBox(height: 15),
                        passwordField,
                        SizedBox(height: 15),
                        confirmPasswordField,
                        SizedBox(height: 15),
                        Row(
                          children: [
                            addImageButton,
                            SizedBox(width: 15),
                            Flexible(
                                child: Text(
                              fileName,
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w500),
                            ))
                          ],
                        ),
                        // ButtonWidget(
                        //     text: 'upload',
                        //     onClicked: () {
                        //       uploadFile();
                        //     }),
                        SizedBox(height: 15),
                        signUpButton,
                        SizedBox(height: 25),
                      ]
                    ],
                  )),
            )),
      )),
    );
  }

  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: false);

    if (result == null) return;
    final path = result.files.single.path;

    setState(() {
      file = File(path!);
    });
  }

  void signup(BuildContext context, String email, String password) async {
    String trim_email = email.replaceAll(' ', '');
    if (formKey.currentState!.validate()) {
      await _auth
          .createUserWithEmailAndPassword(email: trim_email, password: password)
          .then((value) => {postDetailsToFirestore(context)})
          .catchError((e) {
        Fluttertoast.showToast(msg: e!.message);
      });
    }
  }

  void postDetailsToFirestore(BuildContext context) async {
    //Calling firestore
    //calling User model
    //sending values
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

    User? user = _auth.currentUser;

    UserModel userModel = UserModel();

    DateTime now = DateTime.now();
    Timestamp time = Timestamp.fromDate(now);

    String? urlDownload;

    //writing all the values
    if (file != null) {
      final fileName = basename(file!.path);
      final destination = 'files/$fileName';
      try {
        final ref = FirebaseStorage.instance.ref(destination);
        UploadTask? task = ref.putFile(file!);

        if (task != null) {
          final snapshot = await task.whenComplete(() {});
          urlDownload = await snapshot.ref.getDownloadURL();
        }
      } on FirebaseException catch (e) {
        print(e.toString());
      }
    }

    userModel.displayName = displayNameEditingController.text;
    userModel.email = user!.email;
    userModel.uid = user.uid;
    userModel.photoUrl = urlDownload;
    userModel.status = 'NEGATIVE';
    userModel.checkedPositive = false;
    userModel.checkedPositiveTime = time;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('uid', user.uid);
    await firebaseFirestore
        .collection("users")
        .doc(user.uid)
        .set(userModel.toMap())
        .then((value) => {
              Navigator.of(context)
                  .pushNamedAndRemoveUntil("Home", (route) => false)
            });
  }
}
