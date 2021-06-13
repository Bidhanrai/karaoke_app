import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:karaoke_app/Service/AudioPlayerService.dart';
import 'package:karaoke_app/ServiceProvider.dart';
import 'package:karaoke_app/View/VideoView.dart';

class RecordView extends StatefulWidget {
  const RecordView() : super();

  @override
  _RecordViewState createState() => _RecordViewState();
}

class _RecordViewState extends State<RecordView> {

  List<CameraDescription>? cameras;
  CameraController? controller;
  int selectedCameraIdx = 0;

  final String assetFilePath = "LaxedSirenBeat.mp3";
  var audioPlayerService = getIt<AudioPlayerService>();
  //
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

  @override
  void initState() {
    super.initState();
    availableCameras().then((availableCameras) {
      cameras = availableCameras;
      if (cameras!.length > 0) {
        if(cameras!.length > 1) {
          setState(() {
            selectedCameraIdx = 1;
          });
        } else {
          setState(() {
            selectedCameraIdx = 0;
          });
        }
        _initCameraController(cameras![selectedCameraIdx]).then((void v) {});
      }else{
        print("No camera available");
      }
    }).catchError((err) {
      print('Error: $err.code\nError Message: $err.message');
    });

    _setUpListeners();
  }

  _setUpListeners() async{
    await audioPlayerService.loadUrl(assetFilePath);

    audioPlayerService.audioPlayer.onDurationChanged.listen((Duration duration) {
      if (!mounted) {
        return;
      }
      setState(() {
        audioPlayerService.maxDuration = duration.inSeconds;
      });
    });

    audioPlayerService.audioPlayer.onPlayerStateChanged.listen((PlayerState event) {
      if (!mounted) {
        return;
      }
      if(audioPlayerService.audioPlayer.state == PlayerState.COMPLETED){
        audioPlayerService.audioPlayer.stop();
        _stopVideoRecording();
      }
      setState(() {});
    });

    audioPlayerService.audioPlayer.onAudioPositionChanged.listen((Duration duration) {
      if (!mounted) {
        return;
      }
      setState(() {
        audioPlayerService.currentPosition = duration.inSeconds;
      });
    });
  }

  Future _initCameraController(CameraDescription cameraDescription) async {
    if (controller != null) {
      await controller!.dispose();
    }

    controller = CameraController(cameraDescription, ResolutionPreset.high, enableAudio: false);
    controller!.addListener(() {
      if (mounted) {
        setState(() {});
      }

      if (controller!.value.hasError) {
        print('Camera error ${controller!.value.errorDescription}');
      }
    });

    try {
      await controller!.initialize();
    } on CameraException catch (e) {
      print(e.toString());
    }

    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    audioPlayerService.audioPlayer.dispose();
    audioPlayerService.audioCache.clearAll();
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

  _toggleCamera() {
    selectedCameraIdx = selectedCameraIdx < cameras!.length - 1 ? selectedCameraIdx + 1 : 0;
    CameraDescription cameraDescription = cameras![selectedCameraIdx];
    _initCameraController(cameraDescription);
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
              value: audioPlayerService.maxDuration==0?0:(audioPlayerService.currentPosition/audioPlayerService.maxDuration).toDouble(),
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
    if (cameras == null || cameras!.isEmpty) {
      return SizedBox();
    }

    CameraDescription selectedCamera = cameras![selectedCameraIdx];
    CameraLensDirection lensDirection = selectedCamera.lensDirection;

    return Container(
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
            onPressed: () async{
              if(audioPlayerService.audioPlayer.state == PlayerState.PLAYING) {
                await audioPlayerService.audioPlayer.pause();
                if(controller!.value.isRecordingVideo) {
                  await controller!.pauseVideoRecording();
                }
              } else {
                if(audioPlayerService.audioPlayer.state == PlayerState.PAUSED) {
                  await audioPlayerService.audioPlayer.resume();
                }
                if(controller!.value.isRecordingPaused) {
                  await controller!.resumeVideoRecording();
                  return;
                }
                await controller!.startVideoRecording();
                await audioPlayerService.audioCache.play(assetFilePath, volume: 0.5);
              }
            },
            icon: Icon(
              audioPlayerService.audioPlayer.state == PlayerState.PLAYING
                  ? Icons.pause_circle_filled
                  : Icons.not_started,
              size: 40,
              color: Colors.pink,
            ),
          ),

          IconButton(
            onPressed: () {
              _toggleCamera();
            },
            icon: Icon(getCameraLensIcon(lensDirection), size: 40, color: Colors.white,),
          ),

          audioPlayerService.audioPlayer.state == PlayerState.PLAYING ||  audioPlayerService.audioPlayer.state == PlayerState.PAUSED
              ? IconButton(
                  onPressed: () async{
                    await audioPlayerService.audioPlayer.stop();
                    _stopVideoRecording();
                  },
                  icon: Icon(
                    Icons.done,
                    size: 40,
                    color: Colors.green,
                  ),
                )
              : SizedBox()
        ],
      ),
    );
  }

  _stopVideoRecording() {
    controller!.stopVideoRecording().then((file) {
      ///TODO: Video Audio Merge code here////
      //assetFilePath
      //file
      /////////////////////

      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => VideoView(
                videoFilePath: file.path,
              )));
    });
  }
}

