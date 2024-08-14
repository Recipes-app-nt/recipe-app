import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as path;
import 'package:image/image.dart' as img;
import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';

class ImageService {
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  Future<String?> uploadMedia(String filePath, {required String mediaType}) async {
    try {
      final file = File(filePath);
      File uploadFile;

      if (mediaType == 'image') {
        // Agar media turi rasm bo'lsa, siqish amalga oshiriladi
        uploadFile = await compressImage(file);
      } else if (mediaType == 'video') {
        // Agar media turi video bo'lsa, siqmasdan faylni yuklash uchun tayyorlanadi
        uploadFile = file;
      } else {
        throw Exception('Noto\'g\'ri media turi');
      }

      // Fayl nomini olish
      final fileName = path.basename(uploadFile.path);

      // Firebase Storage ga yuklash
      final uploadTask = _firebaseStorage.ref(fileName).putFile(uploadFile);

      // Yuklash tugashi bilan download URL ni olish
      final snapshot = await uploadTask.whenComplete(() => {});
      final downloadUrl = await snapshot.ref.getDownloadURL();

      print("Media muvaffaqiyatli yuklandi: $downloadUrl");
      return downloadUrl;
    } catch (e) {
      print("Faylni yuklashda xato yuz berdi: $e");
      return null;
    }
  }

  Future<File> compressImage(File file) async {
    // Rasmni o'qish
    final img.Image? image = img.decodeImage(await file.readAsBytes());
    if (image == null) {
      throw Exception('Rasmni dekodlashda xato');
    }

    // Rasmni o'lchamini kichraytirish
    final img.Image resizedImage = img.copyResize(image, width: 800);

    // Siqilgan rasmni saqlash
    final compressedFile = File('${path.dirname(file.path)}/compressed_${path.basename(file.path)}');
    await compressedFile.writeAsBytes(img.encodeJpg(resizedImage, quality: 75));

    return compressedFile;
  }
}

