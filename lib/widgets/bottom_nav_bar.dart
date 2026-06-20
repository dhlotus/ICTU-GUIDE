import 'package:flutter/material.dart';
import '../config/app_colors.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: AppColors.primary,
      unselectedItemColor: AppColors.textSecondary,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Trang chủ',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.book),
          label: 'Cẩm nang',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.map),
          label: 'Bản đồ',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.question_answer),
          label: 'Hỏi đáp',
        ),
      ],
    );
  }
}