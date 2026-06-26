import 'package:flutter/material.dart';
import '../config/app_colors.dart';
import '../models/lich_hoc_import.dart';
import 'package:flutter/cupertino.dart';
import '../services/notification_service.dart';

/// Màn hình thêm lịch thủ công
class ThemLichThuCongScreen extends StatefulWidget {
  final Function(LichHocImport) onThemLich;

  const ThemLichThuCongScreen({super.key, required this.onThemLich});

  @override
  State<ThemLichThuCongScreen> createState() => _ThemLichThuCongScreenState();
}

class _ThemLichThuCongScreenState extends State<ThemLichThuCongScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final _tieuDeController = TextEditingController();
  final _ghiChuController = TextEditingController();

  // Biến lưu giá trị
  DateTime _ngayChon = DateTime.now();
  TimeOfDay _gioBatDau = const TimeOfDay(hour: 7, minute: 0);
  TimeOfDay _gioKetThuc = const TimeOfDay(hour: 9, minute: 0);
  final int _selectedHour = 7;
  final int _selectedMinute = 0;
  int _soNgayTrongThang(int year, int month) {
    return DateTime(year, month + 1, 0).day;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Thêm lịch',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          TextButton(
            onPressed: _luuLich,
            child: const Text(
              'Lưu',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
      body: GestureDetector(
        onTap: _dongBanPhim,  // Ấn vào đâu cũng đóng bàn phím
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              // Tiêu đề
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Tiêu đề',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _tieuDeController,
                      decoration: InputDecoration(
                        hintText: 'VD: Họp nhóm, Nộp báo cáo, ...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Vui lòng nhập tiêu đề';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Ngày tháng
              _buildDateTimePicker(),
              const SizedBox(height: 16),

              // Ghi chú
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Ghi chú',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _ghiChuController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        hintText: 'VD: Phòng A102, Cần mang theo tài liệu...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDateTimePicker() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Thời gian',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),

          // Chọn ngày - Cải tiến giao diện
          InkWell(
            onTap: _chonNgay,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border, width: 1),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.calendar_today, size: 18, color: AppColors.primary),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Chọn ngày',
                          style: TextStyle(
                            fontSize: 11,
                            color: AppColors.textTertiary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          _formatNgayViet(_ngayChon),
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.chevron_right, size: 20, color: AppColors.textTertiary),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Chọn giờ - ĐƠN GIẢN, CHỈ 1 GIỜ
          InkWell(
            onTap: () => _chonGio(true),
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border, width: 1),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.access_time, size: 18, color: AppColors.primary),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Chọn giờ',
                          style: TextStyle(
                            fontSize: 11,
                            color: AppColors.textTertiary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          _formatTimeOfDay(_gioBatDau),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.chevron_right, size: 20, color: AppColors.textTertiary),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _chonNgay() async {
    DateTime tempDate = _ngayChon;

    final result = await showModalBottomSheet<DateTime>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setStateBottomSheet) {
          return DraggableScrollableSheet(
            initialChildSize: 0.75,
            minChildSize: 0.5,
            maxChildSize: 0.9,
            builder: (context, scrollController) {
              return Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(30),
                  ),
                ),
                child: Column(
                  children: [
                    // Thanh kéo
                    Container(
                      margin: const EdgeInsets.only(top: 12),
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: AppColors.border,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Header
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: const Text(
                              'Hủy',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ),
                          const Text(
                            'Chọn ngày',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context, tempDate);
                            },
                            child: Text(
                              'Xong',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 8),

                    // Hiển thị ngày đã chọn
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Column(
                        children: [
                          Text(
                            _getThuTiengViet(tempDate.weekday),
                            style: const TextStyle(
                              fontSize: 16,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${tempDate.day}',
                            style: const TextStyle(
                              fontSize: 48,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                          Text(
                            'Tháng ${tempDate.month}, ${tempDate.year}',
                            style: const TextStyle(
                              fontSize: 14,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const Divider(height: 1),

                    // Lưới chọn ngày
                    Expanded(
                      child: GridView.builder(
                        controller: scrollController,
                        padding: const EdgeInsets.all(16),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 7,
                          childAspectRatio: 1.1,
                        ),
                        itemCount: _soNgayTrongThang(tempDate.year, tempDate.month),
                        itemBuilder: (context, index) {
                          final day = index + 1;
                          final date = DateTime(tempDate.year, tempDate.month, day);
                          final isSelected = tempDate.day == day;
                          final isToday = date.year == DateTime.now().year &&
                              date.month == DateTime.now().month &&
                              date.day == DateTime.now().day;

                          return GestureDetector(
                            onTap: () {
                              setStateBottomSheet(() {
                                tempDate = DateTime(tempDate.year, tempDate.month, day);
                              });
                            },
                            child: Container(
                              margin: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? AppColors.primary
                                    : Colors.transparent,
                                shape: BoxShape.circle,
                                border: isToday && !isSelected
                                    ? Border.all(
                                  color: AppColors.primary,
                                  width: 1.5,
                                )
                                    : null,
                              ),
                              child: Center(
                                child: Text(
                                  '$day',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: isSelected
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                    color: isSelected
                                        ? Colors.white
                                        : isToday
                                        ? AppColors.primary
                                        : AppColors.textPrimary,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 16),
                  ],
                ),
              );
            },
          );
        },
      ),
    );

    if (result != null) {
      setState(() {
        _ngayChon = result;
      });
    }
  }

  Future<void> _chonGio(bool isBatDau) async {
    final initialTime = isBatDau ? _gioBatDau : _gioKetThuc;
    int tempHour = initialTime.hour;
    int tempMinute = initialTime.minute;

    final time = await showDialog<TimeOfDay>(
      context: context,
      barrierDismissible: true,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Center(
          child: Text(
            'Chọn giờ',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        content: SizedBox(
          height: 250,
          width: 300,
          child: Row(
            children: [
              // Chọn giờ (0-23)
              Expanded(
                child: CupertinoPicker(
                  scrollController: FixedExtentScrollController(
                    initialItem: initialTime.hour,
                  ),
                  itemExtent: 40,
                  onSelectedItemChanged: (value) {
                    tempHour = value;
                  },
                  children: List.generate(24, (index) {
                    return Center(
                      child: Text(
                        index.toString().padLeft(2, '0'),
                        style: const TextStyle(fontSize: 24),
                      ),
                    );
                  }),
                ),
              ),
              // Dấu hai chấm
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 4),
                child: Text(
                  ':',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
              ),
              // Chọn phút (0-59)
              Expanded(
                child: CupertinoPicker(
                  scrollController: FixedExtentScrollController(
                    initialItem: initialTime.minute,
                  ),
                  itemExtent: 40,
                  onSelectedItemChanged: (value) {
                    tempMinute = value;
                  },
                  children: List.generate(60, (index) {
                    return Center(
                      child: Text(
                        index.toString().padLeft(2, '0'),
                        style: const TextStyle(fontSize: 24),
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy', style: TextStyle(color: Colors.red)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(
                context,
                TimeOfDay(hour: tempHour, minute: tempMinute),
              );
            },
            child: Text(
              'Xong',
              style: TextStyle(color: AppColors.primary),
            ),
          ),
        ],
      ),
    );

    if (time != null) {
      setState(() {
        if (isBatDau) {
          _gioBatDau = time;
          // Tự động +30 phút
          final newEnd = _gioBatDau.hour * 60 + _gioBatDau.minute + 30;
          _gioKetThuc = TimeOfDay(
            hour: (newEnd ~/ 60) % 24,
            minute: newEnd % 60,
          );
        } else {
          _gioKetThuc = time;
        }
      });
    }
  }

  void _luuLich() async {
    if (!_formKey.currentState!.validate()) return;

    final thoiGianBatDau = DateTime(
      _ngayChon.year,
      _ngayChon.month,
      _ngayChon.day,
      _gioBatDau.hour,
      _gioBatDau.minute,
    );

    final thoiGianKetThuc = thoiGianBatDau.add(const Duration(minutes: 20));

    final lichMoi = LichHocImport(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      tenMon: _tieuDeController.text,
      thuTrongTuan: _ngayChon.weekday + 1,
      tietBatDau: 1,
      tietKetThuc: 2,
      diaDiem: _ghiChuController.text.isEmpty ? 'Thủ công' : _ghiChuController.text,
      nguon: 'manual',
      ngayHoc: _ngayChon,
      thoiGianBatDau: thoiGianBatDau,
      thoiGianKetThuc: thoiGianKetThuc,
    );

    // LƯU LỊCH
    widget.onThemLich(lichMoi);

    // LÊN LỊCH THÔNG BÁO: TÍNH TOÁN THỜI GIAN CHỜ
    final thoiGianHienTai = DateTime.now();
    final khoangCach = thoiGianBatDau.difference(thoiGianHienTai);

    if (khoangCach.inSeconds > 0) {
      // LÊN LỊCH BÁO ĐÚNG GIỜ
      final idThongBao = DateTime.now().millisecondsSinceEpoch ~/ 1000;

      // THÔNG BÁO SẼ HIỆN SAU KHOẢNG THỜI GIAN CHỜ
      Future.delayed(khoangCach, () {
        NotificationService.hienThiThongBao(
          id: idThongBao,
          tieuDe: '🔔 Lịch nhắc của bạn',
          noiDung: _tieuDeController.text,
        );
      });
    }

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Đã thêm lịch thành công!')),
      );
    }

    Navigator.pop(context);
  }

  int _getTietFromTime(TimeOfDay time) {
    // Ánh xạ giờ sang tiết gần nhất
    final hour = time.hour;
    final minute = time.minute;

    if (hour < 7) return 1;
    if (hour == 7 && minute <= 35) return 1;
    if (hour == 7 && minute > 35) return 2;
    if (hour == 8 && minute <= 30) return 2;
    if (hour == 8 && minute > 30) return 3;
    if (hour == 9 && minute <= 30) return 3;
    if (hour == 9 && minute > 30) return 4;
    if (hour == 10 && minute <= 30) return 4;
    if (hour == 10 && minute > 30) return 5;
    if (hour < 13) return 5;
    if (hour == 13 && minute <= 50) return 6;
    if (hour == 13 && minute > 50) return 7;
    if (hour == 14 && minute <= 45) return 7;
    if (hour == 14 && minute > 45) return 8;
    if (hour == 15 && minute <= 45) return 8;
    if (hour == 15 && minute > 45) return 9;
    if (hour == 16 && minute <= 45) return 9;
    if (hour == 16 && minute > 45) return 10;
    return 6;
  }

  String _formatTimeOfDay(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  @override
  void dispose() {
    _tieuDeController.dispose();
    _ghiChuController.dispose();
    super.dispose();
  }
  int _tinhTietTuGio(TimeOfDay time) {
    final hour = time.hour;
    final minute = time.minute;

    if (hour < 7) return 1;
    if (hour == 7 && minute <= 35) return 1;
    if (hour == 7 && minute > 35) return 2;
    if (hour == 8 && minute <= 30) return 2;
    if (hour == 8 && minute > 30) return 3;
    if (hour == 9 && minute <= 30) return 3;
    if (hour == 9 && minute > 30) return 4;
    if (hour == 10 && minute <= 30) return 4;
    if (hour == 10 && minute > 30) return 5;
    if (hour < 13) return 5;
    if (hour == 13 && minute <= 50) return 6;
    if (hour == 13 && minute > 50) return 7;
    if (hour == 14 && minute <= 45) return 7;
    if (hour == 14 && minute > 45) return 8;
    if (hour == 15 && minute <= 45) return 8;
    if (hour == 15 && minute > 45) return 9;
    if (hour == 16 && minute <= 45) return 9;
    if (hour == 16 && minute > 45) return 10;
    return 6;
  }
  void _dongBanPhim() {
    FocusScope.of(context).unfocus();
  }
  String _formatNgayViet(DateTime date) {
    final thu = _getThuTiengViet(date.weekday);
    return '$thu, ${date.day}/${date.month}/${date.year}';
  }

  String _getThuTiengViet(int weekday) {
    const thu = ['', 'Thứ 2', 'Thứ 3', 'Thứ 4', 'Thứ 5', 'Thứ 6', 'Thứ 7', 'Chủ nhật'];
    return thu[weekday];
  }
}