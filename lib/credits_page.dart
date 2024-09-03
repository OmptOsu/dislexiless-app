import 'package:camera/camera.dart';
import 'package:dislexiless_app/home_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CreditsPage extends StatefulWidget {
  const CreditsPage({super.key, required this.pref, required this.camera});

  final SharedPreferences pref;
  final CameraDescription camera;

  @override
  State<CreditsPage> createState() => _CreditsPageState();
}

class _CreditsPageState extends State<CreditsPage> {
  Widget _buildButtonDesign(String displayText, Color buttonColor,
      IconData icon, void Function() onPress) {
    return OutlinedButton.icon(
      onPressed: onPress,
      style: OutlinedButton.styleFrom(
        shape: const BeveledRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(5))),
        side: BorderSide(width: 1, color: buttonColor),
        backgroundColor: Colors.white,
        elevation: 20,
        shadowColor: Colors.black,
        padding: EdgeInsets.symmetric(
            vertical: MediaQuery.of(context).size.width / 20,
            horizontal: MediaQuery.of(context).size.width / 20),
        //minimumSize: const Size.fromHeight(50)
      ),
      icon: Icon(
        icon,
        color: buttonColor,
        size: MediaQuery.of(context).size.width / 15,
      ),
      label: Text(
        displayText,
        style: TextStyle(
          fontSize: MediaQuery.of(context).size.width / 15,
          color: buttonColor,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(color: Color.fromRGBO(247, 245, 255, 1)),
      child: Padding(
        padding: EdgeInsets.fromLTRB(
            (MediaQuery.of(context).size.width / 12),
            (MediaQuery.of(context).size.width / 12),
            (MediaQuery.of(context).size.width / 12),
            (MediaQuery.of(context).size.width / 12)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Cré di tos',
              style: TextStyle(
                  color: Colors.green,
                  fontSize: MediaQuery.of(context).size.width / 12,
                  decoration: TextDecoration.none,
                  fontFamily: 'Sylexiad Sans Spaced'),
            ),
            const Spacer(flex: 3),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'FON TE',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: MediaQuery.of(context).size.width / 15,
                          decoration: TextDecoration.none,
                          fontFamily: 'Sylexiad Sans Spaced'),
                    ),
                    Text(
                      'SYLEXIAD - DR. ROBERT HILLIER',
                      style: TextStyle(
                          color: Colors.purple,
                          fontSize: MediaQuery.of(context).size.width / 17,
                          decoration: TextDecoration.underline,
                          decorationColor: Colors.purple,
                          fontFamily: 'Sylexiad Sans Spaced'),
                    ),
                  ],
                )
              ],
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'VER SÃO',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: MediaQuery.of(context).size.width / 15,
                          decoration: TextDecoration.none,
                          fontFamily: 'Sylexiad Sans Spaced'),
                    ),
                    Text(
                      '1.0.0',
                      style: TextStyle(
                          color: Colors.amber,
                          fontSize: MediaQuery.of(context).size.width / 17,
                          decoration: TextDecoration.underline,
                          decorationColor: Colors.amber,
                          fontFamily: 'Sylexiad Sans Spaced'),
                    ),
                  ],
                )
              ],
            ),
            const Spacer(flex: 3),
            _buildButtonDesign('Vol tar', Colors.lime, Icons.arrow_back, () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          HomePage(pref: widget.pref, camera: widget.camera)));
            })
          ],
        ),
      ),
    );
  }
}
