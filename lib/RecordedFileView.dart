import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class RecordedFileView extends StatefulWidget {
  const RecordedFileView() : super();

  @override
  _RecordedFileViewState createState() => _RecordedFileViewState();
}

class _RecordedFileViewState extends State<RecordedFileView> {
  VideoPlayerController? _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset(
        'assets/rabbit.mp4')
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }
//daf
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: _controller!.value.isInitialized
            ? AspectRatio(
          aspectRatio: _controller!.value.aspectRatio,
          child: VideoPlayer(_controller!),
        ) : Container(),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          _controller!.value.isPlaying ? Icons.pause : Icons.play_arrow,
        ),
        onPressed: () {
          setState(() {
            _controller!.value.isPlaying
                ? _controller!.pause()
                : _controller!.play();
          });
        },
      ),
    );
  }
}
