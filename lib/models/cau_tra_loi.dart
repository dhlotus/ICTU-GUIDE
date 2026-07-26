import 'package:cloud_firestore/cloud_firestore.dart';

class CauTraLoi {
  final String id;
  final String cauHoiId;
  final String nguoiDungId;
  final String noiDung;
  final DateTime ngayTao;
  final bool huuIch;

  CauTraLoi({
    required this.id,
    required this.cauHoiId,
    required this.nguoiDungId,
    required this.noiDung,
    required this.ngayTao,
    this.huuIch = false,
  });

  factory CauTraLoi.fromMap(Map<String, dynamic> map, String documentId) {
    DateTime ngayTao;
    if (map['ngayTao'] is Timestamp) {
      ngayTao = (map['ngayTao'] as Timestamp).toDate();
    } else {
      ngayTao = DateTime.tryParse(map['ngayTao'] ?? '') ?? DateTime.now();
    }

    return CauTraLoi(
      id: documentId,
      cauHoiId: map['cauHoiId'] ?? '',
      nguoiDungId: map['nguoiDungId'] ?? '',
      noiDung: map['noiDung'] ?? '',
      ngayTao: ngayTao,
      huuIch: map['huuIch'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'cauHoiId': cauHoiId,
      'nguoiDungId': nguoiDungId,
      'noiDung': noiDung,
      'ngayTao': ngayTao.toIso8601String(),
      'huuIch': huuIch,
    };
  }
}