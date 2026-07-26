import 'package:cloud_firestore/cloud_firestore.dart';

class CauHoi {
  final String id;
  final String nguoiDungId;
  final String tieuDe;
  final String noiDung;
  final DateTime ngayTao;
  final String trangThai;

  CauHoi({
    required this.id,
    required this.nguoiDungId,
    required this.tieuDe,
    required this.noiDung,
    required this.ngayTao,
    this.trangThai = 'dang_cho',
  });

  factory CauHoi.fromMap(Map<String, dynamic> map, String documentId) {
    DateTime ngayTao;
    if (map['ngayTao'] is Timestamp) {
      ngayTao = (map['ngayTao'] as Timestamp).toDate();
    } else {
      ngayTao = DateTime.tryParse(map['ngayTao'] ?? '') ?? DateTime.now();
    }

    return CauHoi(
      id: documentId,
      nguoiDungId: map['nguoiDungId'] ?? '',
      tieuDe: map['tieuDe'] ?? '',
      noiDung: map['noiDung'] ?? '',
      ngayTao: ngayTao,
      trangThai: map['trangThai'] ?? 'dang_cho',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nguoiDungId': nguoiDungId,
      'tieuDe': tieuDe,
      'noiDung': noiDung,
      'ngayTao': ngayTao.toIso8601String(),
      'trangThai': trangThai,
    };
  }
}