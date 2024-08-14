import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as path;
import 'package:image/image.dart' as img;
import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';

class ImageService {
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  final FlutterFFmpeg _flutterFFmpeg = FlutterFFmpeg();

  Future<String?> uploadMedia(String filePath, {required String mediaType}) async {
    try {
      print("================FIrebase Storage ishladi========================");

      final file = File(filePath);
      File compressedFile;

      // Media turini tekshirish va compress qilish
      if (mediaType == 'image') {
        compressedFile = await compressImage(file);
      } else if (mediaType == 'video') {
        compressedFile = await compressVideo(file);
      } else {
        throw Exception('Unsupported media type');
      }

      // Faylni yuklash uchun kerakli ma'lumotlarni olish
      final fileName = path.basename(compressedFile.path);
      print("===================Basenamedan o'tdi");

      // Yuklash jarayonini amalga oshirish
      final uploadTask = _firebaseStorage.ref(fileName).putFile(compressedFile);
      print("=====================UPLOADDAN HAM OTDI==============");

      // Yuklashning holatini tekshirish
      final snapshot = await uploadTask.whenComplete(() => {});
      final downloadUrl = await snapshot.ref.getDownloadURL();
      print("====================Malumotrar muovvafaqiyatl saqlandi $downloadUrl");

      return downloadUrl;
    } catch (e) {
      print("===================================Faylni yuklashda xato yuz berdi: $e");
      return null;
    }
  }

  Future<File> compressImage(File file) async {
    final img.Image? image = img.decodeImage(await file.readAsBytes());
    if (image == null) {
      throw Exception('Failed to decode image');
    }
    final img.Image resizedImage = img.copyResize(image, width: 800);
    final compressedFile = File('${path.dirname(file.path)}/compressed_${path.basename(file.path)}');
    await compressedFile.writeAsBytes(img.encodeJpg(resizedImage, quality: 75));
    return compressedFile;
  }

  Future<File> compressVideo(File file) async {
    final fileName = path.basenameWithoutExtension(file.path);
    final fileExtension = path.extension(file.path);
    final compressedFilePath = '${path.dirname(file.path)}/compressed_${fileName}_compressed$fileExtension';
    final command = '-i ${file.path} -vcodec libx264 -crf 28 $compressedFilePath';
    final result = await _flutterFFmpeg.execute(command);
    if (result != 0) {
      throw Exception('Failed to compress video');
    }
    return File(compressedFilePath);
  }
}
