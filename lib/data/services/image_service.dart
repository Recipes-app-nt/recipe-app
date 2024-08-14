import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as path;

class ImageService {
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  Future<String?> uploadMedia(String filePath) async {
    try {
      print("================FIrebase Storage ishladi========================");
      // Faylni yuklash uchun kerakli ma'lumotlarni olish
      final fileName = path.basename(filePath);
      final file = File(filePath);

      print("===================Basenamedan o'tdi");

      // Yuklash jarayonini amalga oshirish
      final uploadTask = _firebaseStorage.ref(fileName).putFile(file);

      print("=====================UPLOADDAN HAM OTDI==============");

      // Yuklashning holatini tekshirish
      final snapshot = await uploadTask.whenComplete(() => {});
      final downloadUrl = await snapshot.ref.getDownloadURL();

      print(
          "====================Malumotrar muovvafaqiyatl saqlandi $downloadUrl");

      return downloadUrl;
    } catch (e) {
      print(
          "===================================Faylni yuklashda xato yuz berdi: $e");
      return null;
    }
  }
}
