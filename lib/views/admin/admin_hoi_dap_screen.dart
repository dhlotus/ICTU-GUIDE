import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../config/app_colors.dart';

class AdminHoiDapScreen extends StatefulWidget {
  const AdminHoiDapScreen({super.key});

  @override
  State<AdminHoiDapScreen> createState() => _AdminHoiDapScreenState();
}

class _AdminHoiDapScreenState extends State<AdminHoiDapScreen> {
  String _tuKhoaTim = '';
  String _trangThaiLoc = 'Tất cả';

  // Lấy danh sách câu hỏi từ Firestore
  Stream<QuerySnapshot> _getStreamCauHoi() {
    Query query = FirebaseFirestore.instance
        .collection('cau_hoi')
        .orderBy('ngayTao', descending: true);

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
            // Tiêu đề
            const Text(
              'Quản lý Hỏi đáp',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // Thanh tìm kiếm + lọc
            Row(
              children: [
                Expanded(
                  child: TextField(
                    onChanged: (value) {
                      setState(() {
                        _tuKhoaTim = value;
                      });
                    },
                    decoration: InputDecoration(
                      hintText: 'Tìm kiếm câu hỏi...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(vertical: 0),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                // Dropdown lọc trạng thái
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _trangThaiLoc,
                      items: const [
                        DropdownMenuItem(
                          value: 'Tất cả',
                          child: Text('Tất cả'),
                        ),
                        DropdownMenuItem(
                          value: 'dang_cho',
                          child: Text('Chưa giải đáp'),
                        ),
                        DropdownMenuItem(
                          value: 'da_giai_dap',
                          child: Text('Đã giải đáp'),
                        ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _trangThaiLoc = value!;
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Danh sách câu hỏi
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _getStreamCauHoi(),
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
                      final tieuDe = data['tieuDe'] ?? '';
                      final noiDung = data['noiDung'] ?? '';
                      return tieuDe.toLowerCase().contains(
                            _tuKhoaTim.toLowerCase(),
                          ) ||
                          noiDung.toLowerCase().contains(
                            _tuKhoaTim.toLowerCase(),
                          );
                    }).toList();
                  }

                  // Lọc theo trạng thái
                  if (_trangThaiLoc != 'Tất cả') {
                    danhSach = danhSach.where((doc) {
                      final data = doc.data() as Map<String, dynamic>;
                      return data['trangThai'] == _trangThaiLoc;
                    }).toList();
                  }

                  if (danhSach.isEmpty) {
                    return const Center(child: Text('Không có câu hỏi nào'));
                  }

                  return ListView.builder(
                    itemCount: danhSach.length,
                    itemBuilder: (context, index) {
                      final doc = danhSach[index];
                      final data = doc.data() as Map<String, dynamic>;
                      return _buildCauHoiCard(doc.id, data);
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

  // Card câu hỏi
  Widget _buildCauHoiCard(String id, Map<String, dynamic> data) {
    final tieuDe = data['tieuDe'] ?? 'Không có tiêu đề';
    final noiDung = data['noiDung'] ?? '';
    final nguoiDung = data['hoTenNguoiDung'] ?? 'Người dùng';
    final trangThai = data['trangThai'] ?? 'dang_cho';
    final soCauTraLoi = data['soCauTraLoi'] ?? 0;

    // Xử lý thời gian
    String thoiGian = 'Chưa có';
    if (data['ngayTao'] != null) {
      final date = (data['ngayTao'] as Timestamp).toDate();
      thoiGian =
          '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
    }

    // Màu sắc theo trạng thái
    Color statusColor = Colors.orange;
    String statusText = 'Chờ giải đáp';
    if (trangThai == 'da_giai_dap') {
      statusColor = Colors.green;
      statusText = 'Đã giải đáp';
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Hàng trên: tiêu đề + trạng thái
          Row(
            children: [
              Expanded(
                child: Text(
                  tieuDe,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  statusText,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: statusColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Nội dung
          Text(
            noiDung,
            style: const TextStyle(fontSize: 13, color: Color(0xFF64748B)),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 10),

          // Hàng thông tin: người đăng + thời gian + số câu trả lời
          Row(
            children: [
              const Icon(Icons.person, size: 14, color: Color(0xFF64748B)),
              const SizedBox(width: 4),
              Text(
                nguoiDung,
                style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)),
              ),
              const SizedBox(width: 16),
              const Icon(Icons.access_time, size: 14, color: Color(0xFF64748B)),
              const SizedBox(width: 4),
              Text(
                thoiGian,
                style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)),
              ),
              const SizedBox(width: 16),
              const Icon(Icons.message, size: 14, color: Color(0xFF64748B)),
              const SizedBox(width: 4),
              Text(
                '$soCauTraLoi trả lời',
                style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)),
              ),
              const Spacer(),
              // Nút xóa
              IconButton(
                onPressed: () {
                  _xoaCauHoi(id);
                },
                icon: const Icon(Icons.delete, color: Colors.red, size: 20),
                tooltip: 'Xóa câu hỏi',
              ),
            ],
          ),

          // Danh sách câu trả lời (nếu có)
          if (soCauTraLoi > 0) ...[
            const Divider(height: 20),
            const Text(
              '📝 Câu trả lời:',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1E293B),
              ),
            ),
            const SizedBox(height: 8),
            _buildDanhSachTraLoi(id),
          ],
        ],
      ),
    );
  }

  // Danh sách câu trả lời
  Widget _buildDanhSachTraLoi(String cauHoiId) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('cau_tra_loi')
          .where('cauHoiId', isEqualTo: cauHoiId)
          .orderBy('ngayTao', descending: false)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox.shrink();
        }

        final danhSach = snapshot.data!.docs;
        if (danhSach.isEmpty) {
          return const SizedBox.shrink();
        }

        return Column(
          children: danhSach.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            return _buildTraLoiItem(doc.id, data);
          }).toList(),
        );
      },
    );
  }

  // Mỗi câu trả lời
  Widget _buildTraLoiItem(String id, Map<String, dynamic> data) {
    final noiDung = data['noiDung'] ?? '';
    final nguoiDung = data['hoTenNguoiDung'] ?? 'Người dùng';

    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  noiDung,
                  style: const TextStyle(fontSize: 13),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  '- $nguoiDung',
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF64748B),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {
              _xoaTraLoi(id);
            },
            icon: const Icon(Icons.close, color: Colors.red, size: 16),
            tooltip: 'Xóa trả lời',
          ),
        ],
      ),
    );
  }

  // Hàm xóa câu hỏi
  Future<void> _xoaCauHoi(String id) async {
    final xacNhan = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xác nhận xóa'),
        content: const Text('Bạn có chắc muốn xóa câu hỏi này không?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Xóa'),
          ),
        ],
      ),
    );

    if (xacNhan == true) {
      try {
        // Xóa tất cả câu trả lời trước
        final traLoi = await FirebaseFirestore.instance
            .collection('cau_tra_loi')
            .where('cauHoiId', isEqualTo: id)
            .get();

        for (var doc in traLoi.docs) {
          await doc.reference.delete();
        }

        // Xóa câu hỏi
        await FirebaseFirestore.instance.collection('cau_hoi').doc(id).delete();

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Đã xóa câu hỏi và các câu trả lời'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Lỗi xóa: $e'), backgroundColor: Colors.red),
          );
        }
      }
    }
  }

  // Hàm xóa câu trả lời
  Future<void> _xoaTraLoi(String id) async {
    final xacNhan = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xác nhận xóa'),
        content: const Text('Bạn có chắc muốn xóa câu trả lời này không?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Xóa'),
          ),
        ],
      ),
    );

    if (xacNhan == true) {
      try {
        await FirebaseFirestore.instance
            .collection('cau_tra_loi')
            .doc(id)
            .delete();

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Đã xóa câu trả lời'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Lỗi xóa: $e'), backgroundColor: Colors.red),
          );
        }
      }
    }
  }
}
