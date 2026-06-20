import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Upload ảnh đại diện lên Firebase Storage
  Future<String?> uploadAvatar(File imageFile) async {
    final user = _auth.currentUser;
    if (user == null) return null;

    try {
      // Tạo tên file duy nhất theo uid
      final fileName = 'avatars/${user.uid}.jpg';
      final ref = _storage.ref().child(fileName);

      // Upload file
      await ref.putFile(imageFile);

      // Lấy URL download
      final downloadUrl = await ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print('Lỗi upload ảnh: $e');
      return null;
    }
  }
}