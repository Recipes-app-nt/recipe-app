import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_player/video_player.dart';
import 'video_event.dart';
import 'video_state.dart';

// VideoBloc - Videolarni yuklash va boshqarish uchun ishlatiladi
class VideoBloc extends Bloc<VideoEvent, VideoState> {
  VideoBloc() : super(VideoState([])) {
    on<LoadVideos>(_loadVideos);
    on<PlayVideo>(_playVideo);
    on<PauseVideo>(_pauseVideo);
  }

  void _loadVideos(LoadVideos event, Emitter<VideoState> emit) async {
    List<VideoPlayerController> controllers = [];

    for (var url in event.videoUrls) {
      var controller = VideoPlayerController.networkUrl(Uri.parse(url));
      await controller.initialize();
      controllers.add(controller);
    }

    emit(VideoState(controllers));
  }

  void _playVideo(PlayVideo event, Emitter<VideoState> emit) {
    final controller = state.controllers[event.index];
    controller.play();
    emit(VideoState(List.from(state.controllers), playingIndex: event.index)); // Update playingIndex
  }

  void _pauseVideo(PauseVideo event, Emitter<VideoState> emit) {
    final controller = state.controllers[event.index];
    controller.pause();
    emit(VideoState(List.from(state.controllers), playingIndex: null)); // Reset playingIndex
  }

  @override
  Future<void> close() {
    state.controllers.forEach((controller) => controller.dispose());
    return super.close();
  }
}

