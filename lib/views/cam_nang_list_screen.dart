import 'package:flutter/material.dart';
import '../config/app_colors.dart';
import '../models/cam_nang.dart';
import 'cam_nang_detail_screen.dart';
import '../services/cam_nang_service.dart';

class CamNangListScreen extends StatefulWidget {
  const CamNangListScreen({super.key});

  @override
  State<CamNangListScreen> createState() => _CamNangListScreenState();
}

class _CamNangListScreenState extends State<CamNangListScreen> {
  String _tuKhoaTimKiem = '';
  int _danhMucDangChon = 0;
  final CamNangService _camNangService = CamNangService();

  final List<Map<String, dynamic>> _danhSachDanhMuc = [
    {'ten': 'Tất cả', 'icon': Icons.apps},
    {'ten': 'Đào tạo', 'icon': Icons.school},
    {'ten': 'Học phí', 'icon': Icons.attach_money},
    {'ten': 'Ký túc', 'icon': Icons.home},
    {'ten': 'Sự kiện', 'icon': Icons.celebration},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          _buildSliverHeader(),
          _buildSliverSearchBar(),
          _buildSliverDanhMuc(),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
              child: Text(
                'Danh sách bài viết',
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.textTertiary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          StreamBuilder<List<CamNang>>(
            stream: _camNangService.layDanhSachCamNang(),
            builder: (context, snapshot) {
              // 1. Nếu có lỗi, in lỗi ra màn hình và console
              if (snapshot.hasError) {
                print('>>> LỖI FIREBASE: ${snapshot.error}'); // Dòng này sẽ in lỗi ra cửa sổ Run
                return SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(40),
                    child: Center(
                      child: Column(
                        children: [
                          const Icon(Icons.error_outline, color: Colors.red, size: 48),
                          const SizedBox(height: 12),
                          Text(
                            'Lỗi tải dữ liệu:\n${snapshot.error}',
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Colors.red),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }

              // 2. Đang tải dữ liệu
              if (!snapshot.hasData) {
                return const SliverFillRemaining(
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              // 3. Có dữ liệu, bắt đầu lọc
              var danhSach = snapshot.data!;
              if (_danhMucDangChon != 0) {
                // Lấy tên danh mục dựa vào index đang chọn
                String tenDanhMuc = _danhSachDanhMuc[_danhMucDangChon]['ten'];
                danhSach = danhSach.where((baiViet) {
                  // So sánh danhMuc trong database với tên danh mục trên nút bấm
                  // Dùng .toLowerCase() để tránh lỗi viết hoa/viết thường
                  if (baiViet.danhMuc == null) return false;
                  return baiViet.danhMuc!.toLowerCase() == tenDanhMuc.toLowerCase();
                }).toList();
              }

              // Lọc theo từ khóa tìm kiếm (nếu có)
              if (_tuKhoaTimKiem.isNotEmpty) {
                danhSach = danhSach.where((baiViet) {
                  return baiViet.tieuDe
                      .toLowerCase()
                      .contains(_tuKhoaTimKiem.toLowerCase());
                }).toList();
              }

              // 4. Danh sách rỗng
              if (danhSach.isEmpty) {
                return const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.all(40),
                    child: Center(child: Text('Không tìm thấy bài viết')),
                  ),
                );
              }

              // 5. Hiển thị danh sách
              return SliverList(
                delegate: SliverChildBuilderDelegate(
                      (context, index) {
                    final baiViet = danhSach[index];
                    return _buildBaiVietCard(baiViet);
                  },
                  childCount: danhSach.length,
                ),
              );
            },
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 30)),
        ],
      ),
    );
  }

  // Các hàm _buildSliverHeader, _buildSliverSearchBar, _buildSliverDanhMuc, _buildBaiVietCard
  // giữ nguyên y hệt như file cũ của bạn. (Mình không copy lại để đỡ dài, bạn giữ lại code cũ của bạn ở các hàm này nhé).
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
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
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
                      color: isSelected ? Colors.white : AppColors.textSecondary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      danhMuc['ten'],
                      style: TextStyle(
                        color: isSelected ? Colors.white : AppColors.textSecondary,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
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
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
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
                          child: const Icon(Icons.menu_book, color: Colors.white, size: 32),
                        ),
                        const SizedBox(width: 16),
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
                                  Icon(Icons.access_time, size: 12, color: AppColors.textTertiary),
                                  const SizedBox(width: 4),
                                  Text(
                                    _formatDate(baiViet.ngayTao),
                                    style: TextStyle(fontSize: 11, color: AppColors.textTertiary),
                                  ),
                                  const SizedBox(width: 12),
                                  Icon(Icons.visibility, size: 12, color: AppColors.textTertiary),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${baiViet.luotXem}',
                                    style: TextStyle(fontSize: 11, color: AppColors.textTertiary),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
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
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.accent.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.local_offer, size: 10, color: AppColors.accent),
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