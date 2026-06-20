import 'package:flutter/material.dart';
import '../config/app_colors.dart';
import '../models/avatar_mau.dart';

class AvatarWidget extends StatelessWidget {
  final String? avatarId;
  final double size;
  final VoidCallback? onTap;
  final bool showBadge;

  const AvatarWidget({
    super.key,
    required this.avatarId,
    this.size = 36,
    this.onTap,
    this.showBadge = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = _getAvatarColor(avatarId);

    return GestureDetector(
      onTap: onTap, // Dùng onTap đơn giản, không cần onTapDown/Up
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.4),
              blurRadius: size * 0.3,
              spreadRadius: size * 0.05,
            ),
            BoxShadow(
              color: color.withOpacity(0.15),
              blurRadius: size * 0.5,
              spreadRadius: size * 0.1,
            ),
          ],
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Lớp viền ngoài (gradient)
            Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  center: const Alignment(-0.3, -0.3),
                  radius: 0.8,
                  colors: [
                    color.withOpacity(0.9),
                    color,
                    color.withOpacity(0.7),
                  ],
                ),
              ),
            ),
            // Lớp viền giữa (sáng)
            Container(
              width: size - 4,
              height: size - 4,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white.withOpacity(0.6),
                    Colors.white.withOpacity(0.1),
                  ],
                ),
              ),
            ),
            // Lớp nội dung chính
            Container(
              width: size - 8,
              height: size - 8,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              child: CircleAvatar(
                radius: size / 2 - 4,
                backgroundColor: color.withOpacity(0.12),
                child: Icon(
                  _getAvatarIcon(avatarId),
                  size: size * 0.45,
                  color: color,
                ),
              ),
            ),
            // Badge camera (chỉ hiển thị khi showBadge = true)
            if (showBadge)
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  width: size * 0.32,
                  height: size * 0.32,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white,
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.4),
                        blurRadius: 6,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.camera_alt,
                    size: size * 0.16,
                    color: Colors.white,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  IconData _getAvatarIcon(String? avatarId) {
    final avatar = AvatarMau.danhSachMau().firstWhere(
          (a) => a.id == avatarId,
      orElse: () => AvatarMau.danhSachMau()[0],
    );
    return avatar.icon;
  }

  Color _getAvatarColor(String? avatarId) {
    final avatar = AvatarMau.danhSachMau().firstWhere(
          (a) => a.id == avatarId,
      orElse: () => AvatarMau.danhSachMau()[0],
    );
    return avatar.mauSac;
  }
}