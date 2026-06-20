import 'package:flutter/material.dart';
import '../config/app_colors.dart';
import '../models/cam_nang.dart';

/// Màn hình chi tiết bài viết - Thiết kế như Medium
class CamNangDetailScreen extends StatelessWidget {
  final CamNang baiViet;

  const CamNangDetailScreen({super.key, required this.baiViet});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // AppBar co giãn với ảnh bìa
          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            leading: Padding(
              padding: const EdgeInsets.only(left: 8),
              child: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new, size: 20),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [AppColors.primary, AppColors.primaryLight],
                  ),
                ),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    // Ảnh bìa (demo)
                    Container(
                      color: AppColors.primary,
                      child: const Icon(
                        Icons.menu_book,
                        color: Colors.white70,
                        size: 80,
                      ),
                    ),
                    // Gradient mờ phía dưới để chữ nổi
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      height: 120,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(0.6),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Nội dung bài viết
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Tiêu đề
                  Text(
                    baiViet.tieuDe,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Hàng thông tin tác giả và ngày đăng
                  Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.person, color: AppColors.primary),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Bùi Đức Hà',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${_formatDate(baiViet.ngayTao)} • ${_thoiGianDoc(baiViet.noiDung)} phút đọc',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.textTertiary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const Divider(height: 32),

                  // Nội dung chi tiết
                  Text(
                    baiViet.noiDung,
                    style: TextStyle(
                      fontSize: 16,
                      height: 1.6,
                      color: AppColors.textSecondary,
                    ),
                  ),

                  const SizedBox(height: 40),

                  // Phần tương tác (like, share)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildActionButton(Icons.favorite_border, 'Hữu ích'),
                      const SizedBox(width: 40),
                      _buildActionButton(Icons.share, 'Chia sẻ sdklgjdskljg'),
                    ],
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(IconData icon, String label) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.surface,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 8,
              ),
            ],
          ),
          child: Icon(icon, color: AppColors.primary, size: 24),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(fontSize: 12, color: AppColors.textTertiary),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  int _thoiGianDoc(String noiDung) {
    // Ước tính: 200 từ/phút
    final soTu = noiDung.split(' ').length;
    final phutDoc = (soTu / 200).ceil();
    return phutDoc > 0 ? phutDoc : 1;
  }
}