import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FormPhanQuyen extends StatefulWidget {
  final String userId;
  final String emailHienTai;
  final String vaiTroHienTai;

  const FormPhanQuyen({
    super.key,
    required this.userId,
    required this.emailHienTai,
    required this.vaiTroHienTai,
  });

  @override
  State<FormPhanQuyen> createState() => _FormPhanQuyenState();
}

class _FormPhanQuyenState extends State<FormPhanQuyen> {
  late String _vaiTroChon;
  bool _dangLuu = false;

  @override
  void initState() {
    super.initState();
    _vaiTroChon = widget.vaiTroHienTai;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        width: 400,
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Phân quyền người dùng',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Email: ${widget.emailHienTai}',
              style: const TextStyle(color: Color(0xFF64748B)),
            ),
            const SizedBox(height: 20),

            const Text(
              'Chọn vai trò:',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            RadioListTile<String>(
              title: const Text('Khách'),
              value: 'guest',
              groupValue: _vaiTroChon,
              onChanged: (value) {
                setState(() {
                  _vaiTroChon = value!;
                });
              },
            ),
            RadioListTile<String>(
              title: const Text('Sinh viên'),
              value: 'student',
              groupValue: _vaiTroChon,
              onChanged: (value) {
                setState(() {
                  _vaiTroChon = value!;
                });
              },
            ),
            RadioListTile<String>(
              title: const Text('Admin'),
              value: 'admin',
              groupValue: _vaiTroChon,
              onChanged: (value) {
                setState(() {
                  _vaiTroChon = value!;
                });
              },
            ),

            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Hủy'),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: _dangLuu ? null : _luuThayDoi,
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
                      : const Text('Lưu thay đổi'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _luuThayDoi() async {
    setState(() => _dangLuu = true);

    try {
      await FirebaseFirestore.instance
          .collection('nguoi_dung')
          .doc(widget.userId)
          .update({'vaiTro': _vaiTroChon});

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Cập nhật vai trò thành công!'),
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
}
