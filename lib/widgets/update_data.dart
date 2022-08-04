import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:login/models/user_model.dart';
import 'package:login/widgets/button_widget.dart';
import 'package:login/widgets/comfirm_dialog.dart';
import 'package:login/widgets/get_color.dart';

//update user status 
class UpdateUserData extends StatefulWidget {
  final UserModel currentUser;
  User? user;
  final bool updateButtonPressed;
  UpdateUserData(
      {Key? key,
      required this.currentUser,
      this.user,
      required this.updateButtonPressed})
      : super(key: key);

  @override
  State<UpdateUserData> createState() => _UpdateUserDataState();
}

class _UpdateUserDataState extends State<UpdateUserData> {
  bool? updateButtonPressed;
  String? status;
  @override
  void initState() {
    updateButtonPressed = widget.updateButtonPressed;

    UserModel currentUser = widget.currentUser;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    UserModel currentUser = widget.currentUser;

    final _mediaQueryData = MediaQuery.of(context);
    final screenWidth = _mediaQueryData.size.width;
    final screenHeight = _mediaQueryData.size.height;

    return Column(
      children: [
        if (updateButtonPressed!) ...[
          DropdownButton<String>(
              value: status ?? currentUser.status ?? 'NEGATIVE',
              icon: const Icon(Icons.arrow_downward),
              elevation: 16,
              style: TextStyle(color: Theme.of(context).colorScheme.primary),
              underline: Container(
                height: 2,
                color: Theme.of(context).colorScheme.primary,
              ),
              onChanged: (String? newValue) {
                setState(() {
                  status = newValue!;
                });
              },
              items: <String>['NEGATIVE', 'POSITIVE']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value,
                    style: TextStyle(
                        color: value == 'NEGATIVE'
                            ? getColor('NEGATIVE')
                            : getColor('POSITIVE')),
                  ),
                );
              }).toList()),
          SizedBox(height: screenHeight / 400),
          Center(
              child: ButtonWidget(
                  text: 'Confirm',
                  onClicked: () async {
                    setState(() {
                      if (status == null) {
                        status = currentUser.status;
                      }
                    });
                    //if user presses confirm, a dialog box would occur to double check the user action
                    await ConfirmStatus(context, status!, currentUser);
                    setState(() {
                      updateButtonPressed = !updateButtonPressed!;
                    });
                  })),
        ] else ...[
          Text(
            status ?? currentUser.status ?? '',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
                color: getColor(status ?? currentUser.status ?? '')),
          ),
          SizedBox(height: screenHeight / 400),
          Center(
              child: ButtonWidget(
                  text: 'Update Status',
                  onClicked: () {
                    final DateTime now = DateTime.now();
                    final DateTime time_marker =
                        currentUser.checkedPositiveTime!.toDate();
                    final time_difference = now.difference(time_marker).inDays;
                    if (currentUser.checkedPositive! && time_difference < 14) {
                      showAlert(context);
                    } else {
                      setState(() {
                        if (currentUser.status == 'EXPOSED')
                          status = 'NEGATIVE';
                        updateButtonPressed = !updateButtonPressed!;
                      });
                    }
                  })),
        ]
      ],
    );
  }

  void showAlert(BuildContext context) {
    final _mediaQueryData = MediaQuery.of(context);
    final screenWidth = _mediaQueryData.size.width;
    final screenHeight = _mediaQueryData.size.height;
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("You cannot update your status"),
            content: const Text(
                'Updating your is not allowed at the moment. Please wait at least 14 days to change your COVID-19 status. Thank you!'),
            actions: [
              TextButton(
                child: Text("Okay"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }
}
