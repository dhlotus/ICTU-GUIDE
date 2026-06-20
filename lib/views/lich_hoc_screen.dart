import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../config/app_colors.dart';
import '../models/lich_hoc.dart';
import '../models/lich_hoc_import.dart';
import 'them_lich_thu_cong_screen.dart';
import '../services/lich_hoc_service.dart';
import 'dangnhap_screen.dart';

/// Màn hình Lịch học cá nhân - Thiết kế tối giản, dễ đọc
class LichHocScreen extends StatefulWidget {
  const LichHocScreen({super.key});

  @override
  State<LichHocScreen> createState() => _LichHocScreenState();
}

class _LichHocScreenState extends State<LichHocScreen> {
  final LichHocService _lichHocService = LichHocService();
  List<LichHocImport> _danhSachLichImport = [];
  DateTime _ngayDuocChon = DateTime.now();
  bool _cheDoTuan = false; // false: Ngày, true: Tuần

  @override
  void initState() {
    super.initState();
    _lichHocService.layDanhSachLichHoc().listen((lichHocList) {
      setState(() {
        _danhSachLichImport = lichHocList;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          _buildAppBar(),

          // Chỉ hiển thị Date Strip khi ở chế độ NGÀY
          if (!_cheDoTuan) _buildDateStrip(),

          // Nội dung chính
          Expanded(
            child: _cheDoTuan ? _buildWeekView() : _buildDayView(),
          ),
        ],
      ),
    );
  }

  // ==================== APPBAR ====================

  Widget _buildAppBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 48, 16, 12),
      decoration: const BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              'Lịch nhắc',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),
          // Segmented Button cho Ngày/Tuần
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(
              children: [
                _buildToggleButton('Ngày', !_cheDoTuan),
                const SizedBox(width: 4),
                _buildToggleButton('Tuần', _cheDoTuan),
              ],
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: _themLich,
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.add, color: Colors.white, size: 22),
            ),
          ),
        ],
      ),
    );
  }

  // ==================== DATE STRIP (CUỘN NGANG) ====================

  Widget _buildDateStrip() {
    final now = DateTime.now();

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      color: AppColors.surface,
      child: SizedBox(
        height: 90,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: 40,
          itemBuilder: (context, index) {
            final date = now.add(Duration(days: index));
            final isSelected = _ngayDuocChon.year == date.year &&
                _ngayDuocChon.month == date.month &&
                _ngayDuocChon.day == date.day;
            final isToday = date.year == DateTime.now().year &&
                date.month == DateTime.now().month &&
                date.day == DateTime.now().day;

            return GestureDetector(
              onTap: () {
                setState(() {
                  _ngayDuocChon = date;
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 65,
                margin: const EdgeInsets.only(right: 12),
                decoration: BoxDecoration(
                  gradient: isSelected
                      ? const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [AppColors.primary, AppColors.primaryLight],
                  )
                      : null,
                  color: isSelected ? null : (isToday ? AppColors.accent.withOpacity(0.1) : AppColors.surface),
                  borderRadius: BorderRadius.circular(24),
                  border: isSelected
                      ? null
                      : Border.all(
                    color: isToday ? AppColors.accent : AppColors.border,
                    width: isToday ? 1.5 : 1,
                  ),
                  boxShadow: isSelected
                      ? [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ]
                      : null,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _getDayOfWeekAbbr(date),
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                        color: isSelected ? Colors.white : (isToday ? AppColors.primary : AppColors.textSecondary),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '${date.day}',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: isSelected ? Colors.white : (isToday ? AppColors.primary : AppColors.textPrimary),
                      ),
                    ),
                    const SizedBox(height: 4),
                    if (isToday && !isSelected)
                      Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: isToday ? AppColors.primary : AppColors.accent,
                          shape: BoxShape.circle,
                        ),
                      )
                    else if (!isSelected)
                      const SizedBox(height: 6),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // ==================== CHẾ ĐỘ NGÀY ====================

  Widget _buildDayView() {
    final lichTrongNgay = _danhSachLichImport.where((lich) {
      return lich.ngayHoc.year == _ngayDuocChon.year &&
          lich.ngayHoc.month == _ngayDuocChon.month &&
          lich.ngayHoc.day == _ngayDuocChon.day &&
          lich.gioKetThuc.isAfter(DateTime.now());
    }).toList();

    final hasEvent = lichTrongNgay.isNotEmpty;

    // Header chỉ hiển thị khi KHÔNG có lịch
    final header = !hasEvent
        ? Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primary, AppColors.primaryLight],
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Column(
        children: [
          Text(
            _getDayOfWeek(_ngayDuocChon),
            style: const TextStyle(
              fontSize: 18,
              color: Colors.white70,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${_ngayDuocChon.day}/${_ngayDuocChon.month}/${_ngayDuocChon.year}',
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              lichTrongNgay.isEmpty ? '✨ Rảnh rỗi' : '${lichTrongNgay.length} môn học',
              style: const TextStyle(
                fontSize: 13,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    )
        : null;

    if (lichTrongNgay.isEmpty) {
      return Column(
        children: [
          ?header,
          const Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.free_breakfast, size: 60, color: AppColors.textTertiary),
                  SizedBox(height: 16),
                  Text(
                    'Bạn rảnh! 🎉\nHãy tận hưởng thời gian của mình nhé!',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    }

    final sortedList = List.of(lichTrongNgay)
      ..sort((a, b) => a.gioBatDau.compareTo(b.gioBatDau));

    return Column(
      children: [
        ?header,
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: sortedList.length,
            itemBuilder: (context, index) {
              final lich = sortedList[index];
              final isLast = index == sortedList.length - 1;
              return _buildTimelineCardFromImport(lich, isLast: isLast);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTimelineCardFromImport(LichHocImport lich, {required bool isLast}) {
    final now = DateTime.now();
    final isCurrent = now.isAfter(lich.gioBatDau) && now.isBefore(lich.gioKetThuc);
    final isPast = now.isAfter(lich.gioKetThuc);

    // Màu sắc theo trạng thái
    Color cardBorderColor = AppColors.primary;
    Color timeColor = AppColors.textPrimary;
    String statusText = '';

    if (isCurrent) {
      cardBorderColor = AppColors.warning;
      timeColor = AppColors.warning;
      statusText = 'Đang diễn ra';
    } else if (isPast) {
      cardBorderColor = AppColors.textTertiary;
      timeColor = AppColors.textTertiary;
      statusText = 'Đã qua';
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Cột thời gian bên trái
        SizedBox(
          width: 75,
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: timeColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  _formatTime(lich.gioBatDau),
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: timeColor,
                  ),
                ),
              ),
              if (!isLast)
                Container(
                  margin: const EdgeInsets.only(top: 8),
                  width: 2,
                  height: 70,
                  color: AppColors.border,
                ),
            ],
          ),
        ),
        const SizedBox(width: 16),

        // Card sự kiện bên phải
        Expanded(
          child: Container(
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isCurrent ? AppColors.warning.withOpacity(0.3) : AppColors.border,
                width: isCurrent ? 1.5 : 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
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
                  // Header: Title + tag + trạng thái
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          lich.tenMon,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: isPast ? AppColors.textSecondary : AppColors.textPrimary,
                          ),
                        ),
                      ),
                      if (statusText.isNotEmpty)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: (isCurrent ? AppColors.warning : AppColors.textTertiary).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            statusText,
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: isCurrent ? AppColors.warning : AppColors.textTertiary,
                            ),
                          ),
                        ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.success.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          '📅',
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  const SizedBox(height: 8),

                  // Địa điểm (bỏ qua nếu là "Thủ công")
                  if (lich.diaDiem.isNotEmpty && lich.diaDiem != 'Thủ công')
                    Row(
                      children: [
                        Icon(Icons.location_on, size: 14, color: AppColors.textTertiary),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            lich.diaDiem,
                            style: TextStyle(
                              fontSize: 13,
                              color: isPast ? AppColors.textTertiary : AppColors.textSecondary,
                            ),
                          ),
                        ),
                      ],
                    ),

                  // Thanh tiến trình cho môn đang diễn ra
                  if (isCurrent)
                    Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: LinearProgressIndicator(
                        value: _getProgress(lich),
                        backgroundColor: AppColors.border,
                        color: AppColors.warning,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Tính tiến trình thời gian
  double _getProgress(LichHocImport lich) {
    final now = DateTime.now();
    final total = lich.gioKetThuc.difference(lich.gioBatDau).inMinutes;
    final elapsed = now.difference(lich.gioBatDau).inMinutes;
    if (total <= 0) return 0;
    return (elapsed / total).clamp(0.0, 1.0);
  }

  Widget _buildTimelineCardDynamic(dynamic lich, {required bool isLast}) {
    final String tenMon;
    final DateTime thoiGianBatDau;
    final DateTime thoiGianKetThuc;
    final String diaDiem;
    final String nguon;

    if (lich is LichHocImport) {
      tenMon = lich.tenMon;
      thoiGianBatDau = lich.gioBatDau;
      thoiGianKetThuc = lich.gioKetThuc;
      diaDiem = lich.diaDiem;
      nguon = lich.nguon;
    } else {
      final lichHoc = lich as LichHoc;
      tenMon = lichHoc.tieuDe;
      thoiGianBatDau = lichHoc.thoiGianBatDau;
      thoiGianKetThuc = lichHoc.thoiGianKetThuc;
      diaDiem = lichHoc.ghiChu ?? '';
      nguon = 'manual';
    }

    final now = DateTime.now();
    final isCurrent = now.isAfter(thoiGianBatDau) && now.isBefore(thoiGianKetThuc);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Cột thời gian bên trái
        SizedBox(
          width: 70,
          child: Column(
            children: [
              Text(
                _formatTime(thoiGianBatDau),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isCurrent ? AppColors.warning : AppColors.textPrimary,
                ),
              ),
              if (!isLast)
                Container(
                  margin: const EdgeInsets.only(top: 8),
                  width: 2,
                  height: 80,
                  color: AppColors.border,
                ),
            ],
          ),
        ),
        const SizedBox(width: 16),

        // Card sự kiện bên phải
        Expanded(
          child: Container(
            margin: const EdgeInsets.only(bottom: 16),
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
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          tenMon,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      if (nguon == 'excel')
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.success.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            '📅 Lịch học',
                            style: TextStyle(fontSize: 10, fontWeight: FontWeight.w500),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(Icons.access_time, size: 14, color: AppColors.textTertiary),
                      const SizedBox(width: 4),
                      Text(
                        '${_formatTime(thoiGianBatDau)} - ${_formatTime(thoiGianKetThuc)}',
                        style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  if (diaDiem.isNotEmpty)
                    Row(
                      children: [
                        Icon(Icons.location_on, size: 14, color: AppColors.textTertiary),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            diaDiem,
                            style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
  Widget _buildTimelineCard(LichHoc lich, {required bool isLast}) {
    final isTask = lich.tieuDe.toLowerCase().contains('nộp') ||
        lich.tieuDe.toLowerCase().contains('bài tập');
    final now = DateTime.now();
    final isCurrent = now.isAfter(lich.thoiGianBatDau) && now.isBefore(lich.thoiGianKetThuc);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Cột thời gian bên trái
        SizedBox(
          width: 70,
          child: Column(
            children: [
              Text(
                _formatTime(lich.thoiGianBatDau),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isCurrent ? AppColors.warning : AppColors.textPrimary,
                ),
              ),
              if (!isLast)
                Container(
                  margin: const EdgeInsets.only(top: 8),
                  width: 2,
                  height: 80,
                  color: AppColors.border,
                ),
            ],
          ),
        ),
        const SizedBox(width: 16),

        // Card sự kiện bên phải
        Expanded(
          child: Container(
            margin: const EdgeInsets.only(bottom: 16),
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
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  // TODO: Sửa lịch
                },
                borderRadius: BorderRadius.circular(20),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header: Title + Bell icon
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              lich.tieuDe,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: isTask ? AppColors.warning : AppColors.textPrimary,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              // TODO: Bật/tắt thông báo
                            },
                            child: Icon(
                              lich.nhacNho ? Icons.notifications_active : Icons.notifications_none,
                              size: 20,
                              color: lich.nhacNho ? AppColors.warning : AppColors.textTertiary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),


                      const SizedBox(height: 8),

                      // Địa điểm
                      if (lich.ghiChu != null && lich.ghiChu!.contains('Phòng'))
                        Row(
                          children: [
                            Icon(Icons.location_on, size: 14, color: AppColors.textTertiary),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                lich.ghiChu!,
                                style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
                              ),
                            ),
                          ],
                        ),

                      // Nếu là task deadline
                      if (isTask)
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.warning.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.alarm, size: 12, color: AppColors.warning),
                                const SizedBox(width: 4),
                                Text(
                                  'Hạn nộp: ${_formatTime(lich.thoiGianKetThuc)}',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.warning,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ==================== CHẾ ĐỘ TUẦN ====================

  Widget _buildWeekView() {
    final now = DateTime.now();
    final startDate = now;

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 40,
      itemBuilder: (context, index) {
        final date = startDate.add(Duration(days: index));
        final lichTrongNgay = _danhSachLichImport.where((lich) {
          return lich.ngayHoc.year == date.year &&
              lich.ngayHoc.month == date.month &&
              lich.ngayHoc.day == date.day &&
              lich.gioKetThuc.isAfter(DateTime.now());
        }).toList();

        final isToday = date.year == DateTime.now().year &&
            date.month == DateTime.now().month &&
            date.day == DateTime.now().day;
        final hasEvent = lichTrongNgay.isNotEmpty;

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.02),
                blurRadius: 4,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header ngày - HIỂN THỊ CHO TẤT CẢ CÁC NGÀY
              // Header ngày - ĐẸP, CÓ ĐIỂM NHẤN
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      gradient: isToday
                          ? LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [AppColors.primary, AppColors.primaryLight],
                      )
                          : null,
                      color: isToday ? null : AppColors.surface,
                      borderRadius: BorderRadius.circular(24),
                      border: isToday
                          ? null
                          : Border.all(color: AppColors.border, width: 1),
                      boxShadow: isToday
                          ? [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ]
                          : null,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Thứ
                        Text(
                          _getDayOfWeek(date),
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: isToday ? Colors.white : AppColors.textPrimary,
                            letterSpacing: 0.3,
                          ),
                        ),
                        const SizedBox(width: 8),
                        // Dấu chấm phân cách
                        Container(
                          width: 4,
                          height: 4,
                          decoration: BoxDecoration(
                            color: isToday ? Colors.white70 : AppColors.textTertiary,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 10),
                        // Ngày/Tháng
                        Text(
                          '${date.day}/${date.month}',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: isToday ? Colors.white : AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  // Badge Rảnh (chỉ hiển thị khi KHÔNG có lịch)
                  if (!hasEvent)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [AppColors.success, AppColors.success.withOpacity(0.7)],
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.success.withOpacity(0.3),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.free_breakfast, size: 12, color: Colors.white),
                          SizedBox(width: 6),
                          Text(
                            'Rảnh',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),

              // Danh sách môn học (chỉ hiển thị khi có lịch)
              if (hasEvent)
                Padding(
                  padding: const EdgeInsets.fromLTRB(18, 0, 14, 14),
                  child: Column(
                    children: lichTrongNgay.map((lich) => _buildWeekCardFromImport(lich)).toList(),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
  Widget _buildWeekCardFromImport(LichHocImport lich) {
    // Ẩn nguồn "Thủ công" bằng cách không hiển thị nó
    String tenHienThi = lich.tenMon;
    String diaDiemHienThi = lich.diaDiem;

    // Nếu địa điểm là "Thủ công" thì không hiển thị
    if (diaDiemHienThi == 'Thủ công') {
      diaDiemHienThi = '';
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          // Chấm màu
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),

          // Giờ
          Text(
            _formatTime(lich.gioBatDau),  // "06:45"
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(width: 18),

          // Tên môn
          Expanded(
            child: Text(
              tenHienThi,
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.textPrimary,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),

          // Địa điểm (nếu có và không phải "Thủ công")
          if (diaDiemHienThi.isNotEmpty)
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.location_on, size: 12, color: AppColors.textTertiary),
                const SizedBox(width: 3),
                Text(
                  diaDiemHienThi.length > 8 ? '${diaDiemHienThi.substring(0, 8)}...' : diaDiemHienThi,
                  style: TextStyle(
                    fontSize: 11,
                    color: AppColors.textTertiary,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  // Rút gọn địa điểm
  String _getDiaDiemNgan(String diaDiem) {
    if (diaDiem.contains('C5')) {
      return diaDiem;
    }
    if (diaDiem.contains('Online')) {
      return 'Online';
    }
    return diaDiem.length > 8 ? '${diaDiem.substring(0, 8)}...' : diaDiem;
  }
  Widget _buildWeekCard(LichHoc lich) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 8,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 50,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  lich.tieuDe,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${_formatTime(lich.thoiGianBatDau)} - ${_formatTime(lich.thoiGianKetThuc)}',
                  style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  // ==================== UTILITIES ====================

  String _getDayOfWeekAbbr(DateTime date) {
    const days = ['T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'CN'];
    return days[date.weekday - 1];
  }

  String _getDayOfWeek(DateTime date) {
    const days = ['Thứ 2', 'Thứ 3', 'Thứ 4', 'Thứ 5', 'Thứ 6', 'Thứ 7', 'Chủ nhật'];
    return days[date.weekday - 1];
  }

  String _formatTime(DateTime time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  void _themLich() {
    final user = FirebaseAuth.instance.currentUser;
    if(user == null) {
      _yeuCauDangNhap();
      return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => ThemLichThuCongScreen(
              onThemLich: (lichMoi) async {
                await _lichHocService.themLichHoc(lichMoi);
                // Force refresh lại dữ liệu
                _lichHocService.layDanhSachLichHoc().listen((lichHocList) {
                  setState(() {
                    _danhSachLichImport = lichHocList;
                  });
                });
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Đã thêm lịch thành công")),
                  );
                }
              }
          ),
      ),
    );
  }

  void _yeuCauDangNhap() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Cần đăng nhập'),
        content: const Text('Vui lòng đăng nhập để sử dụng tính năng này.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Để sau'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const DangNhapScreen()),
              );
            },
            style: TextButton.styleFrom(foregroundColor: AppColors.primary),
            child: const Text('Đăng nhập'),
          ),
        ],
      ),
    );
  }
  Widget _buildToggleButton(String text, bool isSelected) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _cheDoTuan = text == 'Tuần';
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: isSelected ? AppColors.primary : Colors.white70,
          ),
        ),
      ),
    );
  }
}