import 'package:flutter/material.dart';
import 'package:login/widgets/build_circle.dart';

class ProfileWidget extends StatelessWidget {
  final String imagePath;
  final VoidCallback onclicked;

  const ProfileWidget(
      {Key? key, required this.imagePath, required this.onclicked})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;

    return Center(
      child: Stack(children: [
        buildImage(context),
        Positioned(bottom: 0, right: 4, child: buildEditIcon(context, color))
      ]),
    );
  }

  Widget buildImage(BuildContext context) {
    final image = NetworkImage(imagePath);
    final _mediaQueryData = MediaQuery.of(context);
    final screenWidth = _mediaQueryData.size.width;
    final screenHeight = _mediaQueryData.size.height;
    return ClipOval(
      child: Material(
        color: Colors.transparent,
        child: Ink.image(
          image: image,
          fit: BoxFit.cover,
          height: screenWidth / 2,
          width: screenWidth / 2,
          child: InkWell(onTap: onclicked),
        ),
      ),
    );
  }

  Widget buildEditIcon(BuildContext context, Color color) {
    final _mediaQueryData = MediaQuery.of(context);
    final screenWidth = _mediaQueryData.size.width;
    return BuildCircle(
      color: Colors.white,
      all: 3,
      child: BuildCircle(
        color: color,
        all: 8,
        child: Icon(
          Icons.edit,
          color: Colors.white,
          size: screenWidth / 20,
        ),
      ),
    );
  }
}
