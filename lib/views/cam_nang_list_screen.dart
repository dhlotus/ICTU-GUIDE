import 'package:flutter/material.dart';
import '../config/app_colors.dart';
import '../models/cam_nang.dart';
import 'cam_nang_detail_screen.dart';

/// Màn hình danh sách Cẩm nang - Thiết kế cao cấp 2026
class CamNangListScreen extends StatefulWidget {
  const CamNangListScreen({super.key});

  @override
  State<CamNangListScreen> createState() => _CamNangListScreenState();
}

class _CamNangListScreenState extends State<CamNangListScreen> {
  late List<CamNang> _danhSachCamNang;
  String _tuKhoaTimKiem = '';
  int _danhMucDangChon = 0;

  final List<Map<String, dynamic>> _danhSachDanhMuc = [
    {'ten': 'Tất cả', 'icon': Icons.apps},
    {'ten': 'Đào tạo', 'icon': Icons.school},
    {'ten': 'Học phí', 'icon': Icons.attach_money},
    {'ten': 'Ký túc', 'icon': Icons.home},
    {'ten': 'Sự kiện', 'icon': Icons.celebration},
  ];

  @override
  void initState() {
    super.initState();
    _danhSachCamNang = [
      CamNang(
        id: '1',
        tieuDe: 'Hướng dẫn đăng ký tín chỉ',
        noiDung:
            'Hướng dẫn chi tiết các bước đăng ký môn học qua cổng thông tin sinh viên. Bao gồm: cách chọn môn, xác nhận và nộp học phí.',
        ngayTao: DateTime.now(),
        luotXem: 1200,
      ),
      CamNang(
        id: '2',
        tieuDe: 'Quy định đào tạo tín chỉ',
        noiDung:
            'Các quy định mới nhất về đào tạo theo hệ thống tín chỉ, áp dụng từ năm học 2025-2026.',
        ngayTao: DateTime.now(),
        luotXem: 856,
      ),
      CamNang(
        id: '3',
        tieuDe: 'Hướng dẫn đóng học phí',
        noiDung:
            'Các phương thức đóng học phí trực tuyến, hướng dẫn thanh toán qua ngân hàng và ví điện tử.',
        ngayTao: DateTime.now(),
        luotXem: 543,
      ),
      CamNang(
        id: '4',
        tieuDe: 'Sơ đồ các phòng ban',
        noiDung:
            'Vị trí và chức năng của các phòng ban trong trường, giúp sinh viên dễ dàng liên hệ khi cần.',
        ngayTao: DateTime.now(),
        luotXem: 432,
      ),
      CamNang(
        id: '5',
        tieuDe: 'Thư viện ICTU: Hướng dẫn mượn sách',
        noiDung:
            'Quy trình mượn/trả sách tại thư viện, tra cứu tài liệu trực tuyến.',
        ngayTao: DateTime.now(),
        luotXem: 312,
      ),
    ];
  }

  List<CamNang> get _danhSachLoc {
    var ketQua = _danhSachCamNang;

    if (_danhMucDangChon != 0) {
      // Demo lọc theo danh mục
      ketQua = ketQua.where((item) {
        if (_danhMucDangChon == 1) return item.id == '1' || item.id == '2';
        if (_danhMucDangChon == 2) return item.id == '3';
        return true;
      }).toList();
    }

    if (_tuKhoaTimKiem.isNotEmpty) {
      ketQua = ketQua.where((item) {
        return item.tieuDe.toLowerCase().contains(_tuKhoaTimKiem.toLowerCase());
      }).toList();
    }

    return ketQua;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // Header đẹp
          _buildSliverHeader(),

          // Search bar
          _buildSliverSearchBar(),

          // Danh mục
          _buildSliverDanhMuc(),

          // Kết quả tìm kiếm
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
              child: Text(
                '${_danhSachLoc.length} bài viết',
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.textTertiary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),

          // Danh sách bài viết
          _danhSachLoc.isEmpty
              ? const SliverFillRemaining(
                  child: Center(child: Text('Không tìm thấy bài viết')),
                )
              : SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final baiViet = _danhSachLoc[index];
                    return _buildBaiVietCard(baiViet);
                  }, childCount: _danhSachLoc.length),
                ),

          const SliverToBoxAdapter(child: SizedBox(height: 30)),
        ],
      ),
    );
  }

  /// Header dạng Sliver (cuộn mượt)
  Widget _buildSliverHeader() {
    return SliverAppBar(
      expandedHeight: 100,
      pinned: true,
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
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsets.only(left: 56, bottom: 12),
        title: const Text(
          'Cẩm nang sinh viên',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [AppColors.surface, AppColors.background],
            ),
          ),
        ),
      ),
    );
  }

  /// Search bar dạng Sliver
  Widget _buildSliverSearchBar() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
        child: Container(
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
              hintText: 'Tìm kiếm bài viết...',
              hintStyle: TextStyle(color: AppColors.textTertiary),
              prefixIcon: Icon(Icons.search, color: AppColors.textTertiary),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 14),
            ),
          ),
        ),
      ),
    );
  }

  /// Danh mục dạng Sliver - cuộn ngang
  Widget _buildSliverDanhMuc() {
    return SliverToBoxAdapter(
      child: SizedBox(
        height: 50,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          itemCount: _danhSachDanhMuc.length,
          separatorBuilder: (_, __) => const SizedBox(width: 12),
          itemBuilder: (context, index) {
            final danhMuc = _danhSachDanhMuc[index];
            final isSelected = index == _danhMucDangChon;

            return GestureDetector(
              onTap: () {
                setState(() {
                  _danhMucDangChon = index;
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary : Colors.transparent,
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    color: isSelected ? Colors.transparent : AppColors.border,
                    width: 1.2,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      danhMuc['icon'],
                      size: 18,
                      color: isSelected
                          ? Colors.white
                          : AppColors.textSecondary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      danhMuc['ten'],
                      style: TextStyle(
                        color: isSelected
                            ? Colors.white
                            : AppColors.textSecondary,
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  /// Card bài viết đẹp
  Widget _buildBaiVietCard(CamNang baiViet) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CamNangDetailScreen(baiViet: baiViet),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CamNangDetailScreen(baiViet: baiViet),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Hàng trên: ảnh nhỏ + tag
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Ảnh thumbnail
                        Container(
                          width: 70,
                          height: 70,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [AppColors.primary, AppColors.accent],
                            ),
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: const Icon(
                            Icons.menu_book,
                            color: Colors.white,
                            size: 32,
                          ),
                        ),
                        const SizedBox(width: 16),

                        // Nội dung chính
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                baiViet.tieuDe,
                                style: const TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                  height: 1.3,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  Icon(
                                    Icons.access_time,
                                    size: 12,
                                    color: AppColors.textTertiary,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    _formatDate(baiViet.ngayTao),
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: AppColors.textTertiary,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Icon(
                                    Icons.visibility,
                                    size: 12,
                                    color: AppColors.textTertiary,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${baiViet.luotXem}',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: AppColors.textTertiary,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    // Mô tả
                    Text(
                      baiViet.noiDung,
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                        height: 1.4,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: 12),

                    // Tag ở dưới cùng
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.accent.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.local_offer,
                            size: 10,
                            color: AppColors.accent,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Đào tạo',
                            style: TextStyle(
                              fontSize: 11,
                              color: AppColors.accentDark,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
