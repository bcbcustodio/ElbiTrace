import 'package:flutter/cupertino.dart';

class BuildCircle extends StatelessWidget {
  final Color color;
  final double all;
  final Widget child;

  const BuildCircle({Key? key,required this.color, required this.all, required this.child }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Container(
        padding: EdgeInsets.all(all),
        color: color,
        child: child,
      ),
    );
  }
}
