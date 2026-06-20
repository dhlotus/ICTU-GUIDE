import 'package:flutter/material.dart';

/// Bảng màu theo thiết kế hiện đại 2026
class AppColors {
  // Màu chính - Xanh đặc trưng của ICTU
  static const Color primary = Color(0xFF0D47A1);
  static const Color primaryLight = Color(0xFF1565C0);
  static const Color primaryDark = Color(0xFF0A3A7A);

  // Màu accent - Xanh sáng tạo điểm nhấn
  static const Color accent = Color(0xFF4FC3F7);
  static const Color accentLight = Color(0xFF80D8FF);
  static const Color accentDark = Color(0xFF039BE5);

  // Màu nền
  static const Color background = Color(0xFFF8FAFC);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceLight = Color(0xFFF1F5F9);

  // Màu chức năng
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFF9800);
  static const Color error = Color(0xFFF44336);
  static const Color info = Color(0xFF2196F3);

  // Màu chữ
  static const Color textPrimary = Color(0xFF1E293B);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color textTertiary = Color(0xFF94A3B8);
  static const Color textInverse = Color(0xFFFFFFFF);

  // Màu border và divider
  static const Color border = Color(0xFFE2E8F0);
  static const Color divider = Color(0xFFE2E8F0);

  // Gradient cho header
  static const LinearGradient headerGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary, primaryLight],
  );

  // Glassmorphism màu nền (cho card trong suốt)
  static Color glassBackground = Colors.white.withOpacity(0.9);
}