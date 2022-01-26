import 'package:just_audio/just_audio.dart';

class AudioController {
  final _audioPlayerTile = AudioPlayer();
  final _audioPlayerMusic = AudioPlayer();

  bool _isAudibleTile = true;
  bool get isAudibleTile => _isAudibleTile;

  bool _isAudibleMusic = true;
  bool get isAudibleMusic => _isAudibleMusic;
  double volumeMusic = 0.04;

  Future<void> loadTheme(String theme) async {
    await _audioPlayerTile.setAsset('$theme/audio/pop.wav');
    await _audioPlayerMusic.setAsset('$theme/audio/music.mp3');
    await _audioPlayerMusic.setVolume(volumeMusic);
  }

  /// Toggle Tile Sound on/off
  bool toggleSoundTile() {
    _isAudibleTile = !_isAudibleTile;
    _audioPlayerTile.setVolume(_isAudibleTile ? 1 : 0).ignore();

    return _isAudibleTile;
  }

  /// Play Tile Pop
  Future<void> playAudioTilePop() async {
    await _audioPlayerTile.stop();
    await _audioPlayerTile.seek(null);
    await _audioPlayerTile.play();
  }

  /// Toggle Music on/off
  bool toggleSoundMusic() {
    _isAudibleMusic = !_isAudibleMusic;
    _audioPlayerMusic.setVolume(_isAudibleMusic ? volumeMusic : 0).ignore();

    return _isAudibleMusic;
  }

  /// Play Music
  Future<void> playAudioMusic() async {
    await _audioPlayerMusic.stop();
    await _audioPlayerMusic.seek(null);
    await _audioPlayerMusic.setLoopMode(LoopMode.one);
    await _audioPlayerMusic.play();
  }

  /// Dispose
  Future<void> dispose() async {
    await _audioPlayerTile.dispose();
    await _audioPlayerMusic.dispose();
  }
}
