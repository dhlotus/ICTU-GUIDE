import 'package:flutter/material.dart';
import '../config/app_colors.dart';
import '../services/cau_hoi_service.dart';

/// Màn hình thêm câu hỏi mới
class ThemCauHoiScreen extends StatefulWidget {
  const ThemCauHoiScreen({super.key});

  @override
  State<ThemCauHoiScreen> createState() => _ThemCauHoiScreenState();
}

class _ThemCauHoiScreenState extends State<ThemCauHoiScreen> {
  final TextEditingController _tieuDeController = TextEditingController();
  final TextEditingController _noiDungController = TextEditingController();
  bool _dangXuLy = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Đăng câu hỏi mới'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tiêu đề
            const Text(
              'Tiêu đề câu hỏi',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _tieuDeController,
              decoration: InputDecoration(
                hintText: 'Ví dụ: Làm sao để đăng ký môn học?',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Nội dung
            const Text(
              'Nội dung chi tiết',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _noiDungController,
              maxLines: 8,
              decoration: InputDecoration(
                hintText: 'Mô tả chi tiết vấn đề bạn gặp phải...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 30),

            // Nút đăng câu hỏi
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _dangXuLy ? null : _dangCauHoi,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _dangXuLy
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Đăng câu hỏi', style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Xử lý đăng câu hỏi
  Future<void> _dangCauHoi() async {
    if (_tieuDeController.text.trim().isEmpty) {
      _thongBaoLoi('Vui lòng nhập tiêu đề');
      return;
    }

    if (_noiDungController.text.trim().isEmpty) {
      _thongBaoLoi('Vui lòng nhập nội dung');
      return;
    }

    setState(() {
      _dangXuLy = true;
    });

    try {
      final cauHoiService = CauHoiService();
      await cauHoiService.themCauHoi(
        _tieuDeController.text.trim(),
        _noiDungController.text.trim(),
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Đăng câu hỏi thành công!')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        _thongBaoLoi('Lỗi: ${e.toString()}');
      }
    } finally {
      if (mounted) {
        setState(() {
          _dangXuLy = false;
        });
      }
    }
  }

  /// Hiển thị thông báo lỗi
  void _thongBaoLoi(String thongBao) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(thongBao)),
    );
  }

  @override
  void dispose() {
    _tieuDeController.dispose();
    _noiDungController.dispose();
    super.dispose();
  }
}