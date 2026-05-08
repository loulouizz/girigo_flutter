import 'package:audioplayers/audioplayers.dart';

class AudioplayerSingleton {

  final AudioPlayer player;

  AudioplayerSingleton._privateConstructor() : player = AudioPlayer();

  static final AudioplayerSingleton instance = AudioplayerSingleton._privateConstructor();

}
