import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home_page.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key, required this.pref, required this.camera});

  final SharedPreferences pref;
  final CameraDescription camera;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DislexiLess Settings',
      theme: ThemeData(
        fontFamily: 'Sylexiad Sans Spaced',
        useMaterial3: true,
      ),
      home: Settings(pref: pref, camera: camera),
    );
  }
}

class Settings extends StatefulWidget {
  const Settings({super.key, required this.pref, required this.camera});

  final SharedPreferences pref;
  final CameraDescription camera;

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  String language = 'Português (PT-Br)';

  @override
  void initState() {
    super.initState();
  }

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
    //String language = "Português (PT-Br)";
    return Container(
        decoration:
            const BoxDecoration(color: Color.fromRGBO(247, 245, 255, 1)),
        child: Padding(
          padding: EdgeInsets.fromLTRB(
              (MediaQuery.of(context).size.width / 12),
              (MediaQuery.of(context).size.width / 12),
              (MediaQuery.of(context).size.width / 12),
              (MediaQuery.of(context).size.width / 12)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //Title
              Row(
                // TITLE
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'CON FI GU RA ÇÕES',
                    style: TextStyle(
                        color: Colors.orange,
                        fontSize: MediaQuery.of(context).size.width / 12,
                        decoration: TextDecoration.none,
                        fontFamily: 'Sylexiad Sans Spaced'),
                  ),
                ],
              ),
              //SETTINGS
              Padding(
                padding: EdgeInsets.only(
                    bottom: (MediaQuery.of(context).size.height / 10)),
                child: Column(children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: (MediaQuery.of(context).size.height / 10)),
                    child: Column(
                      children: [
                        const Text(
                          "Linguagem: ",
                          style: TextStyle(fontSize: 15),
                        ),
                        Material(
                            shape: const BeveledRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                              side: BorderSide(color: Colors.orange, width: 1),
                            ),
                            elevation: 20,
                            child: SizedBox(
                              height: MediaQuery.of(context).size.width / 5,
                              width: MediaQuery.of(context).size.width / 1.2,
                              child: DropdownButton<String>(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 20),
                                underline: const Text(" "),
                                value: language,
                                items: <String>[
                                  'Português (PT-Br)',
                                ].map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(
                                      value,
                                      style: TextStyle(
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              15,
                                          color: Colors.orange),
                                    ),
                                  );
                                }).toList(),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    language = newValue!;
                                  });
                                },
                              ),
                            ))
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      const Text(
                        "Id do Cliente: ",
                        style: TextStyle(fontSize: 15),
                      ),
                      Material(
                        shape: const BeveledRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          side: BorderSide(color: Colors.purple, width: 1),
                        ),
                        elevation: 20,
                        child: SizedBox(
                            width: MediaQuery.of(context).size.width / 1.2,
                            height: MediaQuery.of(context).size.width / 5,
                            child: TextFormField(
                              initialValue: widget.pref.getString('id') ?? "",
                              onChanged: (newId) {
                                widget.pref.setString("id", newId);
                              },
                              style: TextStyle(
                                  fontSize:
                                      MediaQuery.of(context).size.width / 10,
                                  color: Colors.purple),
                            )),
                      )
                    ],
                  )
                ]),
              ),
              //Exit
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _buildButtonDesign('Vol tar', Colors.lime, Icons.arrow_back,
                      () {
                    print("novo id: ${widget.pref.getString("id")}");
                    print("nova linguagem: $language");
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => HomePage(
                                pref: widget.pref, camera: widget.camera)));
                  })
                ],
              ),
            ],
          ),
        ));
  }
}
