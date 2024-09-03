import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final cameras = await availableCameras();
  final firstCamera = cameras.first;

  final pref = await SharedPreferences.getInstance();

  int access = (pref.getInt("acess_amount") ?? 0) + 1;
  pref.setInt("acess_amount", access);

  print(
      "client_id: ${pref.getString('id')}\naccess_amount: ${pref.getInt('acess_amount')}\nscanned_words: ${pref.getInt('scanned_words')}\nwords_read: ${pref.getInt('words_read')}");

  runApp(MaterialApp(
    title: 'DislexiLess',
    theme: ThemeData(
      fontFamily: 'Sylexiad Sans Spaced',
      useMaterial3: true,
    ),
    home: HomePage(pref: pref, camera: firstCamera),
  ));
}
