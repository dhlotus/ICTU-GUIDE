import 'package:flutter/material.dart';
import '../config/app_colors.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  // Hàm mở link cải tiến
  Future<void> _openLink(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      print('Không thể mở link: $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Nền trắng tinh khiết
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        leading: Padding(
          padding: const EdgeInsets.only(left: 8),
          child: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, size: 20, color: AppColors.textPrimary),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        title: const Text(
          'Giới thiệu',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 1. THE HERO SECTION (App Branding)
            // App Icon (Squircle shape với bóng đổ mềm mại)
            // Logo App
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  'assets/logo.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 22),

            // Typography: App Name
            const Text(
              'ICTU Guide',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: Color(0xFF0F172A), // Obsidian đậm
              ),
            ),
            const SizedBox(height: 4),

            // Typography: Subtitle
            const Text(
              'Hỗ trợ sinh viên ICTU',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Color(0xFF64748B), // Slate Gray
              ),
            ),
            const SizedBox(height: 12),

            // Version Badge (Pill shape, xanh nhạt)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFE0F2FE), // Light blue background
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'Phiên bản 1.0.0',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF0284C7), // Vibrant blue text
                ),
              ),
            ),

            const SizedBox(height: 32), // 32px spacing giữa Hero và Card đầu tiên

            // 2. INFORMATION CARDS (Grouped List Style)
            // Card 1: Nhà phát triển
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC), // Soft off-white nền cho card
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20), // Padding 16/20
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Group Header
                    Row(
                      children: [
                        Icon(Icons.person_outline, size: 20, color: AppColors.primary),
                        const SizedBox(width: 12),
                        const Text(
                          'Nhà phát triển',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Row 1: Họ tên
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        children: [
                          SizedBox(width: 32), // Căn thẳng hàng với icon bên trên
                          Text(
                            'Họ tên',
                            style: TextStyle(fontSize: 14, color: Color(0xFF64748B)),
                          ),
                          SizedBox(width: 12),
                          Text(
                            'Bùi Đức Hà',
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.textPrimary),
                          ),
                        ],
                      ),
                    ),

                    // Divider mảnh, không chạy hết chiều rộng
                    const Padding(
                      padding: EdgeInsets.only(left: 32, top: 8, bottom: 8),
                      child: Divider(height: 1, color: Color(0xFFE2E8F0)),
                    ),

                    // Row 2: Email (Hành động)
                    InkWell(
                      onTap: () => _openLink('mailto:buiducha2k5@gmail.com'),
                      borderRadius: BorderRadius.circular(8),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          children: [
                            const SizedBox(width: 32),
                            const Text(
                              'Email',
                              style: TextStyle(fontSize: 14, color: Color(0xFF64748B)),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'buiducha2k5@gmail.com',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.primary, // Primary blue cho hành động
                                ),
                              ),
                            ),
                            const Icon(Icons.chevron_right, size: 16, color: Color(0xFF94A3B8)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24), // 24px spacing giữa các card

            // Card 2: Liên kết
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Group Header
                    Row(
                      children: [
                        Icon(Icons.link, size: 20, color: AppColors.primary),
                        const SizedBox(width: 12),
                        const Text(
                          'Liên kết',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Row: Facebook (Hành động)
                    InkWell(
                      onTap: () => _openLink('https://www.facebook.com/bdh.lotus'),
                      borderRadius: BorderRadius.circular(8),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          children: [
                            const SizedBox(width: 32), // Căn lề
                            const Text(
                              'Facebook',
                              style: TextStyle(fontSize: 14, color: Color(0xFF64748B)),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'Bùi Đức Hà',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                            const Icon(Icons.chevron_right, size: 16, color: Color(0xFF94A3B8)),
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () => _openLink('https://www.tiktok.com/@_sgbdha__'),
                      borderRadius: BorderRadius.circular(8),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          children: [
                            const SizedBox(width: 32), // Căn lề
                            const Text(
                              'TikTok',
                              style: TextStyle(fontSize: 14, color: Color(0xFF64748B)),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                '@_sgbdha__',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                            const Icon(Icons.chevron_right, size: 16, color: Color(0xFF94A3B8)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Card 3: Về ứng dụng
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Group Header
                    Row(
                      children: [
                        Icon(Icons.info_outline, size: 20, color: AppColors.primary),
                        const SizedBox(width: 12),
                        const Text(
                          'Về ứng dụng',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Mô tả mục đích
                    const Text(
                      'Hành trình đại học sẽ tuyệt vời hơn khi bạn có một trợ lý số đắc lực. '
                          'ICTU Guide ra đời với sứ mệnh giúp sinh viên ICTU tự tin làm chủ không gian học thuật, '
                          'đặc biệt xóa tan những bỡ ngỡ ban đầu của các bạn tân sinh viên. '
                          'Ứng dụng tích hợp các công cụ: Cẩm nang sinh viên, Bản đồ khuôn viên, Hỏi đáp cộng đồng và Đặt lịch nhắc công việc, mang đến cho bạn một nhịp sống sinh viên dễ dàng và trọn vẹn nhất.',
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                        fontSize: 15,
                        height: 1.6,
                        color: Color(0xFF475569),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Mục Chính sách bảo mật (Tạo cảm giác chuyên nghiệp)
                    const Divider(height: 1, color: Color(0xFFE2E8F0)),
                    const SizedBox(height: 8),

                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}