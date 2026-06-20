import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

/// Model Lịch học import
class LichHocImport {
  final String id;
  final String tenMon;
  final int thuTrongTuan;
  final int tietBatDau;
  final int tietKetThuc;
  final String diaDiem;
  final String nguon;
  final DateTime ngayHoc;

  // Thêm 2 field mới để lưu giờ trực tiếp (dùng cho thủ công)
  final DateTime? thoiGianBatDau;
  final DateTime? thoiGianKetThuc;

  LichHocImport({
    required this.id,
    required this.tenMon,
    required this.thuTrongTuan,
    required this.tietBatDau,
    required this.tietKetThuc,
    required this.diaDiem,
    required this.nguon,
    required this.ngayHoc,
    this.thoiGianBatDau,
    this.thoiGianKetThuc,
  });

  /// Lấy giờ bắt đầu (ưu tiên dùng thoiGianBatDau nếu có)
  DateTime get gioBatDau {
    if (thoiGianBatDau != null) return thoiGianBatDau!;
    return _timeFromTiet(tietBatDau, ngayHoc);
  }

  /// Lấy giờ kết thúc (ưu tiên dùng thoiGianKetThuc nếu có)
  DateTime get gioKetThuc {
    if (thoiGianKetThuc != null) return thoiGianKetThuc!;
    return _timeFromTiet(tietKetThuc, ngayHoc);
  }

  String get thoiGianHienThi {
    return '${_formatTime(gioBatDau)} - ${_formatTime(gioKetThuc)}';
  }

  static DateTime _timeFromTiet(int tiet, DateTime ngay) {
    final time = _getTimeFromTiet(tiet);
    return DateTime(
      ngay.year,
      ngay.month,
      ngay.day,
      time.hour,
      time.minute,
    );
  }

  static TimeOfDay _getTimeFromTiet(int tiet) {
    switch (tiet) {
      case 1: return const TimeOfDay(hour: 6, minute: 45);
      case 2: return const TimeOfDay(hour: 7, minute: 40);
      case 3: return const TimeOfDay(hour: 8, minute: 40);
      case 4: return const TimeOfDay(hour: 9, minute: 40);
      case 5: return const TimeOfDay(hour: 10, minute: 35);
      case 6: return const TimeOfDay(hour: 13, minute: 0);
      case 7: return const TimeOfDay(hour: 13, minute: 55);
      case 8: return const TimeOfDay(hour: 14, minute: 55);
      case 9: return const TimeOfDay(hour: 15, minute: 55);
      case 10: return const TimeOfDay(hour: 16, minute: 50);
      default: return const TimeOfDay(hour: 0, minute: 0);
    }
  }

  static String _formatTime(DateTime time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  factory LichHocImport.fromMap(Map<String, dynamic> map, String documentId) {
    return LichHocImport(
      id: documentId,
      tenMon: map['tieuDe'] ?? '',
      thuTrongTuan: map['thuTrongTuan'] ?? 0,
      tietBatDau: map['tietBatDau'] ?? 0,
      tietKetThuc: map['tietKetThuc'] ?? 0,
      diaDiem: map['ghiChu'] ?? '',
      nguon: map['nguon'] ?? 'manual',
      ngayHoc: (map['ngayHoc'] as Timestamp?)?.toDate() ?? DateTime.now(),
      thoiGianBatDau: (map['thoiGianBatDau'] as Timestamp?)?.toDate(),
      thoiGianKetThuc: (map['thoiGianKetThuc'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'tieuDe': tenMon,
      'thuTrongTuan': thuTrongTuan,
      'tietBatDau': tietBatDau,
      'tietKetThuc': tietKetThuc,
      'ghiChu': diaDiem,
      'nguon': nguon,
      'ngayHoc': ngayHoc,
      if (thoiGianBatDau != null) 'thoiGianBatDau': thoiGianBatDau,
      if (thoiGianKetThuc != null) 'thoiGianKetThuc': thoiGianKetThuc,
    };
  }
}