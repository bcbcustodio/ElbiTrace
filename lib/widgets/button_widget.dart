import 'package:flutter/material.dart';

class ButtonWidget extends StatelessWidget {
  final String text;
  final VoidCallback onClicked;

  const ButtonWidget({Key? key, required this.text, required this.onClicked})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
            shape: StadiumBorder(),
            onPrimary: Colors.white,
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20)),
        onPressed: onClicked,
        child: Text(
          text,
          style: TextStyle(fontWeight: FontWeight.bold),
        ));
  }
}
