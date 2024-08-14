import 'dart:io';
import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';
import 'package:image/image.dart' as img;
import 'package:path/path.dart' as path;

Future<File> compressImage(File file) async {
  final img.Image? image = img.decodeImage(await file.readAsBytes());

  if (image == null) {
    throw Exception("Xatolik rasm mavud emas!");
  }

  final img.Image resizedImage = img.copyResize(image, width: 800);

  final compressedFile = File('${path.dirname(file.path)}/compressed_${path.basename(file.path)}');
  await compressedFile.writeAsBytes(img.encodeJpg(resizedImage, quality: 75));

  return compressedFile;
}


final FlutterFFmpeg _flutterFFmpeg = FlutterFFmpeg();

Future<File> compressVideo(File file) async {
  final fileName = path.basenameWithoutExtension(file.path);
  final fileExtension = path.extension(file.path);
  final compressedFilePath = '${path.dirname(file.path)}/compressed_${fileName}_compressed$fileExtension';

  // Video compress qilish komanda
  final command = '-i ${file.path} -vcodec libx264 -crf 28 $compressedFilePath';

  final result = await _flutterFFmpeg.execute(command);

  if (result != 0) {
    throw Exception('Failed to compress video');
  }

  return File(compressedFilePath);
}

