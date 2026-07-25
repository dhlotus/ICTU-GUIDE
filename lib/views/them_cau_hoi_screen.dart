import 'package:flutter/material.dart';
import '../config/app_colors.dart';
import '../services/cau_hoi_service.dart';

class ThemCauHoiScreen extends StatefulWidget {
  const ThemCauHoiScreen({super.key});

  @override
  State<ThemCauHoiScreen> createState() => _ThemCauHoiScreenState();
}

class _ThemCauHoiScreenState extends State<ThemCauHoiScreen> {
  final TextEditingController _noiDungController = TextEditingController();
  bool _dangXuLy = false;

  @override
  Widget build(BuildContext context) {
    // 1. Minimalist Top Header
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC), // 2. Main Canvas (Light off-white)
      appBar: AppBar(
        backgroundColor: Colors.white, // Seamless white top bar
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20, color: Color(0xFF0D47A1)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Đăng câu hỏi',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Color(0xFF0F172A), // Charcoal text
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: [
              const SizedBox(height: 32),

              // 2. Section Label
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Nội dung câu hỏi',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1E293B), // Slate
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // 3. The Premium Single Input Box
              TextField(
                controller: _noiDungController,
                maxLines: null, // Cho phép mở rộng vô tận theo nội dung
                minLines: 6,   // Chiều cao khởi tạo khoảng 6 dòng
                maxLength: 500, // Giới hạn ký tự (để kích hoạt bộ đếm tự động)
                style: const TextStyle(
                  fontSize: 15,
                  color: Color(0xFF0F172A),
                  height: 1.5,
                ),
                // Xử lý trạng thái Dynamic Active/Disabled
                onChanged: (value) {
                  setState(() {}); // Trigger rebuild để cập nhật trạng thái nút
                },
                decoration: InputDecoration(
                  hintText: 'Nhập chi tiết thắc mắc của bạn về lịch học, thủ tục, khuôn viên ICTU...',
                  hintStyle: const TextStyle(color: Color(0xFF94A3B8), fontSize: 14),
                  filled: true,
                  fillColor: const Color(0xFFF1F5F9), // Soft off-white background
                  contentPadding: const EdgeInsets.all(20),
                  // Bộ đếm ký tự ở góc dưới phải
                  counterStyle: const TextStyle(fontSize: 12, color: Color(0xFF94A3B8)),
                  // 3. Borders & States
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: Color(0xFFE2E8F0), width: 1), // Neutral border
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: Color(0xFFE2E8F0), width: 1),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: Color(0xFF0284C7), width: 1.5), // Vibrant blue border
                  ),
                ),
              ),

              const Spacer(),

              // 4. Primary Action Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _dangXuLy
                      ? null
                      : (_noiDungController.text.trim().isEmpty ? null : _dangCauHoi),
                  style: ElevatedButton.styleFrom(
                    // Dynamic UX States
                    backgroundColor: _noiDungController.text.trim().isEmpty
                        ? const Color(0xFFE2E8F0) // Disabled gray
                        : const Color(0xFF0D47A1), // Active blue
                    foregroundColor: _noiDungController.text.trim().isEmpty
                        ? const Color(0xFF94A3B8) // Disabled text
                        : Colors.white, // Active text
                    elevation: _noiDungController.text.trim().isEmpty ? 0 : 4,
                    shadowColor: const Color(0xFF0D47A1).withOpacity(0.3),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: _dangXuLy
                      ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                      : const Text(
                    'Đăng câu hỏi',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 40), // Padding dưới đáy để tránh dính sát bàn phím
            ],
          ),
        ),
      ),
    );
  }

  /// Xử lý đăng câu hỏi
  Future<void> _dangCauHoi() async {
    setState(() {
      _dangXuLy = true;
    });

    try {
      final noiDung = _noiDungController.text.trim();
      final cauHoiService = CauHoiService();
      // Lấy dòng đầu tiên làm tiêu đề
      String tieuDe = noiDung.split('\n')[0];
      if (tieuDe.length > 100) tieuDe = tieuDe.substring(0, 100) + '...';

      await cauHoiService.themCauHoi(tieuDe, noiDung);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Đã gửi câu hỏi thành công!')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _dangXuLy = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _noiDungController.dispose();
    super.dispose();
  }
}