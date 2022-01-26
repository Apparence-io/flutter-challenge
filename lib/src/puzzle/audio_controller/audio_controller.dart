import 'dart:async';

import 'package:flutter_puzzle_hack/src/puzzle/helpers/audio_player.dart';
import 'package:just_audio/just_audio.dart';

class AudioController {
  AudioController({
    required this.themeFolder,
  });

  final String themeFolder;
  final _tileSoundPlayer = AudioPlayer();
  final _musicPlayer = AudioPlayer();

  bool _isTileSoundOn = true;
  bool get isTileSoundOn => _isTileSoundOn;

  bool _isMusicOn = true;
  bool get isMusicOn => _isMusicOn;
  final double _musicVolume = 0.04;

  Future<void> load() async {
    await _tileSoundPlayer.fixedSetAsset('$themeFolder/audio/pop.wav');
    await _musicPlayer.fixedSetAsset('$themeFolder/audio/music.mp3');
    await _tileSoundPlayer.setVolume(isTileSoundOn ? 1 : 0);
    await _musicPlayer.setVolume(_isMusicOn ? _musicVolume : 0);
    await _musicPlayer.setLoopMode(LoopMode.one);
  }

  /// Toggle tile sound
  bool toggleTileSound() {
    _isTileSoundOn = !_isTileSoundOn;
    unawaited(_tileSoundPlayer.setVolume(_isTileSoundOn ? 1 : 0));

    return _isTileSoundOn;
  }

  /// Play Tile Pop
  Future<void> playTileSound() async {
    await _tileSoundPlayer.replay();
  }

  /// Toggle Music
  bool toggleMusic() {
    _isMusicOn = !_isMusicOn;
    unawaited(_musicPlayer.setVolume(_isMusicOn ? _musicVolume : 0));

    return _isMusicOn;
  }

  /// Play Music
  Future<void> playMusic() async {
    if (_musicPlayer.playing) return;
    await _musicPlayer.replay();
  }

  /// Dispose
  Future<void> dispose() async {
    await _tileSoundPlayer.dispose();
    await _musicPlayer.dispose();
  }
}
