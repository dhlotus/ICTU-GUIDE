import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../config/app_colors.dart';
import '../services/cau_hoi_service.dart';
import '../models/cau_hoi.dart';
import 'cau_hoi_detail_screen.dart';
import 'them_cau_hoi_screen.dart';
import 'dangnhap_screen.dart';

/// Màn hình danh sách câu hỏi - Kết nối Firestore
class CauHoiListScreen extends StatefulWidget {
  const CauHoiListScreen({super.key});

  @override
  State<CauHoiListScreen> createState() => _CauHoiListScreenState();
}

class _CauHoiListScreenState extends State<CauHoiListScreen> {
  final CauHoiService _cauHoiService = CauHoiService();
  String _tuKhoaTimKiem = '';
  int _boLocDangChon = 0;

  final List<Map<String, dynamic>> _danhSachBoLoc = [
    {'ten': 'Mới nhất', 'icon': Icons.access_time},
    {'ten': 'Phổ biến', 'icon': Icons.trending_up},
    {'ten': 'Chưa giải đáp', 'icon': Icons.help_outline},
  ];

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          _buildSliverHeader(),
          _buildSliverSearchBar(),
          _buildSliverBoLoc(),

          // Danh sách câu hỏi từ Firestore
          StreamBuilder<List<CauHoi>>(
            stream: _cauHoiService.layDanhSachCauHoi(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return SliverToBoxAdapter(
                  child: Center(child: Text('Lỗi: ${snapshot.error}')),
                );
              }

              if (!snapshot.hasData) {
                return const SliverFillRemaining(
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              var danhSach = snapshot.data!;

              // Lọc theo từ khóa
              if (_tuKhoaTimKiem.isNotEmpty) {
                danhSach = danhSach.where((cauHoi) {
                  return cauHoi.tieuDe.toLowerCase().contains(_tuKhoaTimKiem.toLowerCase()) ||
                      cauHoi.noiDung.toLowerCase().contains(_tuKhoaTimKiem.toLowerCase());
                }).toList();
              }

              // Lọc theo bộ lọc (đơn giản)
              if (_boLocDangChon == 2) {
                danhSach = danhSach.where((c) => c.trangThai == 'dang_cho').toList();
              }

              if (danhSach.isEmpty) {
                return const SliverFillRemaining(
                  child: Center(child: Text('Không có câu hỏi nào')),
                );
              }

              return SliverList(
                delegate: SliverChildBuilderDelegate(
                      (context, index) {
                    final cauHoi = danhSach[index];
                    return _buildCauHoiCard(cauHoi);
                  },
                  childCount: danhSach.length,
                ),
              );
            },
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 80)),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (user == null) {
            _yeuCauDangNhap();
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ThemCauHoiScreen()),
            );
          }
        },
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildSliverHeader() {
    return SliverAppBar(
      title: const Text(
        'Hỏi đáp cộng đồng',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 12,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: TextField(
            onChanged: (value) {
              setState(() {
                _tuKhoaTimKiem = value;
              });
            },
            decoration: InputDecoration(
              hintText: 'Tìm kiếm câu hỏi...',
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

  Widget _buildSliverBoLoc() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              ..._danhSachBoLoc.asMap().entries.map((entry) {
                final index = entry.key;
                final boLoc = entry.value;
                final isSelected = index == _boLocDangChon;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _boLocDangChon = index;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    margin: const EdgeInsets.only(right: 12),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.primary : Colors.transparent,
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(
                        color: isSelected ? Colors.transparent : AppColors.border,
                        width: 1.2,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          boLoc['icon'],
                          size: 16,
                          color: isSelected ? Colors.white : AppColors.textSecondary,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          boLoc['ten'],
                          style: TextStyle(
                            color: isSelected ? Colors.white : AppColors.textSecondary,
                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCauHoiCard(CauHoi cauHoi) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CauHoiDetailScreen(cauHoi: cauHoi),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar + tên + thời gian
              Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        cauHoi.hoTenNguoiDung.isNotEmpty
                            ? cauHoi.hoTenNguoiDung[0].toUpperCase()
                            : '?',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
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
                          cauHoi.hoTenNguoiDung,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          _formatTime(cauHoi.ngayTao),
                          style: TextStyle(
                            fontSize: 11,
                            color: AppColors.textTertiary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (cauHoi.trangThai == 'da_giai_dap')
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.success.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'Đã giải',
                        style: TextStyle(fontSize: 10, color: AppColors.success),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 12),

              // Tiêu đề
              Text(
                cauHoi.tieuDe,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),

              // Nội dung tóm tắt
              Text(
                cauHoi.noiDung,
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
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
        content: const Text('Vui lòng đăng nhập để đăng câu hỏi.'),
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
    } else {
      return '${diff.inDays} ngày trước';
    }
  }
}