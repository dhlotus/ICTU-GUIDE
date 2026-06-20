import 'package:flutter/material.dart';
import '../config/app_colors.dart';
import '../models/cau_hoi.dart';
import '../models/cau_tra_loi.dart';

/// Màn hình chi tiết câu hỏi và câu trả lời
class CauHoiDetailScreen extends StatefulWidget {
  final CauHoi cauHoi;

  const CauHoiDetailScreen({super.key, required this.cauHoi});

  @override
  State<CauHoiDetailScreen> createState() => _CauHoiDetailScreenState();
}

class _CauHoiDetailScreenState extends State<CauHoiDetailScreen> {
  late List<CauTraLoi> _danhSachTraLoi;
  final TextEditingController _traLoiController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _danhSachTraLoi = CauTraLoi.getMockData(widget.cauHoi.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // AppBar
          SliverAppBar(
            title: const Text(
              'Chi tiết câu hỏi',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            backgroundColor: AppColors.surface,
            foregroundColor: AppColors.textPrimary,
            elevation: 0,
            centerTitle: false,
            leading: Padding(
              padding: const EdgeInsets.only(left: 8),
              child: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new, size: 20),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),

          // Nội dung câu hỏi
          SliverToBoxAdapter(
            child: _buildCauHoiSection(),
          ),

          // Header của phần câu trả lời
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
              child: Row(
                children: [
                  Text(
                    '${_danhSachTraLoi.length} câu trả lời',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () {},
                    child: const Text('Mới nhất'),
                  ),
                ],
              ),
            ),
          ),

          // Danh sách câu trả lời
          if (_danhSachTraLoi.isEmpty)
            const SliverToBoxAdapter(
              child: Center(
                child: Padding(
                  padding: EdgeInsets.all(40),
                  child: Text('Chưa có câu trả lời nào'),
                ),
              ),
            )
          else
            SliverList(
              delegate: SliverChildBuilderDelegate(
                    (context, index) {
                  final traLoi = _danhSachTraLoi[index];
                  return _buildTraLoiCard(traLoi);
                },
                childCount: _danhSachTraLoi.length,
              ),
            ),

          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
      bottomSheet: _buildAnswerInput(),
    );
  }

  /// Phần hiển thị câu hỏi
  Widget _buildCauHoiSection() {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar + tên + thời gian
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    widget.cauHoi.hoTenNguoiDung[0].toUpperCase(),
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.cauHoi.hoTenNguoiDung,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                    Text(
                      _formatTime(widget.cauHoi.ngayTao),
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textTertiary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Tiêu đề
          Text(
            widget.cauHoi.tieuDe,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              height: 1.3,
            ),
          ),

          const SizedBox(height: 12),

          // Nội dung
          Text(
            widget.cauHoi.noiDung,
            style: TextStyle(
              fontSize: 15,
              height: 1.5,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  /// Card hiển thị câu trả lời
  Widget _buildTraLoiCard(CauTraLoi traLoi) {
    final isBestAnswer = traLoi.id == 'tl1'; // Demo: câu trả lời đầu là best

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isBestAnswer
            ? AppColors.success.withOpacity(0.05)
            : AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: isBestAnswer
            ? Border.all(color: AppColors.success.withOpacity(0.3), width: 1)
            : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: avatar + tên + thời gian
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppColors.accent.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    traLoi.hoTenNguoiDung[0].toUpperCase(),
                    style: TextStyle(
                      color: AppColors.accentDark,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          traLoi.hoTenNguoiDung,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                        if (isBestAnswer) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.success,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text(
                              'Best',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    Text(
                      _formatTime(traLoi.ngayTao),
                      style: TextStyle(
                        fontSize: 11,
                        color: AppColors.textTertiary,
                      ),
                    ),
                  ],
                ),
              ),
              // Nút hữu ích
              Column(
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      traLoi.huuIch ? Icons.thumb_up : Icons.thumb_up_outlined,
                      size: 18,
                      color: traLoi.huuIch ? AppColors.success : AppColors.textTertiary,
                    ),
                  ),
                  Text(
                    traLoi.huuIch ? '25' : '0',
                    style: TextStyle(
                      fontSize: 11,
                      color: AppColors.textTertiary,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 10),

          // Nội dung trả lời
          Text(
            traLoi.noiDung,
            style: TextStyle(
              fontSize: 14,
              height: 1.5,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  /// Ô nhập câu trả lời ở dưới cùng
  Widget _buildAnswerInput() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(24),
              ),
              child: TextField(
                controller: _traLoiController,
                decoration: InputDecoration(
                  hintText: 'Viết câu trả lời của bạn...',
                  hintStyle: TextStyle(color: AppColors.textTertiary),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
                maxLines: 3,
                minLines: 1,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            decoration: BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              onPressed: () {
                if (_traLoiController.text.isNotEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Tính năng đang phát triển')),
                  );
                  _traLoiController.clear();
                }
              },
              icon: const Icon(Icons.send, color: Colors.white, size: 18),
            ),
          ),
        ],
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
    } else {
      return '${diff.inDays} ngày trước';
    }
  }

  @override
  void dispose() {
    _traLoiController.dispose();
    super.dispose();
  }
}