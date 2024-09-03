import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:dislexiless_app/reader.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:shared_preferences/shared_preferences.dart';

// A screen that allows users to take a picture using a given camera.
class TakePictureScreen extends StatefulWidget {
  const TakePictureScreen({
    super.key,
    required this.pref,
    required this.camera,
  });

  final SharedPreferences pref;
  final CameraDescription camera;

  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

class TakePictureScreenState extends State<TakePictureScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);

  @override
  void initState() {
    super.initState();
    // To display the current output from the Camera,
    // create a CameraController.
    _controller = CameraController(
      // Get a specific camera from the list of available cameras.
      widget.camera,
      // Define the resolution to use.
      ResolutionPreset.medium,
    );

    // Next, initialize the controller. This returns a Future.
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String textToRead = "texto exemplo";
    return Scaffold(
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // If the Future is complete, display the preview.
            return SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: CameraPreview(_controller));
          } else {
            // Otherwise, display a loading indicator.
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      extendBody: true,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: OutlinedButton(
        style: OutlinedButton.styleFrom(
          shape: const CircleBorder(),
          side: const BorderSide(color: Colors.blue, width: 3),
          backgroundColor: Colors.white,
          elevation: 10,
          shadowColor: Colors.black,
          padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 30),
        ),

        // Provide an onPressed callback.
        onPressed: () async {
          // Take the Picture in a try / catch block. If anything goes wrong,
          // catch the error.
          try {
            // Ensure that the camera is initialized.
            await _initializeControllerFuture;

            // Attempt to take a picture and get the file `image`
            // where it was saved.
            final image = await _controller.takePicture();
            if (!mounted) return;

            final RecognizedText recognizedText = await textRecognizer
                .processImage(InputImage.fromFilePath(image.path));

            textToRead = recognizedText.text;

            // If the picture was taken, display it on a new screen.
            //await Navigator.of(context).push(
            //  MaterialPageRoute(
            //    builder: (context) => DisplayPictureScreen(
            // Pass the automatically generated path to
            // the DisplayPictureScreen widget.
            //      imagePath: image.path,
            //    ),
            //  ),
            //);
          } catch (e) {
            // If an error occurs, log the error to the console.
            print(e);
          }
          if (context.mounted && textToRead != "") {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => ReaderPage(
                    pref: widget.pref,
                    text: textToRead,
                    camera: widget.camera)));
          } else if (context.mounted) {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: ((context) => TakePictureScreen(
                      pref: widget.pref, camera: widget.camera))),
            );
          }
        },
        child: Icon(Icons.camera_alt,
            size: (MediaQuery.of(context).size.width / 10), color: Colors.blue),
      ),
    );
  }
}

// A widget that displays the picture taken by the user.
class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;

  const DisplayPictureScreen({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Display the Picture')),
      // The image is stored as a file on the device. Use the `Image.file`
      // constructor with the given path to display the image.
      body: Image.file(File(imagePath)),
    );
  }
}
