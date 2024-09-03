import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:dislexiless_app/home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ReaderPage extends StatelessWidget {
  const ReaderPage(
      {super.key,
      required this.pref,
      required this.camera,
      required this.text});

  final SharedPreferences pref;
  final CameraDescription camera;
  final String text;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DislexiLess Reader',
      theme: ThemeData(
        fontFamily: 'Sylexiad Sans Spaced',
        useMaterial3: true,
      ),
      home: Reader(pref: pref, camera: camera, text: text),
    );
  }
}

class Reader extends StatefulWidget {
  const Reader(
      {super.key,
      required this.pref,
      required this.camera,
      required this.text});

  final SharedPreferences pref;
  final String text;
  final CameraDescription camera;

  @override
  State<Reader> createState() => _ReaderState();
}

class _ReaderState extends State<Reader> {
  final RegExp _syllableRegex = RegExp(
      r'([^aeiouy]*[aeiouy]+(?:[^aeiouy]*$|[^aeiouy](?=[^aeiouy]))?)',
      caseSensitive: false);
  //final stringTeste = 'Teste de leitura';

  late List<String> _words;
  late List<List<String>> _syllables;

  int _wordCounter = 0;
  int _sylCounter = 0;
  String _sylDisplay = " ";
  //String _wordDisplay = " ";

  late int scanned;
  late int read;

  @override
  void initState() {
    scanned = widget.pref.getInt("scanned_words") ?? 0;
    read = widget.pref.getInt("words_read") ?? 0;
    super.initState();
  }

  void _incrementWordCounter() {
    setState(() {
      _wordCounter++;
      _sylCounter = 0;
      _updateWord();
    });
  }

  void _decrementWordCounter() {
    setState(() {
      _wordCounter--;
      _sylCounter = _syllables[_wordCounter].length - 1;
      _updateWord();
    });
  }

  void _incremetSylCounter() {
    setState(() {
      _sylCounter++;
      _updateWord();
    });
  }

  void _decrementSylCounter() {
    setState(() {
      _sylCounter--;
      _updateWord();
    });
  }

  void _updateWord() {
    setState(() {
      _sylDisplay = _syllables[_wordCounter][_sylCounter];
      //_wordDisplay = _words[_wordCounter];
    });
  }

  List<String> _wordDivider(String text) {
    List<String> toReturn = List.empty(growable: true);
    var read = text.toUpperCase().split('\n');
    for (var n in read) {
      var list = n.split(' ');
      for (var word in list) {
        toReturn.add(word);
      }
    }
    return toReturn;
  }

  void _sendData(
      String id, int accessAmount, int wordsScanned, int wordsRead) async {
    var url = Uri.https('api.dislexiless.com', 'patients/indices');
    print("sending to $url");
    try {
      var response = await http.post(url, body: {
        "code": id,
        "accessAmount": accessAmount.toString(),
        "wordsScanned": wordsScanned.toString(),
        "wordsRead": wordsRead.toString()
      });
      //print('Response status: ${response.statusCode}');
      //print('Response body: ${response.body}');
      print(response);
    } catch (e) {
      print(e);
    }
    print("send object set");
  }

  List<String> _syllableDivider(String word) {
    List<String> toReturn = List.empty(growable: true);
    var matches =
        _syllableRegex.allMatches(word).map((z) => z.group(0)).toList();
    for (final match in matches) {
      toReturn.add(match ?? " ");
    }
    return toReturn;
  }

  List<List<String>> _finalDivider(List<String> text) {
    List<List<String>> toReturn = List.empty(growable: true);
    for (final word in text) {
      toReturn.add(_syllableDivider(word));
    }
    return toReturn;
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
    _words = _wordDivider(widget.text);
    setState(() {
      scanned += _words.length;
    });
    _syllables = _finalDivider(_words);
    _updateWord();
    print(
        "Texto: ${widget.text}\n${_words.length} Palavra(s): $_words\n${_syllables.length} Sílaba(s): $_syllables");
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'Lei tor',
                      style: TextStyle(
                          color: Colors.blue,
                          fontSize: MediaQuery.of(context).size.width / 10,
                          decoration: TextDecoration.none,
                          fontFamily: 'Sylexiad Sans Spaced'),
                    ),
                  ],
                ),
                const Spacer(),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(width: 3, color: Colors.blue),
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.white,
                      ),
                      width: MediaQuery.of(context).size.width / 2,
                      height: MediaQuery.of(context).size.width / 2,
                      padding: EdgeInsets.all(
                          (MediaQuery.of(context).size.width / 20)),
                      child: Center(
                          child: Text(
                        _sylDisplay,
                        style: const TextStyle(
                            decoration: TextDecoration.none,
                            fontFamily: 'Sylexiad Sans Spaced',
                            color: Colors.black),
                      )),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        OutlinedButton(
                          onPressed: () {
                            if (_sylCounter > 0) {
                              _decrementSylCounter();
                            } else if (_wordCounter > 0) {
                              setState(() {
                                read--;
                              });
                              _decrementWordCounter();
                            }
                            _updateWord();
                          },
                          style: OutlinedButton.styleFrom(
                            shape: const CircleBorder(),
                            side:
                                const BorderSide(color: Colors.blue, width: 3),
                            backgroundColor: Colors.white,
                            elevation: 20,
                            shadowColor: Colors.black,
                            padding: const EdgeInsets.symmetric(
                                vertical: 30, horizontal: 30),
                          ),
                          child: Icon(Icons.chevron_left,
                              size: (MediaQuery.of(context).size.width / 15),
                              color: Colors.blue),
                        ),
                        const Spacer(),
                        OutlinedButton(
                          onPressed: () {
                            if (_sylCounter <
                                _syllables[_wordCounter].length - 1) {
                              _incremetSylCounter();
                            } else if (_wordCounter < _words.length - 1) {
                              setState(() {
                                read++;
                              });
                              _incrementWordCounter();
                            }
                            _updateWord();
                          },
                          style: OutlinedButton.styleFrom(
                            shape: const CircleBorder(),
                            side:
                                const BorderSide(color: Colors.blue, width: 3),
                            backgroundColor: Colors.white,
                            elevation: 20,
                            shadowColor: Colors.black,
                            padding: const EdgeInsets.symmetric(
                                vertical: 30, horizontal: 30),
                          ),
                          child: Icon(Icons.chevron_right,
                              size: (MediaQuery.of(context).size.width / 15),
                              color: Colors.blue),
                        )
                      ],
                    )
                  ],
                ),
                const Spacer(flex: 2),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildButtonDesign('Sa ir', Colors.lime, Icons.arrow_back,
                        () {
                      widget.pref.setInt("words_read", read);
                      widget.pref.setInt("scanned_words", scanned);
                      print(read);
                      final String id = widget.pref.getString("id") ?? "";
                      if (id != "") {
                        _sendData(
                            id,
                            widget.pref.getInt("acess_amount") ?? 0,
                            widget.pref.getInt("scanned_words") ?? 0,
                            widget.pref.getInt("words_read") ?? 0);
                      } else {
                        print("id vazio");
                      }
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => HomePage(
                                  pref: widget.pref, camera: widget.camera)));
                    })
                  ],
                )
              ],
            )));
  }
}
