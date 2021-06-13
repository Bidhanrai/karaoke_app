import 'package:flutter/material.dart';
import 'package:karaoke_app/Service/AudioPlayerService.dart';
import 'package:karaoke_app/ServiceProvider.dart';
import 'package:karaoke_app/View/RecordView.dart';
import 'package:karaoke_app/View/RecordedFileView.dart';
import 'package:audioplayers/audioplayers.dart';

class HomView extends StatefulWidget {
  const HomView() : super();

  @override
  _HomViewState createState() => _HomViewState();
}

class _HomViewState extends State<HomView> {

  final String assetFilePath = "LaxedSirenBeat.mp3";

  var audioPlayerService = getIt<AudioPlayerService>();

  @override
  void initState() {
    super.initState();
    _setUpListeners();
  }

  _setUpListeners() async{
    await audioPlayerService.loadUrl(assetFilePath);

    audioPlayerService.audioPlayer.onDurationChanged.listen((Duration duration) {
      setState(() {
        audioPlayerService.maxDuration = duration.inSeconds;
      });
    });

    audioPlayerService.audioPlayer.onPlayerStateChanged.listen((PlayerState event) {
      setState(() {});
    });

    audioPlayerService.audioPlayer.onAudioPositionChanged.listen((Duration duration) {
      setState(() {
        audioPlayerService.currentPosition = duration.inSeconds;
      });
    });
  }

  @override
  void dispose() {
    audioPlayerService.audioPlayer.dispose();
    audioPlayerService.audioCache.clearAll();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Karaoke"),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context)=>RecordedFileView()));
            },
            icon: Icon(Icons.list),
          ),
        ],
      ),
      body: ListView.separated(
        itemCount: 1,
        separatorBuilder: (context, index)=>Divider(),
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _titleWidget(),
                _progressBarWidget(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _titleWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            "Laxed Siren Beat",
            maxLines: 2,
            overflow: TextOverflow.clip,
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
        ),
        TextButton(
          onPressed: () {
            audioPlayerService.audioPlayer.stop();
            Navigator.push(context, MaterialPageRoute(builder: (context)=>RecordView()));
          },
          child: Text(
            "Use this song",
            style: TextStyle(fontSize: 12, color: Colors.white,),
          ),
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.blue)
          ),
        ),
      ],
    );
  }

  Widget _progressBarWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("00:${audioPlayerService.currentPosition}"),
                  Text("00:${audioPlayerService.maxDuration}"),
                ],
              ),
              LinearProgressIndicator(
                value: audioPlayerService.maxDuration==0?0:(audioPlayerService.currentPosition/audioPlayerService.maxDuration).toDouble(),
                color: Colors.pink,
                backgroundColor: Colors.pink.shade100,
                minHeight: 5,
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: () {
            if(audioPlayerService.audioPlayer.state == PlayerState.PLAYING) {
              audioPlayerService.audioPlayer.pause();
            } else if(audioPlayerService.audioPlayer.state == PlayerState.PAUSED) {
              audioPlayerService.audioPlayer.resume();
            } else {
              audioPlayerService.audioCache.play(assetFilePath);
            }
          },
          icon: Icon(
              audioPlayerService.audioPlayer.state == PlayerState.PAUSED || audioPlayerService.audioPlayer.state == PlayerState.COMPLETED
                ? Icons.play_arrow
                : audioPlayerService.audioPlayer.state == PlayerState.STOPPED
                    ? Icons.play_arrow
                    : Icons.pause
          ),
        ),
      ],
    );
  }
}



