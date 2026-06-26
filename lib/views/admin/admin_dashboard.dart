import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'admin_camnang_screen.dart';
import 'admin_hoi_dap_screen.dart';
import 'admin_nguoi_dung_screen.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
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

  Future<void> _layDuLieuThongKe() async {
    try {
      final nguoiDung = await FirebaseFirestore.instance
          .collection('nguoi_dung')
          .count()
          .get();
      final baiViet = await FirebaseFirestore.instance
          .collection('cam_nang')
          .count()
          .get();
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
          _buildSidebar(),
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
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [const Color(0xFF0F4C81), const Color(0xFF0D3B6B)],
        ),
      ),
      child: Column(
        children: [
          const SizedBox(height: 30),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.auto_awesome, color: Colors.cyanAccent, size: 28),
              SizedBox(width: 10),
              Text(
                'Lotus',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 30),
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
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      decoration: BoxDecoration(
        color: isActive ? Colors.white.withOpacity(0.1) : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: isLogout
              ? Colors.red
              : (isActive ? Colors.white : const Color(0xFF94A3B8)),
        ),
        title: Text(
          label,
          style: TextStyle(
            color: isLogout
                ? Colors.red
                : (isActive ? Colors.white : const Color(0xFF94A3B8)),
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        onTap: () {
          if (isLogout) {
            // TODO: Xử lý đăng xuất
          } else {
            setState(() {
              _tabDangChon = index;
            });
          }
        },
      ),
    );
  }

  // ===== HEADER =====
  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 16),
      color: Colors.transparent,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Tổng quan',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E293B),
            ),
          ),
          Row(
            children: [
              const Text(
                'Xin chào, Admin',
                style: TextStyle(color: Color(0xFF64748B)),
              ),
              const SizedBox(width: 16),
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [const Color(0xFF0F4C81), const Color(0xFF0D3B6B)],
                  ),
                ),
                child: const Icon(Icons.person, color: Colors.white, size: 20),
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
        return const AdminCamNangScreen();
      case 2:
        return const AdminHoiDapScreen();
      case 3:
        return const AdminNguoiDungScreen();
      default:
        return _buildDashboardContent();
    }
  }

  // ===== DASHBOARD CONTENT =====
  Widget _buildDashboardContent() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Cột trái (60%)
          Expanded(
            flex: 6,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 3 Card thống kê
                Row(
                  children: [
                    Expanded(
                      child: _buildStatCard(
                        label: 'Người dùng',
                        count: _tongNguoiDung,
                        icon: Icons.people,
                        color: const Color(0xFF0F4C81),
                        growth: '+12.4%',
                        trend: 'up',
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildStatCard(
                        label: 'Bài viết',
                        count: _tongBaiViet,
                        icon: Icons.article,
                        color: const Color(0xFF059669),
                        growth: '+4.1%',
                        trend: 'up',
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildStatCard(
                        label: 'Câu hỏi',
                        count: _tongCauHoi,
                        icon: Icons.help,
                        color: const Color(0xFFEA580C),
                        growth: 'Stable',
                        trend: 'neutral',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Hoạt động gần đây - Timeline
                Expanded(child: _buildTimeline()),
              ],
            ),
          ),

          // Cột phải (40%)
          const SizedBox(width: 24),
          Expanded(
            flex: 4,
            child: Column(
              children: [
                // Quick Analytics Chart
                _buildAnalyticsChart(),
                const SizedBox(height: 16),
                // Top Contributors
                _buildTopContributors(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ===== STAT CARD =====
  Widget _buildStatCard({
    required String label,
    required int count,
    required IconData icon,
    required Color color,
    required String growth,
    required String trend,
  }) {
    final isUp = trend == 'up';
    final isNeutral = trend == 'neutral';

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.center, // Căn giữa theo chiều dọc
        children: [
          // Icon container - căn giữa hoàn hảo
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [color, color.withOpacity(0.7)],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: Colors.white, size: 24),
          ),
          const SizedBox(width: 16), // Khoảng cách cố định 16px
          // Text block - căn dọc hoàn hảo
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment:
                  MainAxisAlignment.center, // Căn giữa theo chiều dọc
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    color: Color(0xFF64748B),
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '$count',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E293B),
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 4),
                // Growth pill
                if (!isNeutral)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: (isUp ? Colors.green : Colors.red).withOpacity(
                        0.1,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          isUp ? Icons.trending_up : Icons.trending_down,
                          size: 12,
                          color: isUp ? Colors.green : Colors.red,
                        ),
                        const SizedBox(width: 2),
                        Text(
                          growth,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: isUp ? Colors.green : Colors.red,
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      growth,
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF64748B),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ===== TIMELINE =====
  Widget _buildTimeline() {
    final List<Map<String, dynamic>> activities = [
      {
        'title': '15 người dùng mới',
        'time': 'Hôm nay, 14:30',
        'icon': Icons.person_add,
        'color': const Color(0xFF0F4C81),
      },
      {
        'title': '8 câu hỏi mới',
        'time': 'Hôm nay, 10:15',
        'icon': Icons.help,
        'color': const Color(0xFFEA580C),
      },
      {
        'title': '3 bài viết mới',
        'time': 'Hôm qua, 20:45',
        'icon': Icons.edit,
        'color': const Color(0xFF059669),
      },
    ];

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Hoạt động gần đây',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.separated(
              itemCount: activities.length,
              // KHÔNG CÓ divider ngang
              separatorBuilder: (_, __) => const SizedBox(height: 20),
              itemBuilder: (context, index) {
                final item = activities[index];
                final isLast = index == activities.length - 1;

                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Cột trái: đường line + node
                    SizedBox(
                      width: 40,
                      child: Column(
                        children: [
                          // Node tròn
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: item['color'].withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              item['icon'],
                              color: item['color'],
                              size: 20,
                            ),
                          ),
                          // Đường line dọc (không có cho item cuối)
                          if (!isLast)
                            Container(
                              width: 2,
                              height: 20,
                              color: const Color(0xFFE2E8F0),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 14),

                    // Cột phải: nội dung
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item['title'],
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF1E293B),
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              item['time'],
                              style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xFF94A3B8),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // ===== ANALYTICS CHART =====
  Widget _buildAnalyticsChart() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Phân bổ người dùng',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 16),

          // Center: Doughnut chart
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Doughnut chart
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFFE2E8F0),
                        width: 2,
                      ),
                    ),
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: CustomPaint(
                            painter: _ArcPainter(
                              color: const Color(0xFF0F4C81),
                              startAngle: 0,
                              sweepAngle: 252,
                            ),
                          ),
                        ),
                        Positioned.fill(
                          child: CustomPaint(
                            painter: _ArcPainter(
                              color: const Color(0xFFEF4444),
                              startAngle: 252,
                              sweepAngle: 108,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Text(
                    '100',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 24),

              // Legend - căn giữa theo chiều dọc
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLegendItem('User', const Color(0xFF0F4C81), 70),
                  const SizedBox(height: 8),
                  _buildLegendItem('Admin', const Color(0xFFEF4444), 30),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color, int percent) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          '$label $percent%',
          style: const TextStyle(
            fontSize: 13,
            color: Color(0xFF475569),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  // ===== TOP CONTRIBUTORS =====
  Widget _buildTopContributors() {
    final List<Map<String, dynamic>> contributors = [
      {
        'name': 'Nguyễn Văn A',
        'role': 'Admin',
        'color': const Color(0xFF0F4C81),
      },
      {'name': 'Trần Thị B', 'role': 'User', 'color': const Color(0xFF059669)},
      {'name': 'Lê Văn C', 'role': 'User', 'color': const Color(0xFFEA580C)},
    ];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Đóng góp nổi bật',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 12),
          ...contributors.map((item) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: item['color'].withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        item['name'][0],
                        style: TextStyle(
                          color: item['color'],
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
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
                          item['name'],
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF1E293B),
                          ),
                        ),
                        Text(
                          item['role'],
                          style: const TextStyle(
                            fontSize: 11,
                            color: Color(0xFF94A3B8),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}

// ===== CUSTOM PAINTER CHO DOUGHNUT CHART =====
class _ArcPainter extends CustomPainter {
  final Color color;
  final double startAngle;
  final double sweepAngle;

  const _ArcPainter({
    required this.color,
    required this.startAngle,
    required this.sweepAngle,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 16
      ..strokeCap = StrokeCap.butt;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius - 8),
      startAngle * 3.14159 / 180,
      sweepAngle * 3.14159 / 180,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
