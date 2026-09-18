import 'package:flutter/material.dart';
import '../config/app_colors.dart';
import '../models/cam_nang.dart';
import 'cam_nang_detail_screen.dart';
import '../services/cam_nang_service.dart';

class CamNangListScreen extends StatefulWidget {
  const CamNangListScreen({super.key});

  @override
  State<CamNangListScreen> createState() => _CamNangListScreenState();
}

class _CamNangListScreenState extends State<CamNangListScreen> {
  String _tuKhoaTimKiem = '';
  int _danhMucDangChon = 0;
  final CamNangService _camNangService = CamNangService();

  final List<Map<String, dynamic>> _danhSachDanhMuc = [
    {'ten': 'Tất cả', 'icon': Icons.apps},
    {'ten': 'Đào tạo', 'icon': Icons.school},
    {'ten': 'Học phí', 'icon': Icons.attach_money},
    {'ten': 'Ký túc', 'icon': Icons.home},
    {'ten': 'Sự kiện', 'icon': Icons.celebration},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: RefreshIndicator(
        onRefresh: () async {
          // Khi kéo xuống, nó chỉ cần gọi hàm này để báo hiệu đã refresh
          // StreamBuilder sẽ tự động load lại dữ liệu từ Firebase
          await Future.delayed(const Duration(milliseconds: 500));
        },
        child: CustomScrollView(
          slivers: [
            _buildSliverHeader(),
            _buildSliverSearchBar(),
            _buildSliverDanhMuc(),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
                child: Text(
                  'Danh sách bài viết',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.textTertiary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            // --- Phần StreamBuilder ---
            StreamBuilder<List<CamNang>>(
              stream: _camNangService.layDanhSachCamNang(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return SliverToBoxAdapter(
                    child: SizedBox(
                      height: 300,
                      child: Center(child: Text('Lỗi tải dữ liệu: ${snapshot.error}')),
                    ),
                  );
                }

                if (!snapshot.hasData) {
                  return const SliverFillRemaining(
                    child: Center(child: CircularProgressIndicator()),
                  );
                }

                var danhSach = snapshot.data!;

                // Lọc theo danh mục
                if (_danhMucDangChon != 0) {
                  String tenDanhMuc = _danhSachDanhMuc[_danhMucDangChon]['ten'];
                  danhSach = danhSach.where((baiViet) {
                    if (baiViet.danhMuc == null) return false;
                    return baiViet.danhMuc!.toLowerCase() == tenDanhMuc.toLowerCase();
                  }).toList();
                }

                // Lọc theo từ khóa
                if (_tuKhoaTimKiem.isNotEmpty) {
                  danhSach = danhSach.where((baiViet) {
                    return baiViet.tieuDe.toLowerCase().contains(_tuKhoaTimKiem.toLowerCase());
                  }).toList();
                }

                if (danhSach.isEmpty) {
                  return const SliverToBoxAdapter(
                    child: SizedBox(
                      height: 300,
                      child: Center(child: Text('Không tìm thấy bài viết')),
                    ),
                  );
                }

                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                        (context, index) {
                      final baiViet = danhSach[index];
                      return _buildBaiVietCard(baiViet);
                    },
                    childCount: danhSach.length,
                  ),
                );
              },
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 30)),
          ],
        ),
      ),
    );
  }

  // Các hàm UI cũ giữ nguyên y hệt
  Widget _buildSliverHeader() {
    return SliverAppBar(
      expandedHeight: 100,
      pinned: true,
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
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsets.only(left: 56, bottom: 12),
        title: const Text('Cẩm nang sinh viên', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [AppColors.surface, AppColors.background],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSliverSearchBar() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 12, offset: const Offset(0, 2)),
            ],
          ),
          child: TextField(
            onChanged: (value) => setState(() => _tuKhoaTimKiem = value),
            decoration: InputDecoration(
              hintText: 'Tìm kiếm bài viết...',
              hintStyle: TextStyle(color: AppColors.textTertiary),
              prefixIcon: Icon(Icons.search, color: AppColors.textTertiary),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 14),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSliverDanhMuc() {
    return SliverToBoxAdapter(
      child: SizedBox(
        height: 50,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          itemCount: _danhSachDanhMuc.length,
          separatorBuilder: (_, __) => const SizedBox(width: 12),
          itemBuilder: (context, index) {
            final danhMuc = _danhSachDanhMuc[index];
            final isSelected = index == _danhMucDangChon;
            return GestureDetector(
              onTap: () => setState(() => _danhMucDangChon = index),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary : Colors.transparent,
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: isSelected ? Colors.transparent : AppColors.border, width: 1.2),
                ),
                child: Row(
                  children: [
                    Icon(danhMuc['icon'], size: 18, color: isSelected ? Colors.white : AppColors.textSecondary),
                    const SizedBox(width: 8),
                    Text(
                      danhMuc['ten'],
                      style: TextStyle(
                        color: isSelected ? Colors.white : AppColors.textSecondary,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // Hàm hiển thị Popup chi tiết bài viết (Hiệu ứng Zoom ở giữa màn hình)
  void _hienThiPopupChiTiet(CamNang baiViet) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true, // Cho phép ấn ra ngoài để đóng
      barrierLabel: 'Đóng',
      barrierColor: Colors.black.withOpacity(0.5), // Nền tối mờ 50%
      transitionDuration: const Duration(milliseconds: 300), // Thời gian chạy hiệu ứng
      pageBuilder: (context, animation, secondaryAnimation) {
        return const SizedBox.shrink(); // Không dùng pageBuilder, chỉ dùng transitionBuilder
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        // Hiệu ứng Zoom: Từ 0.8 -> 1.0 (phóng to dần) khi hiện
        // và 1.0 -> 0.8 khi ẩn
        final curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutBack, // Hiệu ứng hơi nảy nhẹ khi xuất hiện
        );

        return ScaleTransition(
          scale: Tween<double>(begin: 0.8, end: 1.0).animate(curvedAnimation),
          child: FadeTransition(
            opacity: animation, // Mờ dần khi xuất hiện
            child: Dialog(
              // Cấu hình hộp thoại
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(28),
              ),
              insetPadding: const EdgeInsets.symmetric(horizontal: 20), // Cách 2 bên 20px
              child: Container(
                constraints: BoxConstraints(
                  // Chiều cao tối đa 80% màn hình, tự co giãn theo nội dung
                  maxHeight: MediaQuery.of(context).size.height * 0.8,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(28),
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min, // Chiều cao co giãn theo nội dung
                    children: [
                      // 1. Header Row: Chip "Cẩm nang" bên trái, nút X bên phải
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: const Color(0xFFEFF6FF),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                Icon(Icons.menu_book_rounded, size: 16, color: Color(0xFF0284C7)),
                                SizedBox(width: 6),
                                Text(
                                  'Cẩm nang',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF0284C7),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Container(
                              width: 36,
                              height: 36,
                              decoration: const BoxDecoration(
                                color: Color(0xFFF8FAFC),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.close, size: 20, color: Color(0xFF64748B)),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // 2. Tiêu đề
                      Text(
                        _capitalizeTitle(baiViet.tieuDe),
                        style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF0F172A),
                          height: 1.25,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // 3. Meta Data
                      Row(
                        children: [
                          const Icon(Icons.calendar_today_outlined, size: 15, color: Color(0xFF94A3B8)),
                          const SizedBox(width: 6),
                          Text(
                            _formatDate(baiViet.ngayTao),
                            style: const TextStyle(color: Color(0xFF64748B), fontSize: 14, fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(width: 16),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFF7ED),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.access_time, size: 13, color: Color(0xFFEA580C)),
                                const SizedBox(width: 4),
                                Text(
                                  '${_thoiGianDoc(baiViet.noiDung)} phút đọc',
                                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFFEA580C)),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),
                      const Divider(height: 1, color: Color(0xFFF1F5F9)),
                      const SizedBox(height: 20),

                      // 4. Nội dung
                      Text(
                        baiViet.noiDung,
                        style: const TextStyle(
                          fontSize: 16,
                          height: 1.65,
                          color: Color(0xFF334155),
                          wordSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
  Widget _buildBaiVietCard(CamNang baiViet) {
    return GestureDetector(
      onTap: () {
        _hienThiPopupChiTiet(baiViet);
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 12, offset: const Offset(0, 4))],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                _hienThiPopupChiTiet(baiViet);
              },
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 70,
                          height: 70,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [AppColors.primary, AppColors.accent],
                            ),
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: const Icon(Icons.menu_book, color: Colors.white, size: 32),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                baiViet.tieuDe,
                                style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, height: 1.3),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  Icon(Icons.access_time, size: 12, color: AppColors.textTertiary),
                                  const SizedBox(width: 4),
                                  Text(
                                    _formatDate(baiViet.ngayTao),
                                    style: TextStyle(fontSize: 11, color: AppColors.textTertiary),
                                  ),
                                  const SizedBox(width: 12),
                                  Icon(Icons.visibility, size: 12, color: AppColors.textTertiary),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${baiViet.luotXem}',
                                    style: TextStyle(fontSize: 11, color: AppColors.textTertiary),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      baiViet.noiDung,
                      style: TextStyle(fontSize: 13, color: AppColors.textSecondary, height: 1.4),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.accent.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.local_offer, size: 10, color: AppColors.accent),
                          const SizedBox(width: 4),
                          Text(
                            'Đào tạo',
                            style: TextStyle(fontSize: 11, color: AppColors.accentDark, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
  // Hàm ước tính thời gian đọc dựa trên số từ trong nội dung
  int _thoiGianDoc(String noiDung) {
    // Đếm số từ bằng cách tách chuỗi theo khoảng trắng
    final soTu = noiDung.split(' ').length;
    // Ước tính 200 từ/phút, làm tròn lên
    final phutDoc = (soTu / 200).ceil();
    // Đảm bảo tối thiểu là 1 phút
    return phutDoc > 0 ? phutDoc : 1;
  }
  // Hàm viết hoa chữ cái đầu mỗi từ trong tiêu đề
  String _capitalizeTitle(String input) {
    if (input.isEmpty) return input;
    List<String> words = input.split(' ');
    for (int i = 0; i < words.length; i++) {
      if (words[i].isNotEmpty) {
        words[i] = words[i][0].toUpperCase() + words[i].substring(1);
      }
    }
    return words.join(' ');
  }
}