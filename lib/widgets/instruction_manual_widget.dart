import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/global_variables.dart' as globals;

//Page for summarized information of ElbiTrace
class InstructionManualWidget extends StatelessWidget {
  const InstructionManualWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    setLoginPreference();
    final mediaQueryData = MediaQuery.of(context);
    final screenWidth = mediaQueryData.size.width;
    final screenHeight = mediaQueryData.size.height;

    TextStyle title_header =
        TextStyle(fontWeight: FontWeight.bold, fontSize: 20);

    return Column(
      children: <Widget>[
        Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "What is ElbiTrace?",
              style: title_header,
            )),
        SizedBox(height: screenHeight / 50),
        Align(
            alignment: Alignment.centerLeft,
            child: RichText(
              textAlign: TextAlign.justify,
              text: const TextSpan(
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.black,
                  wordSpacing: 1.5,
                ),
                children: <TextSpan>[
                  TextSpan(
                      text: "ElbiTrace",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(text: " is a "),
                  TextSpan(
                      text: "Contact Tracing Application ",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(text: "developed using "),
                  TextSpan(
                      text: "Flutter ",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(text: "and utilizing other technologies such as "),
                  TextSpan(
                      text: "Bluetooth Low Energy ",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(
                      text:
                          "to record and monitor their users' COVID-19 status "),
                ],
              ),
            )),
        SizedBox(height: screenHeight / 16),
        Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "How does it work?",
              style: title_header,
            )),
        SizedBox(height: screenHeight / 50),
        Align(
            alignment: Alignment.centerLeft,
            child: RichText(
              textAlign: TextAlign.justify,
              text: const TextSpan(
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.black,
                  wordSpacing: 1.5,
                ),
                children: <TextSpan>[
                  TextSpan(
                      text:
                          "ElbiTrace uses Wifi and Bluetooth Low Energy to advertise and detect users of the application."),
                  TextSpan(
                      text:
                          "\nthe app will monitor all close contacts among users. "),
                  TextSpan(
                      text: "Close Contacts ",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(
                      text:
                          "are counted when two(2) users are within 6 feet of each other for at least 15 minutes. The application records all encounters with another user every 15 minutes"),
                ],
              ),
            )),
        SizedBox(height: screenHeight / 16),
        Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "How do you use ElbiTrace?",
              style: title_header,
            )),
        SizedBox(height: screenHeight / 50),
        Align(
            alignment: Alignment.centerLeft,
            child: RichText(
              textAlign: TextAlign.justify,
              text: const TextSpan(
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.black,
                  wordSpacing: 1.5,
                ),
                children: <TextSpan>[
                  TextSpan(
                      text: "Step 1:",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(
                      text: "OPEN the APP",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(
                      text:
                          " - the contact tracing service will automatically be started when you enter the application, but you ned to be logged in."),
                  TextSpan(
                      text:
                          "\nYou will be referred to the Temporary Treatment and Monitoring Facility (TTMF) or hospital (if needed)"),
                ],
              ),
            )),
        SizedBox(height: screenHeight / 50),
        Align(
            alignment: Alignment.centerLeft,
            child: RichText(
              textAlign: TextAlign.justify,
              text: const TextSpan(
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.black,
                  wordSpacing: 1.5,
                ),
                children: <TextSpan>[
                  TextSpan(
                      text: "Step 2:",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(
                      text: " THAT'S IT!",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(
                      text:
                          " - just keep the application running in the background and let it do all the work for you."),
                ],
              ),
            )),
        SizedBox(height: screenHeight / 16),
        Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "TAKE NOTE: ",
              style: title_header,
            )),
        SizedBox(height: screenHeight / 50),
        Align(
            alignment: Alignment.centerLeft,
            child: RichText(
              textAlign: TextAlign.justify,
              text: const TextSpan(
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.black,
                  wordSpacing: 1.5,
                ),
                children: <TextSpan>[
                  TextSpan(
                      text: ">", style: TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(text: " Check your "),
                  TextSpan(
                      text: "Contact Tracing History ",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(
                      text:
                          "to update your status. The application checks all your records to see if you have been in contact with any COVID-positive users. "),
                  TextSpan(
                      text: "\n> ",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(text: "You would need "),
                  TextSpan(
                      text: "Mobile data/Wifi ",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(
                      text:
                          "to access the virus heatmap and check the statuses of your contact Tracing History."),
                  TextSpan(
                      text: "\n> ",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(
                      text: "The Contact Tracing service ",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(
                      text:
                          "is still available without WiFi/Mobile Data access, but the app needs to contact the database to fetch all current data with other users. "),
                ],
              ),
            )),
        SizedBox(height: screenHeight / 40),
        Center(
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    shape: StadiumBorder(),
                    onPrimary: Colors.white,
                    padding:
                        EdgeInsets.symmetric(vertical: 10, horizontal: 20)),
                onPressed: () async {
                  Navigator.of(context).pushNamed("Home");
                },
                child: Text(
                  'Back to Home',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ))),
      ],
    );
  }

  void setLoginPreference() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isFirstLogin', false);
    globals.isFirstLogin = false;
  }
}
