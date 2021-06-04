import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

class RecordView extends StatefulWidget {
  const RecordView() : super();

  @override
  _RecordViewState createState() => _RecordViewState();
}

class _RecordViewState extends State<RecordView> {
  // @override
  // void didChangeAppLifecycleState(AppLifecycleState state) {
  //   // App state changed before we got the chance to initialize.
  //   if (controller == null || !controller!.value.isInitialized) {
  //     return;
  //   }
  //   if (state == AppLifecycleState.inactive) {
  //     controller?.dispose();
  //   } else if (state == AppLifecycleState.resumed) {
  //     if (controller != null) {
  //       onNewCameraSelected(controller.description);
  //     }
  //   }
  // }
  List<CameraDescription>? cameras;

  CameraController? controller;

  AudioPlayer audioPlayer = AudioPlayer();
  AudioCache audioCache = AudioCache();
  Uri? uri;
  final String assetFilePath = "LaxedSirenBeat.mp3";
  int maxDuration = 00;
  int currentPosition = 00;

  @override
  void initState() {
    super.initState();
    setUpCamera();
    _loadUrl();
  }

  _loadUrl() async{
    audioCache = AudioCache(fixedPlayer: audioPlayer);
    audioPlayer.setUrl(assetFilePath, isLocal: true);
    await audioCache.load(assetFilePath);

    audioPlayer.onDurationChanged.listen((Duration duration) {
      if (!mounted) {
        return;
      }
      setState(() {
        maxDuration = duration.inSeconds;
      });
    });

    audioPlayer.onPlayerStateChanged.listen((PlayerState event) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });

    audioPlayer.onAudioPositionChanged.listen((Duration duration) {
      if (!mounted) {
        return;
      }
      setState(() {
        currentPosition = duration.inSeconds;
      });
    });
  }

  setUpCamera() async{
    cameras = await availableCameras();
    controller = CameraController(cameras![0], ResolutionPreset.max);
    await controller!.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    audioPlayer.dispose();
    audioCache.clearAll();
    super.dispose();
  }

  IconData getCameraLensIcon(CameraLensDirection direction) {
    switch (direction) {
      case CameraLensDirection.back:
        return Icons.camera_rear;
      case CameraLensDirection.front:
        return Icons.camera_front;
      case CameraLensDirection.external:
        return Icons.camera;
      default:
        throw ArgumentError('Unknown lens direction');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _previewWidget(controller),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: _appBarWidget(),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _bottomBarWidget(),
          ),
        ],
      ),
    );
  }

  Widget _appBarWidget() {
    return Container(
      padding: EdgeInsets.all(10),
      color: Colors.blue.shade400,
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.close),
          ),
          Expanded(
            child: LinearProgressIndicator(
              value: maxDuration==0?0:(currentPosition/maxDuration).toDouble(),
              color: Colors.pink,
              backgroundColor: Colors.white,
              minHeight: 5,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _previewWidget(CameraController? controller) {

    if(controller == null) {
      return Container();
    }
    if (!controller.value.isInitialized) {
      return Container();
    }
    return Center(
      child: CameraPreview(controller),
    );
  }

  Widget _bottomBarWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TextButton(
            onPressed: () {
            },
            child: Text(
              "Timer",
              style: TextStyle(fontSize: 12, color: Colors.white,),
            ),
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.blue)
            ),
          ),
          IconButton(
            onPressed: () {
              if(audioPlayer.state == PlayerState.PLAYING) {
                audioPlayer.stop();
              } else {
                audioCache.play(assetFilePath, volume: 0.05);
              }
            },
            icon: Icon(
              audioPlayer.state == PlayerState.PLAYING
                  ? Icons.pause_circle_filled
                  : Icons.not_started,
              size: 40,
              color: Colors.pink,
            ),
          ),

          IconButton(
            onPressed: () {
              // setState(() {
              //   // getCameraLensIcon(CameraLensDirection.front);
              // });
            },
            icon: Icon(getCameraLensIcon(CameraLensDirection.back), size: 40, color: Colors.white,),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.done, size: 40, color: Colors.green,),
          ),

        ],
      ),
    );
  }
}

