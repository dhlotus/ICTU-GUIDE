import 'package:flutter/material.dart';
import '../config/app_colors.dart';
import '../models/cam_nang.dart';
import '../services/cam_nang_service.dart';

/// Màn hình chi tiết bài viết - Seamless Editorial UI
class CamNangDetailScreen extends StatefulWidget {
  final CamNang baiViet;

  const CamNangDetailScreen({super.key, required this.baiViet});

  @override
  State<CamNangDetailScreen> createState() => _CamNangDetailScreenState();
}

class _CamNangDetailScreenState extends State<CamNangDetailScreen> {
  // Khai báo Service ở đây (để tránh lỗi const)
  final CamNangService _camNangService = CamNangService();

  @override
  void initState() {
    super.initState();
    // Gọi hàm tăng lượt xem ngay khi mở màn hình
    _tangLuotXem();
  }

  // Hàm gọi Service tăng lượt xem
  void _tangLuotXem() {
    _camNangService.tangLuotXem(widget.baiViet.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20, color: Color(0xFF0D47A1)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Cẩm nang',
          style: TextStyle(color: Color(0xFF0F172A), fontWeight: FontWeight.w600, fontSize: 18),
        ),
        toolbarHeight: 60,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- ẢNH BÌA NHỎ ---
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.network(
                'https://images.unsplash.com/photo-1522202176988-66273c2fd55f?q=80&w=2671&auto=format&fit=crop',
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 20),

            // --- TIÊU ĐỀ ---
            Text(
              _capitalizeTitle(widget.baiViet.tieuDe),
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w800,
                color: Color(0xFF0F172A),
                height: 1.2,
                letterSpacing: -0.5,
              ),
            ),

            const SizedBox(height: 20),

            // --- META DATA ---
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.calendar_today_outlined, size: 14, color: Color(0xFF64748B)),
                    const SizedBox(width: 6),
                    Text(
                      _formatDate(widget.baiViet.ngayTao),
                      style: const TextStyle(color: Color(0xFF64748B), fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF3E0),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.access_time, size: 12, color: Color(0xFFE65100)),
                      const SizedBox(width: 4),
                      Text(
                        '${_thoiGianDoc(widget.baiViet.noiDung)} phút đọc',
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFFE65100)),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),
            Container(height: 1, color: const Color(0xFFE2E8F0)),
            const SizedBox(height: 24),

            // --- NỘI DUNG ---
            Text(
              widget.baiViet.noiDung,
              style: const TextStyle(
                fontSize: 16,
                height: 1.6,
                fontWeight: FontWeight.w500,
                color: Color(0xFF374151),
                wordSpacing: 1.0,
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // --- CÁC HÀM TIỆN ÍCH ---

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

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  int _thoiGianDoc(String noiDung) {
    final soTu = noiDung.split(' ').length;
    final phutDoc = (soTu / 200).ceil();
    return phutDoc > 0 ? phutDoc : 1;
  }
}