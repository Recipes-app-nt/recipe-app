import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_player/video_player.dart';
import 'video_event.dart';
import 'video_state.dart';

// VideoBloc - Videolarni yuklash va boshqarish uchun ishlatiladi
class VideoBloc extends Bloc<VideoEvent, VideoState> {
  VideoBloc() : super(VideoState([])) {
    on<LoadVideos>(_loadVideos);
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

  @override
  Future<void> close() {
    state.controllers.forEach((controller) => controller.dispose());
    return super.close();
  }
}
