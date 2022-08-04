import 'package:flutter/cupertino.dart';

Color getColor(String status) {
    switch (status) {
      case 'NEGATIVE':
        return Color.fromARGB(255, 243, 146, 139); 
      case 'POSITIVE':
        return Color.fromARGB(255, 25, 194, 30);
      case 'EXPOSED':
        return Color.fromARGB(255, 236, 223, 99);
      default:
        return Color.fromARGB(255, 243, 146, 139); 
    }
  }