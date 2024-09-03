import 'package:camera/camera.dart';
import 'package:dislexiless_app/camera_controller.dart';
import 'package:dislexiless_app/credits_page.dart';
import 'package:dislexiless_app/settings_page.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import 'reader.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.pref, required this.camera});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final SharedPreferences pref;
  final CameraDescription camera;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String id = "";

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
          padding: const EdgeInsets.symmetric(vertical: 30),
          minimumSize: const Size.fromHeight(50)),
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
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
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
            0),
        child: Column(
          children: <Widget>[
            const Row(
              // TITLE
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Image(image: AssetImage('assets/dislexiless_logo.png')),
              ],
            ),
            Expanded(
              //Usa a Maior parte da Tela como espaço para os botões
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  //Uma Abominação usando Spacer() pra espaços em branco, mas deve resolver por enquanto
                  const Spacer(flex: 5),

                  _buildButtonDesign(
                      "Lei tor", Colors.lightBlue, Icons.camera_alt_outlined,
                      () {
                    print("Leitor");
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: ((context) => TakePictureScreen(
                              pref: widget.pref, camera: widget.camera))),
                    );
                  }),

                  const Spacer(flex: 1),
                  _buildButtonDesign("Con fi gu ra ções", Colors.orange,
                      Icons.settings_outlined, () {
                    print("Configurações");
                    if (context.mounted) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SettingsPage(
                                  pref: widget.pref, camera: widget.camera)));
                    }
                  }),
                  const Spacer(flex: 8),
                ],
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RichText(
                  text: TextSpan(
                      text: "v1.0.0",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: MediaQuery.of(context).size.width / 25,
                      )),
                ),
                RichText(
                  text: TextSpan(
                      text: 'cré di tos',
                      style: TextStyle(
                          color: Colors.green,
                          fontSize: MediaQuery.of(context).size.width / 20,
                          decoration: TextDecoration.underline,
                          decorationColor: Colors.green),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          print("Créditos");
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CreditsPage(
                                      pref: widget.pref,
                                      camera: widget.camera)));
                        }),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
