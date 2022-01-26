import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';

/// Defines extensions for [AudioPlayer].
// ignore: prefer-match-file-name
extension AudioPlayerX on AudioPlayer {
  /// Replays the current audio.
  Future<void> replay() async {
    await stop();
    await seek(null);
    unawaited(play());
  }

  /// use until just_audio fixes asset path
  Future<Duration?> fixedSetAsset(
    String assetPath, {
    bool preload = true,
    Duration? initialPosition,
  }) =>
      setAudioSource(
        AudioSource.uri(Uri.parse((kReleaseMode ? 'assets/' : '') + assetPath)),
        initialPosition: initialPosition,
        preload: preload,
      );
}
