import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NguoiDungService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Lấy thông tin người dùng từ Firestore
  Future<Map<String, dynamic>?> layThongTinNguoiDung() async {
    final user = _auth.currentUser;
    if (user == null) return null;

    final doc = await _firestore.collection('nguoi_dung').doc(user.uid).get();
    if (doc.exists) {
      return doc.data();
    }
    return null;
  }

  /// Cập nhật avatar (lưu URL vào Firestore)
  Future<void> capNhatAvatar(String urlAvatar) async {
    final user = _auth.currentUser;
    if (user == null) return;

    await _firestore.collection('nguoi_dung').doc(user.uid).set({
      'avatarUrl': urlAvatar,
      'email': user.email,
      'tenHienThi': user.displayName,
      'capNhatLuc': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  /// Lấy URL avatar từ Firestore
  Future<String?> layAvatarUrl() async {
    final user = _auth.currentUser;
    if (user == null) return null;

    final doc = await _firestore.collection('nguoi_dung').doc(user.uid).get();
    if (doc.exists && doc.data()!.containsKey('avatarUrl')) {
      final url = doc.data()!['avatarUrl'];
      if (url is String && url.isNotEmpty) {
        return url;
      }
    }
    return null;
  }
  /// Cập nhật tên hiển thị
  Future<void> capNhatTenHienThi(String tenMoi) async {
    final user = _auth.currentUser;
    if (user == null) return;

    await _firestore.collection('nguoi_dung').doc(user.uid).set({
      'tenHienThi': tenMoi,
      'email': user.email,
      'capNhatLuc': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }
  /// Lắng nghe thông tin người dùng thay đổi (realtime)
  Stream<Map<String, dynamic>?> layThongTinNguoiDungStream() {
    final user = _auth.currentUser;
    if (user == null) return Stream.value(null);

    return _firestore
        .collection('nguoi_dung')
        .doc(user.uid)
        .snapshots()
        .map((doc) => doc.exists ? doc.data() : null);
  }
  /// Cập nhật ID avatar (chọn từ bộ icon)
  Future<void> capNhatAvatarId(String avatarId) async {
    final user = _auth.currentUser;
    if (user == null) return;

    await _firestore.collection('nguoi_dung').doc(user.uid).set({
      'avatarId': avatarId,
      'email': user.email,
      'tenHienThi': user.displayName,
      'capNhatLuc': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  /// Lấy ID avatar từ Firestore
  Future<String?> layAvatarId() async {
    final user = _auth.currentUser;
    if (user == null) return null;

    final doc = await _firestore.collection('nguoi_dung').doc(user.uid).get();
    if (doc.exists && doc.data()!.containsKey('avatarId')) {
      return doc.data()!['avatarId'];
    }
    return null;
  }
}