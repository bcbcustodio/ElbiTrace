import 'package:flutter/material.dart';
import 'package:login/widgets/appbar_widget.dart';
import 'package:login/widgets/instruction_manual_widget.dart';
import 'package:login/widgets/navigation_drawer_widget.dart';

//page for Elbitrace information
class InstructionManual extends StatefulWidget {
  InstructionManual({Key? key}) : super(key: key);

  @override
  State<InstructionManual> createState() => _InstructionManualState();
}

class _InstructionManualState extends State<InstructionManual> {
  @override
  Widget build(BuildContext context) {
    final pageName = ModalRoute.of(context)?.settings.name;
    final mediaQueryData = MediaQuery.of(context);
    final screenWidth = mediaQueryData.size.width;
    final screenHeight = mediaQueryData.size.height;

    return Scaffold(
        drawer: NavigationDrawerWidget(pageName: pageName ?? ''),
        appBar: buildAppBar(context, 'Profile Page'),
        body: ListView(
          physics: BouncingScrollPhysics(),
          children: [
            ClipOval(
              child: Material(
                color: Colors.transparent,
                child: Ink.image(
                  image: AssetImage('assets/b_logo.jpg'),
                  fit: BoxFit.cover,
                  height: screenWidth / 2,
                  width: screenWidth / 2,
                ),
              ),
            ),
            const Align(
                alignment: Alignment.center,
                child: Text(
                  'ElbiTrace',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
                )),
            SizedBox(height: screenHeight / 200),
            const Align(
                alignment: Alignment.center,
                child: Text(
                  "an SP project Contact Tracing App",
                  style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                )),
            SizedBox(height: screenHeight / 12),
            Container(
              child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth / 20),
                  child: const InstructionManualWidget()),
            )
          ],
        ));
  }
}