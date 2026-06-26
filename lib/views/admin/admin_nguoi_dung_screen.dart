import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'form_phan_quyen.dart';

class AdminNguoiDungScreen extends StatefulWidget {
  const AdminNguoiDungScreen({super.key});

  @override
  State<AdminNguoiDungScreen> createState() => _AdminNguoiDungScreenState();
}

class _AdminNguoiDungScreenState extends State<AdminNguoiDungScreen> {
  String _tuKhoaTim = '';
  String _boLocChon = 'Tất cả';

  final List<String> _danhSachBoLoc = ['Tất cả', 'User', 'Admin'];

  Stream<QuerySnapshot> _getStreamNguoiDung() {
    Query query = FirebaseFirestore.instance
        .collection('nguoi_dung')
        .orderBy('email');
    return query.snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header với thống kê
            _buildHeader(),
            const SizedBox(height: 24),

            // Thanh tìm kiếm + filter chips
            _buildSearchAndFilter(),
            const SizedBox(height: 20),

            // Danh sách người dùng
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _getStreamNguoiDung(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(child: Text('Lỗi: ${snapshot.error}'));
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  var danhSach = snapshot.data?.docs ?? [];

                  // Lọc theo từ khóa
                  if (_tuKhoaTim.isNotEmpty) {
                    danhSach = danhSach.where((doc) {
                      final data = doc.data() as Map<String, dynamic>;
                      final email = data['email'] ?? '';
                      return email.toLowerCase().contains(
                        _tuKhoaTim.toLowerCase(),
                      );
                    }).toList();
                  }

                  // Lọc theo vai trò
                  if (_boLocChon != 'Tất cả') {
                    danhSach = danhSach.where((doc) {
                      final data = doc.data() as Map<String, dynamic>;
                      final vaiTro = data['vaiTro'] ?? 'guest';
                      return _getVaiTroText(vaiTro) == _boLocChon;
                    }).toList();
                  }

                  if (danhSach.isEmpty) {
                    return const Center(
                      child: Text('Không tìm thấy người dùng nào'),
                    );
                  }

                  return ListView.builder(
                    itemCount: danhSach.length,
                    itemBuilder: (context, index) {
                      final doc = danhSach[index];
                      final data = doc.data() as Map<String, dynamic>;
                      return _buildUserCard(doc.id, data);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ===== HEADER =====
  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Quản lý Người dùng',
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1E293B),
          ),
        ),
        // Badge thống kê
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: const Color(0xFF0D47A1).withOpacity(0.08),
            borderRadius: BorderRadius.circular(20),
          ),
          child: StreamBuilder<QuerySnapshot>(
            stream: _getStreamNguoiDung(),
            builder: (context, snapshot) {
              final total = snapshot.data?.docs.length ?? 0;
              return Text(
                'Tổng: $total người dùng',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF0D47A1),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // ===== SEARCH & FILTER =====
  Widget _buildSearchAndFilter() {
    return Row(
      children: [
        // Search
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
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
                  _tuKhoaTim = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'Tìm kiếm theo email...',
                prefixIcon: const Icon(Icons.search, color: Color(0xFF94A3B8)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(
                    color: Color(0xFFE2E8F0),
                    width: 1,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(
                    color: Color(0xFFE2E8F0),
                    width: 1,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(
                    color: Color(0xFF0D47A1),
                    width: 1.5,
                  ),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
                isDense: true,
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),

        // Filter chips
        ..._danhSachBoLoc.map((loc) {
          final isSelected = _boLocChon == loc;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(loc),
              selected: isSelected,
              onSelected: (_) {
                setState(() {
                  _boLocChon = loc;
                });
              },
              backgroundColor: Colors.white,
              selectedColor: const Color(0xFF0D47A1).withOpacity(0.1),
              labelStyle: TextStyle(
                color: isSelected
                    ? const Color(0xFF0D47A1)
                    : const Color(0xFF64748B),
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                fontSize: 13,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(
                  color: isSelected
                      ? const Color(0xFF0D47A1)
                      : const Color(0xFFE2E8F0),
                  width: 1,
                ),
              ),
            ),
          );
        }),
      ],
    );
  }

  // ===== USER CARD =====
  Widget _buildUserCard(String userId, Map<String, dynamic> data) {
    final email = data['email'] ?? 'Không có email';
    final vaiTro = data['vaiTro'] ?? 'guest';
    final tenHienThi = data['tenHienThi'] ?? email.split('@')[0];

    // Lấy tên viết tắt cho avatar
    final String avatarText = tenHienThi.isNotEmpty
        ? tenHienThi[0].toUpperCase()
        : '?';

    // Xử lý ngày tạo
    String ngayTaoStr = 'Chưa có';
    if (data['ngayTao'] != null) {
      final date = (data['ngayTao'] as Timestamp).toDate();
      ngayTaoStr = '${date.day}/${date.month}/${date.year}';
    }

    // Màu sắc cho avatar
    final Color avatarColor = _getAvatarColor(vaiTro);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 20,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Avatar
          Stack(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [avatarColor, avatarColor.withOpacity(0.6)],
                  ),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    avatarText,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 16),

          // Thông tin
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tenHienThi,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  email,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF64748B),
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    // Badge vai trò
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: _getVaiTroColor(vaiTro).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        _getVaiTroText(vaiTro),
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: _getVaiTroColor(vaiTro),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                  ],
                ),
              ],
            ),
          ),

          // Nút hành động
          Row(
            children: [
              OutlinedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => FormPhanQuyen(
                      userId: userId,
                      emailHienTai: email,
                      vaiTroHienTai: vaiTro,
                    ),
                  );
                },
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFFE2E8F0)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  foregroundColor: const Color(0xFF0D47A1),
                ),
                child: const Text(
                  'Phân quyền',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                onPressed: () {
                  // TODO: Menu 3 chấm (Block, Delete, Change Role)
                },
                icon: const Icon(Icons.more_vert, color: Color(0xFF94A3B8)),
                tooltip: 'Thêm tùy chọn',
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Helper: Lấy tên vai trò
  String _getVaiTroText(String vaiTro) {
    switch (vaiTro) {
      case 'admin':
        return 'Admin';
      default:
        return 'User';
    }
  }

  // Helper: Lấy màu cho vai trò
  Color _getVaiTroColor(String vaiTro) {
    switch (vaiTro) {
      case 'admin':
        return Colors.red;
      default:
        return const Color(0xFF0D47A1); // Màu xanh cho User
    }
  }

  // Helper: Lấy màu avatar
  Color _getAvatarColor(String vaiTro) {
    switch (vaiTro) {
      case 'admin':
        return const Color(0xFFEF4444); // Đỏ cho Admin
      default:
        return const Color(0xFF0D47A1); // Xanh cho User
    }
  }
}
