import 'package:flutter/material.dart';
import '../../config/app_colors.dart';
import 'admin_camnang_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'admin_hoi_dap_screen.dart';
import 'admin_nguoi_dung_screen.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  // Dữ liệu thống kê (tạm thời dùng mock)
  int _tongNguoiDung = 0;
  int _tongBaiViet = 0;
  int _tongCauHoi = 0;
  bool _dangTai = true;
  int _tabDangChon = 0;
  @override
  void initState() {
    super.initState();
    _layDuLieuThongKe();
  }

  // Hàm lấy dữ liệu từ Firestore
  Future<void> _layDuLieuThongKe() async {
    try {
      // Lấy tổng số người dùng
      final nguoiDung = await FirebaseFirestore.instance
          .collection('nguoi_dung')
          .count()
          .get();

      // Lấy tổng số bài viết
      final baiViet = await FirebaseFirestore.instance
          .collection('cam_nang')
          .count()
          .get();

      // Lấy tổng số câu hỏi
      final cauHoi = await FirebaseFirestore.instance
          .collection('cau_hoi')
          .count()
          .get();

      setState(() {
        _tongNguoiDung = nguoiDung.count ?? 0;
        _tongBaiViet = baiViet.count ?? 0;
        _tongCauHoi = cauHoi.count ?? 0;
        _dangTai = false;
      });
    } catch (e) {
      print('Lỗi lấy dữ liệu: $e');
      setState(() {
        _dangTai = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Row(
        children: [
          // Sidebar (sẽ tách riêng sau)
          _buildSidebar(),
          // Nội dung chính
          Expanded(
            child: Column(
              children: [
                _buildHeader(),
                Expanded(
                  child: _dangTai
                      ? const Center(child: CircularProgressIndicator())
                      : _buildContent(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ===== SIDEBAR =====
  Widget _buildSidebar() {
    return Container(
      width: 260,
      color: const Color(0xFF0D47A1),
      child: Column(
        children: [
          const SizedBox(height: 30),
          // Logo
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.admin_panel_settings, color: Colors.white, size: 28),
              SizedBox(width: 10),
              Text(
                'Lotus Admin',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 30),
          // Menu
          _buildMenuItem(
            Icons.dashboard,
            'Tổng quan',
            _tabDangChon == 0,
            index: 0,
          ),
          _buildMenuItem(Icons.book, 'Cẩm nang', _tabDangChon == 1, index: 1),
          _buildMenuItem(
            Icons.question_answer,
            'Hỏi đáp',
            _tabDangChon == 2,
            index: 2,
          ),
          _buildMenuItem(
            Icons.people,
            'Người dùng',
            _tabDangChon == 3,
            index: 3,
          ),
          const Spacer(),
          // Nút đăng xuất ở cuối
          _buildMenuItem(Icons.logout, 'Đăng xuất', false, isLogout: true),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildMenuItem(
    IconData icon,
    String label,
    bool isActive, {
    bool isLogout = false,
    int index = 0,
  }) {
    return ListTile(
      leading: Icon(icon, color: isLogout ? Colors.red : Colors.white70),
      title: Text(
        label,
        style: TextStyle(
          color: isLogout
              ? Colors.red
              : (isActive ? Colors.white : Colors.white70),
          fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      tileColor: isActive ? Colors.white.withOpacity(0.15) : null,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      onTap: () {
        if (isLogout) {
        } else {
          setState(() {
            _tabDangChon = index;
          });
        }
      },
    );
  }

  // ===== HEADER =====
  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 16),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Tổng quan',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          Row(
            children: [
              // Tên Admin
              const Text(
                'Xin chào, Admin',
                style: TextStyle(color: Color(0xFF64748B)),
              ),
              const SizedBox(width: 16),
              // Avatar
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFF0D47A1).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.person, color: Color(0xFF0D47A1)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ===== NỘI DUNG CHÍNH =====
  Widget _buildContent() {
    switch (_tabDangChon) {
      case 0:
        return _buildDashboardContent();
      case 1:
        return _buildCamNangContent();
      case 2:
        return _buildHoiDapContent();
      case 3:
        return _buildNguoiDungContent();
      default:
        return _buildDashboardContent();
    }
  }

  Widget _buildCamNangContent() {
    return const AdminCamNangScreen();
  }

  Widget _buildHoiDapContent() {
    return const AdminHoiDapScreen();
  }

  Widget _buildNguoiDungContent() {
    return const AdminNguoiDungScreen();
  }

  // Card thống kê
  Widget _buildStatCard(String label, int count, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
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
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    color: Color(0xFF64748B),
                    fontSize: 14,
                  ),
                ),
                Text(
                  '$count',
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E293B),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboardContent() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 3 Card thống kê
          Row(
            children: [
              _buildStatCard(
                'Người dùng',
                _tongNguoiDung,
                Icons.people,
                const Color(0xFF0D47A1),
              ),
              const SizedBox(width: 20),
              _buildStatCard(
                'Bài viết',
                _tongBaiViet,
                Icons.book,
                const Color(0xFF2E7D32),
              ),
              const SizedBox(width: 20),
              _buildStatCard(
                'Câu hỏi',
                _tongCauHoi,
                Icons.question_answer,
                const Color(0xFFE65100),
              ),
            ],
          ),
          const SizedBox(height: 30),

          // Hoạt động gần đây
          const Text(
            'Hoạt động gần đây',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ListView(
                children: const [
                  ListTile(
                    leading: Icon(Icons.person_add, color: Color(0xFF0D47A1)),
                    title: Text('15 người dùng mới'),
                    subtitle: Text('Hôm nay, 14:30'),
                  ),
                  ListTile(
                    leading: Icon(Icons.help, color: Color(0xFFE65100)),
                    title: Text('8 câu hỏi mới'),
                    subtitle: Text('Hôm nay, 10:15'),
                  ),
                  ListTile(
                    leading: Icon(Icons.edit, color: Color(0xFF2E7D32)),
                    title: Text('3 bài viết mới'),
                    subtitle: Text('Hôm qua, 20:45'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
