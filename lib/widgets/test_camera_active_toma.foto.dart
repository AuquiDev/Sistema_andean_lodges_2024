
// ignore_for_file: avoid_print
import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final cameras = await availableCameras();
  runApp(MyApp(cameras: cameras));
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
  XFile? _videoFile;
  VideoPlayerController? _videoController;
  VoidCallback? _videoPlayerListener;
  late ImagePicker _picker;

  @override
  void initState() {
    super.initState();
    _cameraController = CameraController(
      widget.cameras[0],
      ResolutionPreset.medium,
    );
    _cameraController!.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });

    _picker = ImagePicker();
  }

  @override
  void dispose() {
    _cameraController!.dispose();
    super.dispose();
  }

  Future<void> _onCaptureButtonPressed() async {
    try {
      final XFile file = await _cameraController!.takePicture();
      setState(() {
        _imageFile = file;
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> _onRecordButtonPressed() async {
    try {
      final XFile? file = await _picker.pickVideo(source: ImageSource.camera);
      setState(() {
        _videoFile = file;
        _videoController = VideoPlayerController.file(File(file!.path))
          ..initialize().then((_) {
            setState(() {});
            _videoController!.play();
          });
        _videoPlayerListener = () {
          if (_videoController != null &&
              _videoController!.value.position ==
                  _videoController!.value.duration) {
            // Video completo
            setState(() {});
          }
        };
        _videoController!.addListener(_videoPlayerListener!);
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> _onLoadImageButtonPressed() async {
    try {
      final XFile? file =
          await _picker.pickImage(source: ImageSource.gallery);
      setState(() {
        _imageFile = file;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_cameraController!.value.isInitialized) {
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
                  onPressed: _onRecordButtonPressed,
                  icon: const Icon(Icons.videocam),
                ),
                IconButton(
                  onPressed: _onLoadImageButtonPressed,
                  icon: const Icon(Icons.image),
                ),
              ],
            ),
            if (_imageFile != null)
              _buildImageWidget()
            else if (_videoFile != null)
              _buildVideoPlayer()
          ],
        ),
      ),
    );
  }

  Widget _buildVideoPlayer() {
    if (_videoController != null && _videoController!.value.isInitialized) {
      return AspectRatio(
        aspectRatio: _videoController!.value.aspectRatio,
        child: VideoPlayer(_videoController!),
      );
    } else {
      return Container();
    }
  }

  Widget _buildImageWidget() {
    if (_imageFile != null) {
      if (kIsWeb) {
        // Web no admite Image.file, considera usar Image.network o Image.asset
        return Image.network(_imageFile!.path);
      } else {
        return Image.file(File(_imageFile!.path));
      }
    } else {
      return Container();
    }
  }
}
