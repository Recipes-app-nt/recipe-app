import 'package:equatable/equatable.dart';
import 'package:video_player/video_player.dart';

// VideoState - VideoPlayerController holatini ifodalaydi
class VideoState extends Equatable {
  final List<VideoPlayerController> controllers;
  final int? playingIndex; // Nullable to represent no video playing

  VideoState(this.controllers, {this.playingIndex});

  @override
  List<Object?> get props => [controllers, playingIndex];
}

