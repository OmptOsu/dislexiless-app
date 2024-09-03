import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class ReaderCameraPage extends StatelessWidget {
  const ReaderCameraPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DislexiLess Camera',
      theme: ThemeData(
        fontFamily: 'Sylexiad Sans Spaced',
        useMaterial3: true,
      ),
      home: const CameraReader(),
    );
  }
}

class CameraReader extends StatefulWidget {
  const CameraReader({super.key});

  @override
  State<CameraReader> createState() => _ReaderPageState();
}

class _ReaderPageState extends State<CameraReader> {
  //late CameraDescription _camera;
  late CameraController _cameraController;
  late Future<void> _initializeControllerFuture;

  bool isLoading = true;

  Future<CameraDescription> getCameraDescription() async {
    List<CameraDescription> cameras = await availableCameras();
    var camera = cameras.first;
    isLoading = false;
    return camera;
  }

  CameraController buildController(CameraDescription camera) {
    final CameraController controller = CameraController(
      camera,
      ResolutionPreset.max,
      enableAudio: false,
      imageFormatGroup: Platform.isAndroid
          ? ImageFormatGroup.nv21
          : ImageFormatGroup.bgra8888,
    );
    return controller;
  }

  @override
  void initState() {
    super.initState();
    //_buildCamera(context);
    //final camera = _buildCamera(context);
    //_cameraController =
    //    CameraController(widget.camera, ResolutionPreset.medium);
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const CircularProgressIndicator();
    } else {
      return cameraScreen(context);
    }
  }

  Future<CameraDescription> _buildCamera(BuildContext context) async {
    final camera = await getCameraDescription();
    //if (isLoading) {
    //_cameraController = CameraController(camera, ResolutionPreset.medium);
    //_initializeControllerFuture = _cameraController.initialize();
    //}
    setState(() {
      isLoading = false;
    });
    return camera;
  }

  Widget cameraScreen(BuildContext context) {
    return Scaffold(
        body: FutureBuilder<void>(
          future: _initializeControllerFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return CameraPreview(_cameraController);
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
        floatingActionButton: FloatingActionButton(onPressed: () async {
          try {
            await _initializeControllerFuture;
            final image = await _cameraController.takePicture();
            if (!mounted) return;

            final inputImage = InputImage.fromFilePath(image.path);
            final textRecognizer =
                TextRecognizer(script: TextRecognitionScript.latin);

            final RecognizedText recognizedText =
                await textRecognizer.processImage(inputImage);

            String text = recognizedText.text;
            for (TextBlock block in recognizedText.blocks) {
              //final Rect rect = block.boundingBox;
              //final List<Point<int>> cornerPoints = block.cornerPoints;
              //final String text = block.text;
              final List<String> languages = block.recognizedLanguages;

              print("Texto: $text \n Linguagem: $languages");
            }
            textRecognizer.close();
          } catch (e) {
            // If an error occurs, log the error to the console.
            print(e);
          }
        }));
  }
}
