import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:login/providers/google_sign_in.dart';
import 'package:nearby_connections/nearby_connections.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

//navigation drawer widget in the application 
class NavigationDrawerWidget extends StatelessWidget {
  final String pageName;

  const NavigationDrawerWidget({Key? key, required this.pageName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.
        child: Material(
      color: Colors.blue,
      child: ListView(
        children: <Widget>[
          const SizedBox(height: 48),
          buildMenuItem(
              text: 'Home',
              icon: Icons.home,
              pageRoute: pageName == '/' ? '/' : 'Home',
              onClicked: () => {
                    Navigator.of(context)
                        .pushNamedAndRemoveUntil("Home", (route) => false)
                  }),
          const SizedBox(height: 16),
          buildMenuItem(
              text: 'Google Maps',
              icon: Icons.location_pin,
              pageRoute: 'Map',
              onClicked: () => {
                    if (pageName == 'Tracing' ||
                        pageName == 'Guidelines' ||
                        pageName == 'Manual')
                      {Navigator.of(context).pushReplacementNamed("Map")}
                    else
                      {Navigator.of(context).pushNamed("Map")}
                  }),
          const SizedBox(height: 16),
          buildMenuItem(
              text: 'Contact Tracing',
              icon: FontAwesomeIcons.shieldVirus,
              pageRoute: 'Tracing',
              onClicked: () => {
                    if (pageName == 'Map' ||
                        pageName == 'Guidelines' ||
                        pageName == 'Manual')
                      {Navigator.of(context).pushReplacementNamed("Tracing")}
                    else
                      {Navigator.of(context).pushNamed("Tracing")}
                  }),
          const SizedBox(height: 16),
          buildMenuItem(
              text: 'Quarantine Guidelines',
              icon: FontAwesomeIcons.bookOpen,
              pageRoute: 'Guidelines',
              onClicked: () => {
                    if (pageName == 'Map' ||
                        pageName == 'Tracing' ||
                        pageName == 'Manual')
                      {Navigator.of(context).pushReplacementNamed("Guidelines")}
                    else
                      {Navigator.of(context).pushNamed("Guidelines")}
                  }),
          const SizedBox(height: 16),
          buildMenuItem(
              text: 'What is Elbitrace?',
              icon: FontAwesomeIcons.circleQuestion,
              pageRoute: 'Manual',
              onClicked: () => {
                    if (pageName == 'Map' ||
                        pageName == 'Tracing' ||
                        pageName == 'Guidelines')
                      {Navigator.of(context).pushReplacementNamed("Manual")}
                    else
                      {Navigator.of(context).pushNamed("Manual")}
                  }),
          const SizedBox(height: 24),
          Divider(color: Colors.white70),
          buildMenuItem(
              text: 'Logout',
              icon: Icons.logout,
              pageRoute: 'Logout',
              onClicked: () async {
                try {
                  await Nearby().stopAdvertising();
                  await Nearby().stopDiscovery();
                } catch (e) {
                  print(e);
                }
                final provider =
                    Provider.of<GoogleSignInProvider>(context, listen: false);
                provider.logout(context);
              })
        ],
      ),
    ));
  }

  Widget buildMenuItem(
      {required String text,
      required String pageRoute,
      required IconData icon,
      VoidCallback? onClicked}) {
    final color = Colors.white;
    final hoverColor = Colors.white70;
    return ListTile(
      leading: Icon(
        icon,
        color: color,
      ),
      title: Text(text, style: TextStyle(color: color)),
      hoverColor: hoverColor,
      onTap: pageName != pageRoute ? onClicked : () {},
    );
  }
}
