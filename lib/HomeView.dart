
import 'package:flutter/material.dart';
import 'package:karaoke_app/RecordView.dart';
import 'package:karaoke_app/RecordedFileView.dart';
import 'package:audioplayers/audioplayers.dart';

class HomView extends StatefulWidget {
  const HomView() : super();

  @override
  _HomViewState createState() => _HomViewState();
}

class _HomViewState extends State<HomView> {

  AudioPlayer audioPlayer = AudioPlayer();
  AudioCache audioCache = AudioCache();
  Uri? uri;
  final String assetFilePath = "LaxedSirenBeat.mp3";
  int maxDuration = 00;
  int currentPosition = 00;

  @override
  void initState() {
    super.initState();
    _loadUrl();
  }

  _loadUrl() async{
    audioCache = AudioCache(fixedPlayer: audioPlayer);
    // audioPlayer.setVolume(0.1);
    audioPlayer.setUrl(assetFilePath, isLocal: true);
    await audioCache.load(assetFilePath);

    audioPlayer.onDurationChanged.listen((Duration duration) {
      setState(() {
        maxDuration = duration.inSeconds;
      });
    });

    audioPlayer.onPlayerStateChanged.listen((PlayerState event) {
      setState(() {});
    });

    audioPlayer.onAudioPositionChanged.listen((Duration duration) {
      setState(() {
        currentPosition = duration.inSeconds;
      });
    });
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    audioCache.clearAll();
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
            "Ankha maa aune sapani kaile po pura hunxa ni ankha ",
            maxLines: 2,
            overflow: TextOverflow.clip,
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
        ),
        TextButton(
          onPressed: () {
            audioPlayer.stop();
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
                  Text("00:$currentPosition"),
                  Text("00:$maxDuration"),
                ],
              ),
              LinearProgressIndicator(
                value: maxDuration==0?0:(currentPosition/maxDuration).toDouble(),
                color: Colors.pink,
                backgroundColor: Colors.pink.shade100,
                minHeight: 5,
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: () {
            if(audioPlayer.state == PlayerState.PLAYING) {
              audioPlayer.pause();
            } else if(audioPlayer.state == PlayerState.PAUSED) {
              audioPlayer.resume();
            } else {
              audioCache.play(assetFilePath);
            }
          },
          icon: Icon(
            audioPlayer.state == PlayerState.PAUSED || audioPlayer.state == PlayerState.COMPLETED
                ? Icons.play_arrow
                : audioPlayer.state == PlayerState.STOPPED
                    ? Icons.play_arrow
                    : Icons.pause
          ),
        ),
      ],
    );
  }
}



