
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoView extends StatefulWidget {
  final String? videoFilePath;
  const VideoView({@required this.videoFilePath}) : super();

  @override
  _VideoViewState createState() => _VideoViewState();
}

class _VideoViewState extends State<VideoView> {
  VideoPlayerController? _controller;

  @override
  void initState() {
    super.initState();
    print(widget.videoFilePath);
    _controller = VideoPlayerController.file(File(widget.videoFilePath!))
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });

    _controller!.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: _controller!.value.isInitialized
            ? AspectRatio(
                aspectRatio: _controller!.value.aspectRatio,
                child: VideoPlayer(_controller!),
              )
            : Container(),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          !_controller!.value.isPlaying || _controller!.value.duration == _controller!.value.position ? Icons.play_arrow : Icons.pause,
        ),
        onPressed: () {
          setState(() {
            if(_controller!.value.duration == _controller!.value.position) {
              _controller!.seekTo(Duration.zero);
              _controller!.play();
              return;
            }
            !_controller!.value.isPlaying
                ? _controller!.play()
                : _controller!.pause();
          });
        },
      ),
    );
  }
}
