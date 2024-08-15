import 'package:equatable/equatable.dart';
import 'package:video_player/video_player.dart';

// VideoState - VideoPlayerController holatini ifodalaydi
class VideoState extends Equatable {
  final List<VideoPlayerController> controllers;

  VideoState(this.controllers);

  @override
  List<Object> get props => [controllers];
}
