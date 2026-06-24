import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../config/app_colors.dart';
import 'form_them_bai_viet.dart';
import 'form_sua_bai_viet.dart';

class AdminCamNangScreen extends StatefulWidget {
  const AdminCamNangScreen({super.key});

  @override
  State<AdminCamNangScreen> createState() => _AdminCamNangScreenState();
}

class _AdminCamNangScreenState extends State<AdminCamNangScreen> {
  String _tuKhoaTim = '';
  String _danhMucLoc = 'Tất cả';

  // Lấy danh sách bài viết từ Firestore realtime
  Stream<QuerySnapshot> _getStreamBaiViet() {
    Query query = FirebaseFirestore.instance
        .collection('cam_nang')
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
            // Hàng tiêu đề + nút thêm
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Quản lý Cẩm nang',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => const FormThemBaiViet(),
                    );
                  },
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Thêm mới'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0D47A1),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
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
                      hintText: 'Tìm kiếm bài viết...',
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
                // Dropdown lọc danh mục
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _danhMucLoc,
                      items: const [
                        DropdownMenuItem(
                          value: 'Tất cả',
                          child: Text('Tất cả'),
                        ),
                        DropdownMenuItem(
                          value: 'Đào tạo',
                          child: Text('Đào tạo'),
                        ),
                        DropdownMenuItem(
                          value: 'Học phí',
                          child: Text('Học phí'),
                        ),
                        DropdownMenuItem(
                          value: 'Sự kiện',
                          child: Text('Sự kiện'),
                        ),
                        DropdownMenuItem(value: 'Khác', child: Text('Khác')),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _danhMucLoc = value!;
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Danh sách bài viết từ Firestore
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _getStreamBaiViet(),
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
                      return tieuDe.toLowerCase().contains(
                        _tuKhoaTim.toLowerCase(),
                      );
                    }).toList();
                  }

                  // Lọc theo danh mục
                  if (_danhMucLoc != 'Tất cả') {
                    danhSach = danhSach.where((doc) {
                      final data = doc.data() as Map<String, dynamic>;
                      return data['danhMuc'] == _danhMucLoc;
                    }).toList();
                  }

                  if (danhSach.isEmpty) {
                    return const Center(child: Text('Không có bài viết nào'));
                  }

                  return ListView.builder(
                    itemCount: danhSach.length,
                    itemBuilder: (context, index) {
                      final doc = danhSach[index];
                      final data = doc.data() as Map<String, dynamic>;
                      return _buildBaiVietCard(doc.id, data);
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

  // Card bài viết
  Widget _buildBaiVietCard(String id, Map<String, dynamic> data) {
    final tieuDe = data['tieuDe'] ?? 'Không có tiêu đề';
    final danhMuc = data['danhMuc'] ?? 'Khác';
    final luotXem = data['luotXem'] ?? 0;

    // Xử lý ngày đăng
    String ngayDang = 'Chưa có';
    if (data['ngayTao'] != null) {
      final date = (data['ngayTao'] as Timestamp).toDate();
      ngayDang = '${date.day}/${date.month}/${date.year}';
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
      child: Row(
        children: [
          // Nội dung chính
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tieuDe,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0D47A1).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        danhMuc,
                        style: const TextStyle(
                          fontSize: 11,
                          color: Color(0xFF0D47A1),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      ngayDang,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF64748B),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Row(
                      children: [
                        const Icon(
                          Icons.visibility,
                          size: 14,
                          color: Color(0xFF64748B),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '$luotXem',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Nút hành động: Sửa + Xóa
          Row(
            children: [
              IconButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) =>
                        FormSuaBaiViet(idBaiViet: id, duLieuCu: data),
                  );
                },
                icon: const Icon(Icons.edit, color: Color(0xFFFF9800)),
                tooltip: 'Sửa',
              ),
              IconButton(
                onPressed: () {
                  _xoaBaiViet(id);
                },
                icon: const Icon(Icons.delete, color: Colors.red),
                tooltip: 'Xóa',
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Hàm xóa bài viết
  Future<void> _xoaBaiViet(String id) async {
    // Hiện hộp thoại xác nhận
    final xacNhan = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xác nhận xóa'),
        content: const Text('Bạn có chắc muốn xóa bài viết này không?'),
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
            .collection('cam_nang')
            .doc(id)
            .delete();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Đã xóa bài viết'),
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
