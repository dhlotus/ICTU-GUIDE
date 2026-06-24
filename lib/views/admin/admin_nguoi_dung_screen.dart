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
            const Text(
              'Quản lý Người dùng',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // Thanh tìm kiếm
            TextField(
              onChanged: (value) {
                setState(() {
                  _tuKhoaTim = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'Tìm kiếm theo email...',
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

                  // Lọc theo email
                  if (_tuKhoaTim.isNotEmpty) {
                    danhSach = danhSach.where((doc) {
                      final data = doc.data() as Map<String, dynamic>;
                      final email = data['email'] ?? '';
                      return email.toLowerCase().contains(
                        _tuKhoaTim.toLowerCase(),
                      );
                    }).toList();
                  }

                  if (danhSach.isEmpty) {
                    return const Center(child: Text('Không có người dùng nào'));
                  }

                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columnSpacing: 20,
                      columns: const [
                        DataColumn(
                          label: Text(
                            'Email',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Vai trò',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Ngày tạo',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Hành động',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                      rows: danhSach.map((doc) {
                        final data = doc.data() as Map<String, dynamic>;
                        final email = data['email'] ?? 'Không có email';
                        final vaiTro = data['vaiTro'] ?? 'guest';
                        final ngayTao = data['ngayTao'] as Timestamp?;
                        String ngayTaoStr = 'Chưa có';
                        if (ngayTao != null) {
                          final date = ngayTao.toDate();
                          ngayTaoStr = '${date.day}/${date.month}/${date.year}';
                        }

                        return DataRow(
                          cells: [
                            DataCell(Text(email)),
                            DataCell(
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: _getVaiTroColor(
                                    vaiTro,
                                  ).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  _getVaiTroText(vaiTro),
                                  style: TextStyle(
                                    color: _getVaiTroColor(vaiTro),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                            DataCell(Text(ngayTaoStr)),
                            DataCell(
                              IconButton(
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) => FormPhanQuyen(
                                      userId: doc.id,
                                      emailHienTai: email,
                                      vaiTroHienTai: vaiTro,
                                    ),
                                  );
                                },
                                icon: const Icon(
                                  Icons.edit,
                                  color: Color(0xFFFF9800),
                                ),
                                tooltip: 'Phân quyền',
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getVaiTroText(String vaiTro) {
    switch (vaiTro) {
      case 'admin':
        return 'Admin';
      case 'student':
        return 'Sinh viên';
      default:
        return 'Khách';
    }
  }

  Color _getVaiTroColor(String vaiTro) {
    switch (vaiTro) {
      case 'admin':
        return Colors.red;
      case 'student':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }
}
