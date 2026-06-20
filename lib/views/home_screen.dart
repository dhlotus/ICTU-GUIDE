import 'dart:async';
import 'package:flutter/material.dart';
import '../config/app_colors.dart';
import '../widgets/bottom_nav_bar.dart';
import '../models/lich_hoc.dart';
import 'cam_nang_list_screen.dart';
import 'cau_hoi_list_screen.dart';
import 'lich_hoc_screen.dart';
import 'profile_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dangnhap_screen.dart';
import '../services/nguoi_dung_service.dart';
import '../widgets/avatar_widget.dart';

/// Màn hình Trang chủ - Thiết kế tinh gọn
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  late List<LichHoc> _lichHomNay;
  String? _avatarId;
  final NguoiDungService _nguoiDungService = NguoiDungService();
  StreamSubscription<Map<String, dynamic>?>? _userSubscription;

  @override
  void initState() {
    super.initState();
    _lichHomNay = LichHoc.getMockData('user_123').take(2).toList();
    _listionToUserChanges();
  }
  void _listionToUserChanges() {
    final user = FirebaseAuth.instance.currentUser;
    if(user == null) return;

    _userSubscription = _nguoiDungService.layThongTinNguoiDungStream().listen((data) {
      if(mounted && data != null) {
        setState(() {
          _avatarId = data['avatarId'];
        });
      }
    });
  }
  void _loadAvatarId() {
    _nguoiDungService.layAvatarId().then((id) {
      if(mounted && id != null) {
        setState(() {
          _avatarId = id;
        });
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: _buildBody(),  // Gọi hàm _buildBody
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
          if (index == 1) {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const CamNangListScreen()));
          } else if (index == 3) {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const CauHoiListScreen()));
          } else if (index == 4) {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfileScreen()));
          }
        },
      ),
    );
  }

  // ==================== HEADER ====================

  Widget _buildHeader() {
    final user = FirebaseAuth.instance.currentUser;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      decoration: BoxDecoration(
        gradient: AppColors.headerGradient,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(28),
          bottomRight: Radius.circular(28),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Hàng: thông báo + avatar (góc phải)
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // Icon thông báo
              Stack(
                children: [
                  const Icon(Icons.notifications_none, color: Colors.white, size: 24),
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: AppColors.warning,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 16),

              // Avatar (luôn hiển thị, khi bấm vào sẽ yêu cầu đăng nhập nếu chưa đăng nhập)
              // Avatar (luôn hiển thị)
              GestureDetector(
                onTap: () {
                  if (user == null) {
                    _yeuCauDangNhap();
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ProfileScreen()),
                    );
                  }
                },
                child: AvatarWidget(
                  avatarId: _avatarId,
                  size: 36,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Nội dung header
          if (user != null) ...[
            Text(
              '${user.displayName ?? 'bạn'} ! 👋',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'ICTU GUIDE',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white70,
              ),
            ),
          ] else ...[
            const Text(
              'ICTU GUIDE',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Hỗ trợ tân sinh viên ICTU',
              style: TextStyle(
                fontSize: 14,
                color: Colors.white70,
              ),
            ),
          ],
        ],
      ),
    );
  }

  // ==================== LỊCH HÔM NAY SECTION ====================

  Widget _buildLichHomNaySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header của section
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Text(
                  '📅',
                  style: TextStyle(fontSize: 22),
                ),
                const SizedBox(width: 8),
                const Text(
                  'LỊCH HÔM NAY',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
            GestureDetector(
              onTap: () {
                final user = FirebaseAuth.instance.currentUser;
                if (user == null) {
                  _yeuCauDangNhap();
                } else {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const LichHocScreen()));
                }
              },
              child: Text(
                'Xem lịch →',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.accent,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Danh sách sự kiện
        if (_lichHomNay.isEmpty)
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Center(
              child: Text(
                'Không có lịch học hôm nay',
                style: TextStyle(color: AppColors.textSecondary),
              ),
            ),
          )
        else
          ..._lichHomNay.map((lich) => _buildEventCard(lich)),
      ],
    );
  }

  Widget _buildEventCard(LichHoc lich) {
    // Xác định trạng thái sự kiện
    final now = DateTime.now();
    final isCurrent = now.isAfter(lich.thoiGianBatDau) && now.isBefore(lich.thoiGianKetThuc);
    final isUpcoming = now.isBefore(lich.thoiGianBatDau);

    Color statusColor = AppColors.success;
    String statusText = 'Hoàn thành';

    if (isCurrent) {
      statusColor = AppColors.warning;
      statusText = 'Đang diễn ra';
    } else if (isUpcoming) {
      statusColor = AppColors.primary;
      statusText = 'Sắp tới';
    }

    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => const LichHocScreen()));
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Icon trái với màu trạng thái
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Icon(
                isCurrent ? Icons.play_circle_filled : Icons.school,
                color: statusColor,
                size: 28,
              ),
            ),
            const SizedBox(width: 14),

            // Nội dung chính
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    lich.tieuDe,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(Icons.access_time, size: 12, color: AppColors.textTertiary),
                      const SizedBox(width: 4),
                      Text(
                        '${_formatTime(lich.thoiGianBatDau)} - ${_formatTime(lich.thoiGianKetThuc)}',
                        style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  if (lich.ghiChu != null)
                    Row(
                      children: [
                        Icon(Icons.location_on, size: 12, color: AppColors.textTertiary),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            lich.ghiChu!,
                            style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),

            // Badge trạng thái
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                statusText,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: statusColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildQuickAccessGrid() {
    return Row(
      children: [
        // Cẩm nang
        _buildQuickCard(
          icon: Icons.book,
          label: 'Cẩm nang',
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const CamNangListScreen()));
          },
        ),
        const SizedBox(width: 14),

        // Lịch biểu (ĐIỂM NHẤN)
        _buildHighlightCard(
          icon: Icons.schedule,
          label: 'Thời gian biểu',
          onTap: _showSchedulePopup,
        ),
        const SizedBox(width: 14),

        // Hỏi đáp
        _buildQuickCard(
          icon: Icons.question_answer,
          label: 'Hỏi đáp',
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const CauHoiListScreen()));
          },
        ),
      ],
    );
  }

  Widget _buildHighlightCard({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 18),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [AppColors.primary, AppColors.accent],
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.4),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              Icon(icon, color: Colors.white, size: 32),
              const SizedBox(height: 10),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  void _showSchedulePopup() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      isScrollControlled: true,
      builder: (context) => SafeArea(
        child: DraggableScrollableSheet(
          initialChildSize: 0.6,
          minChildSize: 0.4,
          maxChildSize: 0.9,
          expand: false,
          builder: (context, scrollController) {
            return Column(
              children: [
                // Thanh kéo
                Container(
                  margin: const EdgeInsets.only(top: 12),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.border,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 16),

                // Tiêu đề
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Icon(Icons.schedule, color: AppColors.primary),
                      SizedBox(width: 8),
                      Text(
                        'Thời gian biểu',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Bảng thời gian biểu
                Expanded(
                  child: ListView(
                    controller: scrollController,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    children: [
                      // Header bảng
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Row(
                          children: [
                            SizedBox(width: 50, child: Text('Tiết', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                            Expanded(child: Text('Giờ vào', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                            Expanded(child: Text('Giờ ra', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Các dòng dữ liệu
                      _buildScheduleRow(1, '6:45', '7:35'),
                      _buildScheduleRow(2, '7:40', '8:30'),
                      _buildScheduleRow(3, '8:40', '9:30'),
                      _buildScheduleRow(4, '9:40', '10:30'),
                      _buildScheduleRow(5, '10:35', '11:25'),
                      _buildScheduleRow(6, '13:00', '13:50'),
                      _buildScheduleRow(7, '13:55', '14:45'),
                      _buildScheduleRow(8, '14:55', '15:45'),
                      _buildScheduleRow(9, '15:55', '16:45'),
                      _buildScheduleRow(10, '16:50', '17:40'),
                      _buildScheduleRow(11, '18:15', '19:05'),
                      _buildScheduleRow(12, '19:10', '20:00'),
                      _buildScheduleRow(13, '20:05', '20:55'),
                      _buildScheduleRow(14, '20:20', '21:10'),
                      _buildScheduleRow(15, '21:20', '22:10'),
                    ],
                  ),
                ),

                const SizedBox(height: 16),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildScheduleRow(int tiet, String gioVao, String gioRa) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 50,
            child: Text(
              tiet.toString(),
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            child: Text(gioVao, style: const TextStyle(color: AppColors.textSecondary)),
          ),
          Expanded(
            child: Text(gioRa, style: const TextStyle(color: AppColors.textSecondary)),
          ),
        ],
      ),
    );
  }
  Widget _buildQuickCard({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              Icon(icon, color: AppColors.primary, size: 28),
              const SizedBox(height: 10),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  // ==================== NỔI BẬT SECTION ====================

  Widget _buildNoiBatSection() {
    final List<Map<String, dynamic>> baiVietNoiBat = [
      {'tieuDe': 'Hướng dẫn đăng ký tín chỉ', 'thoiGianDoc': '2 phút đọc', 'icon': Icons.school},
      {'tieuDe': 'Quy định đào tạo mới nhất', 'thoiGianDoc': '5 phút đọc', 'icon': Icons.description},
      {'tieuDe': 'Lịch thi học kỳ 1', 'thoiGianDoc': '1 phút đọc', 'icon': Icons.event},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header của section
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Text(
                  '🔥',
                  style: TextStyle(fontSize: 22),
                ),
                const SizedBox(width: 8),
                const Text(
                  'NỔI BẬT',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const CamNangListScreen()));
              },
              child: Text(
                'Xem tất cả →',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.accent,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Danh sách bài viết
        ...baiVietNoiBat.map((baiViet) => _buildArticleCard(baiViet)),
      ],
    );
  }

  Widget _buildArticleCard(Map<String, dynamic> baiViet) {
    return GestureDetector(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Đang phát triển')),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
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
        child: Row(
          children: [
            // Icon trái
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.08),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(baiViet['icon'], color: AppColors.primary, size: 26),
            ),
            const SizedBox(width: 14),

            // Nội dung chính
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    baiViet['tieuDe'],
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    baiViet['thoiGianDoc'],
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textTertiary,
                    ),
                  ),
                ],
              ),
            ),

            // Chevron right
            Icon(Icons.chevron_right, color: AppColors.textTertiary, size: 20),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
  Widget _buildBody() {
    final user = FirebaseAuth.instance.currentUser;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),

          // 3 Quick Actions (Cẩm nang, Bản đồ, Hỏi đáp)
          _buildQuickAccessGrid(),

          const SizedBox(height: 32),

          // Ô LỊCH HỌC (luôn hiển thị, khi bấm vào yêu cầu đăng nhập nếu chưa)
          _buildLichHocCard(),

          const SizedBox(height: 32),

          // Section: NỔI BẬT
          _buildNoiBatSection(),

          const SizedBox(height: 40),
        ],
      ),
    );
  }
  Widget _buildLichHocCard() {
    final user = FirebaseAuth.instance.currentUser;

    return GestureDetector(
      onTap: () {
        if (user == null) {
          _yeuCauDangNhap();
        } else {
          Navigator.push(context, MaterialPageRoute(builder: (_) => const LichHocScreen()));
        }
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.primary, AppColors.primaryLight],
          ),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(Icons.calendar_today, color: Colors.white, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Lịch nhắc',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    user == null
                        ? 'Đăng nhập để xem lịch học của bạn'
                        : 'Xem thời khóa biểu và quản lý lịch',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.white, size: 24),
          ],
        ),
      ),
    );
  }
  void _yeuCauDangNhap() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Cần đăng nhập'),
        content: const Text('Vui lòng đăng nhập để sử dụng tính năng này.'),
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
            style: TextButton.styleFrom(
              foregroundColor: AppColors.primary,
            ),
            child: const Text('Đăng nhập'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _userSubscription?.cancel();
    super.dispose();
  }
}