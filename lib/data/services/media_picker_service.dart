import 'package:flutter/services.dart';

class MediaPickerService {
  static const MethodChannel _platform = MethodChannel('media_picker');

  Future<String?> pickMedia(String mediaType) async {
    try {
      final String? path = await _platform
          .invokeMethod<String>('pickMedia', {"type": mediaType});
          print("--------------------------------------------Path jo'natildi $path");
      return path;
    } on PlatformException catch (e) {
      print("---------------------------------------Failed to pick media: '${e.message}'.");
      return null;
    }
  }
}
