import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../config/app_colors.dart';
import '../services/cau_hoi_service.dart';
import '../services/nguoi_dung_service.dart';
import '../models/cau_hoi.dart';
import 'cau_hoi_detail_screen.dart';
import '../widgets/avatar_widget.dart';

class CauHoiCuaToiScreen extends StatefulWidget {
  const CauHoiCuaToiScreen({super.key});

  @override
  State<CauHoiCuaToiScreen> createState() => _CauHoiCuaToiScreenState();
}

class _CauHoiCuaToiScreenState extends State<CauHoiCuaToiScreen> {
  final CauHoiService _cauHoiService = CauHoiService();
  final NguoiDungService _nguoiDungService = NguoiDungService();
  String _tuKhoaTimKiem = '';

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Câu hỏi của tôi',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 8),
          child: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, size: 20),
            onPressed: () => Navigator.pop(context),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(height: 16),
            // Thanh tìm kiếm
            Container(
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
                  hintText: 'Tìm kiếm câu hỏi của bạn...',
                  hintStyle: TextStyle(color: AppColors.textTertiary),
                  prefixIcon: Icon(Icons.search, color: AppColors.textTertiary),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Danh sách câu hỏi của riêng User
            Expanded(
              child: StreamBuilder<List<CauHoi>>(
                stream: _cauHoiService.layDanhSachCauHoiCuaToi(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(child: Text('Lỗi: ${snapshot.error}'));
                  }

                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  var danhSach = snapshot.data!;

                  if (_tuKhoaTimKiem.isNotEmpty) {
                    danhSach = danhSach.where((cauHoi) {
                      return cauHoi.tieuDe.toLowerCase().contains(_tuKhoaTimKiem.toLowerCase()) ||
                          cauHoi.noiDung.toLowerCase().contains(_tuKhoaTimKiem.toLowerCase());
                    }).toList();
                  }

                  if (danhSach.isEmpty) {
                    return const Center(child: Text('Bạn chưa đăng câu hỏi nào.'));
                  }

                  return ListView.builder(
                    itemCount: danhSach.length,
                    itemBuilder: (context, index) {
                      final cauHoi = danhSach[index];
                      return _buildCauHoiCard(cauHoi);
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
        margin: const EdgeInsets.only(bottom: 12),
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
              FutureBuilder<Map<String, dynamic>?>(
                future: _nguoiDungService.layThongTinNguoiDungById(cauHoi.nguoiDungId),
                builder: (context, snapshot) {
                  String displayName = 'Người dùng';
                  String? avatarId;

                  if (snapshot.hasData && snapshot.data != null) {
                    displayName = snapshot.data!['tenHienThi'] ?? 'Người dùng';
                    avatarId = snapshot.data!['avatarId'];
                  }

                  return Row(
                    children: [
                      AvatarWidget(avatarId: avatarId, size: 36),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              displayName,
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
                  );
                },
              ),
              const SizedBox(height: 12),
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
}