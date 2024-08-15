import 'package:equatable/equatable.dart';

// VideoEvent - Videolar bilan bog'liq bo'lgan hodisalarni aniqlash uchun ishlatiladi
abstract class VideoEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadVideos extends VideoEvent {
  final List<String> videoUrls;

  LoadVideos(this.videoUrls);

  @override
  List<Object> get props => [videoUrls];
}
