
import 'package:audioplayers/audioplayers.dart';

class AudioPlayerService {
  AudioPlayer audioPlayer = AudioPlayer();
  AudioCache audioCache = AudioCache();

  int maxDuration = 00;
  int currentPosition = 00;

  loadUrl(String assetFilePath) async{
    audioCache = AudioCache(fixedPlayer: audioPlayer);
    //audioPlayer.setUrl(assetFilePath, isLocal: true);
    await audioCache.load(assetFilePath);
  }
}