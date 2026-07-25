import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../config/app_colors.dart';
import '../models/cau_hoi.dart';
import '../models/cau_tra_loi.dart';
import '../services/cau_hoi_service.dart';
import 'dangnhap_screen.dart';

class CauHoiDetailScreen extends StatefulWidget {
  final CauHoi cauHoi;

  const CauHoiDetailScreen({super.key, required this.cauHoi});

  @override
  State<CauHoiDetailScreen> createState() => _CauHoiDetailScreenState();
}

class _CauHoiDetailScreenState extends State<CauHoiDetailScreen> {
  final CauHoiService _cauHoiService = CauHoiService();
  final TextEditingController _traLoiController = TextEditingController();
  bool _dangDangTraLoi = false;

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: const Text(
              'Chi tiết câu hỏi',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            backgroundColor: AppColors.surface,
            foregroundColor: AppColors.textPrimary,
            elevation: 0,
            centerTitle: false,
            leading: Padding(
              padding: const EdgeInsets.only(left: 8),
              child: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new, size: 20),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),

          SliverToBoxAdapter(child: _buildCauHoiSection()),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 12), // Căn chỉnh padding khớp với giao diện
              child: Row(
                children: [
                  // Icon nhỏ bên trái
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.chat_bubble_outline, size: 14, color: AppColors.primary),
                  ),
                  const SizedBox(width: 10),
                  // Dòng chữ tiêu đề
                  const Text(
                    'Câu trả lời',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Đường kẻ mảnh chạy dài sang phải cho đẹp
                  Expanded(
                    child: Container(
                      height: 1,
                      color: AppColors.border.withOpacity(0.5),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // --- BẮT ĐẦU SỬA: DÙNG STREAM TỪ FIRESTORE ---
          StreamBuilder<List<CauTraLoi>>(
            stream: _cauHoiService.layDanhSachTraLoi(widget.cauHoi.id),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return SliverToBoxAdapter(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Text(
                        'Lỗi chi tiết:\n${snapshot.error}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                  ),
                );
              }

              if (!snapshot.hasData) {
                return const SliverFillRemaining(
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              final danhSach = snapshot.data!;

              if (danhSach.isEmpty) {
                return SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 60, left: 20, right: 20, bottom: 20),
                    child: Column(
                      children: [
                        // 1. Hero Graphic: Icon lớn, nền gradient bừng sáng có bóng đổ mạnh
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                AppColors.primary,
                                AppColors.accent,
                                const Color(0xFF82B1FF), // Màu xanh sáng hơn
                              ],
                            ),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primary.withOpacity(0.5),
                                blurRadius: 30,
                                offset: const Offset(0, 15), // Bóng đổ sâu và lan rộng
                              ),
                            ],
                          ),
                          // Dùng icon ngôi sao hoặc bong bóng với nét vẽ dày
                          child: const Icon(
                            Icons.auto_awesome_rounded,
                            size: 50,
                            color: Colors.white,
                          ),
                        ),

                        const SizedBox(height: 40),

                        // 2. Nổi bật Tiêu đề: Màu tối đậm, to rõ
                        const Text(
                          '✨ Chưa có câu trả lời nào!',
                          style: TextStyle(
                            fontSize: 24, // To hơn
                            fontWeight: FontWeight.w900, // Đậm hơn nữa
                            color: Color(0xFF0F172A), // Màu than chì đậm nhất
                            letterSpacing: -0.5,
                          ),
                        ),

                        const SizedBox(height: 16),

                        // 3. Mô tả phụ nhẹ nhàng hơn
                        const Text(
                          'Hãy là người tiên phong mang đến \ncâu trả lời chất lượng cho cộng đồng!',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            height: 1.6,
                            color: Color(0xFF475569), // Màu xám đậm hơn chút để đọc rõ
                          ),
                        ),

                        const SizedBox(height: 40),

                        // 4. Một cái "Tip nhỏ" (Lời khuyên) có nền màu vàng nhạt để nổi bật
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFFBE6), // Nền vàng nhạt
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: const Color(0xFFFFF0B3), width: 1),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.lightbulb_outline, color: Color(0xFFD97706), size: 18),
                              const SizedBox(width: 12),
                              const Text(
                                'Chia sẻ kiến thức của bạn ngay bây giờ!',
                                style: TextStyle(
                                  color: Color(0xFF92400E),
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }

              return SliverList(
                delegate: SliverChildBuilderDelegate(
                      (context, index) {
                    final traLoi = danhSach[index];
                    return _buildTraLoiCard(traLoi);
                  },
                  childCount: danhSach.length,
                ),
              );
            },
          ),
          // --- HẾT SỬA ---

          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
      bottomSheet: _buildAnswerInput(),
    );
  }

  // --- GIỮ NGUYÊN CÁC HÀM UI CŨ (CHỈ CẦN CHECK LẠI XEM CÓ ĐÚNG TÊN FILE KHÔNG) ---
  Widget _buildCauHoiSection() {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    widget.cauHoi.hoTenNguoiDung[0].toUpperCase(),
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.cauHoi.hoTenNguoiDung,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                    Text(
                      _formatTime(widget.cauHoi.ngayTao),
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textTertiary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            widget.cauHoi.tieuDe,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            widget.cauHoi.noiDung,
            style: TextStyle(
              fontSize: 15,
              height: 1.5,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTraLoiCard(CauTraLoi traLoi) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppColors.accent.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    traLoi.hoTenNguoiDung[0].toUpperCase(),
                    style: TextStyle(
                      color: AppColors.accentDark,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      traLoi.hoTenNguoiDung,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      _formatTime(traLoi.ngayTao),
                      style: TextStyle(
                        fontSize: 11,
                        color: AppColors.textTertiary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            traLoi.noiDung,
            style: TextStyle(
              fontSize: 14,
              height: 1.5,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnswerInput() {
    final user = FirebaseAuth.instance.currentUser;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(24),
              ),
              child: TextField(
                controller: _traLoiController,
                decoration: InputDecoration(
                  hintText: 'Viết câu trả lời của bạn...',
                  hintStyle: TextStyle(color: AppColors.textTertiary),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
                maxLines: 3,
                minLines: 1,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            decoration: BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              onPressed: () async {
                if (user == null) {
                  _yeuCauDangNhap();
                  return;
                }
                if (_traLoiController.text.trim().isEmpty) return;

                setState(() => _dangDangTraLoi = true);
                try {
                  await _cauHoiService.themTraLoi(
                    widget.cauHoi.id,
                    _traLoiController.text.trim(),
                  );
                  _traLoiController.clear();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Đã gửi câu trả lời!')),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Lỗi: $e')),
                  );
                } finally {
                  setState(() => _dangDangTraLoi = false);
                }
              },
              icon: _dangDangTraLoi
                  ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                  : const Icon(Icons.send, color: Colors.white, size: 18),
            ),
          ),
        ],
      ),
    );
  }

  void _yeuCauDangNhap() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Cần đăng nhập'),
        content: const Text('Vui lòng đăng nhập để trả lời câu hỏi.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Để sau'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const DangNhapScreen()),
              );
            },
            style: TextButton.styleFrom(foregroundColor: AppColors.primary),
            child: const Text('Đăng nhập'),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final diff = now.difference(dateTime);

    if (diff.inHours < 1) {
      return '${diff.inMinutes} phút trước';
    } else if (diff.inDays < 1) {
      return '${diff.inHours} giờ trước';
    } else if (diff.inDays < 7) {
      return '${diff.inDays} ngày trước';
    } else {
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    }
  }

  @override
  void dispose() {
    _traLoiController.dispose();
    super.dispose();
  }
}