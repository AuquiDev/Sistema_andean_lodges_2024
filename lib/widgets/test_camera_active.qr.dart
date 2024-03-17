
// ignore_for_file: avoid_print, unused_field

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:qr_bar_code_scanner_dialog/qr_bar_code_scanner_dialog.dart';
import 'package:camera/camera.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    final cameras = await availableCameras();
    runApp(MyApp(cameras: cameras));
  } catch (e) {
    print('Error initializing cameras: $e');
  }
}

class MyApp extends StatelessWidget {
  final List<CameraDescription> cameras;

  const MyApp({Key? key, required this.cameras}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Camera Demo',
      home: MyHomePage(title: 'Camera Example', cameras: cameras),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String? title;
  final List<CameraDescription> cameras;

  const MyHomePage({Key? key, this.title, required this.cameras})
      : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  CameraController? _cameraController;
  XFile? _imageFile;
  ImagePicker _picker = ImagePicker();
  final QrBarCodeScannerDialog _qrBarCodeScannerDialogPlugin =
      QrBarCodeScannerDialog();
  String? code;

  @override
  void initState() {
    super.initState();
    if (widget.cameras.isEmpty) {
      print('No cameras available');
    } else {
      _initializeCamera();
    }
  }

  Future<void> _initializeCamera() async {
    _cameraController = CameraController(
      widget.cameras[0],
      ResolutionPreset.high,
    );

    try {
      await _cameraController!.initialize();
      // if (mounted) {
      //   setState(() {});
      // }
    // } catch (e) {
    //   print('Error initializing camera: $e');
    // }
      _cameraController!.initialize().then((_) {
        if (!mounted) {
          return;
        }
        setState(() {});
      });

      _picker = ImagePicker();
    } catch (e) {
      print("Error initializing camera: $e");
    
  }

  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  Future<void> _onCaptureButtonPressed() async {
    try {
      final XFile file = await _cameraController!.takePicture();
      setState(() {
        _imageFile = file;
      });
    } catch (e) {
      print('Error taking picture: $e');
    }
  }

  Future<void> _onScanQRCodeButtonPressed(BuildContext context) async {
    _qrBarCodeScannerDialogPlugin.getScannedQrBarCode(
      context: context,
      onCode: (code) {
        setState(() {
          this.code = code;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return Container();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title!),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Expanded(
              child: AspectRatio(
                aspectRatio: _cameraController!.value.aspectRatio,
                child: CameraPreview(_cameraController!),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                IconButton(
                  onPressed: _onCaptureButtonPressed,
                  icon: const Icon(Icons.camera),
                ),
                IconButton(
                  onPressed: () => _onScanQRCodeButtonPressed(context),
                  icon: const Icon(Icons.qr_code),
                ),
              ],
            ),
            if (_imageFile != null) _buildImageWidget(),
            Text(code ?? 'Scan a QR code'),
          ],
        ),
      ),
    );
  }

  Widget _buildImageWidget() {
    return Image.file(File(_imageFile!.path));
  }
}
