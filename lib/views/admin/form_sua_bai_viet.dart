import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../config/app_colors.dart';

class FormSuaBaiViet extends StatefulWidget {
  final String idBaiViet;
  final Map<String, dynamic> duLieuCu;

  const FormSuaBaiViet({
    super.key,
    required this.idBaiViet,
    required this.duLieuCu,
  });

  @override
  State<FormSuaBaiViet> createState() => _FormSuaBaiVietState();
}

class _FormSuaBaiVietState extends State<FormSuaBaiViet> {
  final _formKey = GlobalKey<FormState>();
  final _tieuDeController = TextEditingController();
  final _noiDungController = TextEditingController();
  String _danhMucChon = 'Đào tạo';
  bool _dangLuu = false;

  final List<String> _danhSachDanhMuc = [
    'Đào tạo',
    'Học phí',
    'Ký túc',
    'Sự kiện',
    'Khác',
  ];

  @override
  void initState() {
    super.initState();
    // Đổ dữ liệu cũ vào form
    _tieuDeController.text = widget.duLieuCu['tieuDe'] ?? '';
    _noiDungController.text = widget.duLieuCu['noiDung'] ?? '';
    _danhMucChon = widget.duLieuCu['danhMuc'] ?? 'Đào tạo';
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        width: 500,
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Tiêu đề
              const Text(
                'Sửa bài viết',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),

              // Tiêu đề
              const Text(
                'Tiêu đề *',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 6),
              TextFormField(
                controller: _tieuDeController,
                decoration: InputDecoration(
                  hintText: 'Nhập tiêu đề bài viết',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập tiêu đề';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Danh mục
              const Text(
                'Danh mục *',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 6),
              DropdownButtonFormField<String>(
                value: _danhMucChon,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                items: _danhSachDanhMuc.map((danhMuc) {
                  return DropdownMenuItem(value: danhMuc, child: Text(danhMuc));
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _danhMucChon = value!;
                  });
                },
              ),
              const SizedBox(height: 16),

              // Nội dung
              const Text(
                'Nội dung *',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 6),
              TextFormField(
                controller: _noiDungController,
                maxLines: 5,
                decoration: InputDecoration(
                  hintText: 'Nhập nội dung bài viết...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập nội dung';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // Nút hành động
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Hủy'),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: _dangLuu ? null : _capNhatBaiViet,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0D47A1),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: _dangLuu
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text('Cập nhật'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Hàm cập nhật bài viết lên Firestore
  Future<void> _capNhatBaiViet() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _dangLuu = true);

    try {
      await FirebaseFirestore.instance
          .collection('cam_nang')
          .doc(widget.idBaiViet)
          .update({
            'tieuDe': _tieuDeController.text.trim(),
            'danhMuc': _danhMucChon,
            'noiDung': _noiDungController.text.trim(),
          });

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Cập nhật bài viết thành công!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi: $e'), backgroundColor: Colors.red),
        );
      }
    }

    setState(() => _dangLuu = false);
  }

  @override
  void dispose() {
    _tieuDeController.dispose();
    _noiDungController.dispose();
    super.dispose();
  }
}
