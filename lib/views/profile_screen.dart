import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import '../config/app_colors.dart';
import '../services/storage_service.dart';
import '../services/nguoi_dung_service.dart';
import 'lich_hoc_screen.dart';
import 'home_screen.dart';
import '../models/avatar_mau.dart';
import '../widgets/avatar_widget.dart';

/// Màn hình Cá nhân - Có thể chỉnh sửa thông tin
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _hoTen = '';
  String _email = '';
  String? _avatarUrl;
  String? _avatarId;
  final bool _dangTai = false;
  bool _dangUpload = false;

  final StorageService _storageService = StorageService();
  final NguoiDungService _nguoiDungService = NguoiDungService();
  final ImagePicker _imagePicker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _layThongTinNguoiDung();
  }

  void _layThongTinNguoiDung() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    setState(() {
      _hoTen = _vietHoaChuCaiDau(user.displayName ?? 'Người dùng');
      _email = user.email ?? '';
    });

    _nguoiDungService.layAvatarUrl().then((url) {
      if (mounted && url != null) {
        setState(() {
          _avatarUrl = url;
        });
      }
    });

    // LẤY avatarId
    _nguoiDungService.layAvatarId().then((id) {
      if (mounted && id != null) {
        setState(() {
          _avatarId = id;
        });
      }
    });
  }

  /// Mở dialog chỉnh sửa thông tin
  void _moDialogChinhSua() {
    final tenController = TextEditingController(text: _vietHoaChuCaiDau(_hoTen));

    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(28),
        ),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(28),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Title
              const Center(
                child: Text(
                  'Chỉnh sửa thông tin',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Avatar Picker (Centerpiece)
              _buildAvatarPicker(),

              const SizedBox(height: 12),

              // Text hint
              const Center(
                child: Text(
                  'Chạm vào ảnh để thay đổi',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Text Field
              _buildNameTextField(tenController),

              const SizedBox(height: 28),

              // Action Buttons Row
              Row(
                children: [
                  Expanded(
                    child: _buildCancelButton(),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildSaveButton(tenController),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Avatar picker với camera badge
  Widget _buildAvatarPicker() {
    return Center(
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          // Avatar
          GestureDetector(
            onTap: _moDialogChonAvatar,
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary.withOpacity(0.1),
                border: Border.all(
                  color: AppColors.border,
                  width: 2,
                ),
              ),
              child: AvatarWidget(
                avatarId: _avatarId,
                size: 80,
                onTap: _moDialogChonAvatar,
                showBadge: true,
              ),
            ),
          ),
          // Camera badge
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
            ),
            child: const Icon(
              Icons.camera_alt,
              size: 14,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  /// Text field với character counter
  Widget _buildNameTextField(TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        TextField(
          controller: controller,
          maxLength: 20,
          // --- Thêm đoạn này ---
          onChanged: (value) {
            // Lấy vị trí con trỏ hiện tại để không bị nhảy con trỏ khi sửa text
            final selection = controller.selection;
            final capitalized = _vietHoaChuCaiDau(value);
            if (capitalized != value) {
              controller.value = TextEditingValue(
                text: capitalized,
                selection: TextSelection.collapsed(offset: selection.baseOffset),
              );
            }
          },
          // --- Hết phần thêm ---
          buildCounter: (context, {required currentLength, required isFocused, maxLength}) {
            return Text(
              '$currentLength/$maxLength',
              style: const TextStyle(
                fontSize: 11,
                color: AppColors.textTertiary,
              ),
            );
          },
          decoration: InputDecoration(
            labelText: 'Tên hiển thị',
            labelStyle: const TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: AppColors.primary, width: 2),
            ),
            prefixIcon: const Icon(Icons.person_outline, color: AppColors.primary),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          ),
        ),
      ],
    );
  }

  /// Nút Hủy
  Widget _buildCancelButton() {
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(14),
        ),
        child: const Center(
          child: Text(
            'Hủy',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }

  /// Nút Lưu
  Widget _buildSaveButton(TextEditingController controller) {
    return GestureDetector(
      onTap: () async {
        final tenMoi = controller.text.trim();
        if (tenMoi.isNotEmpty && tenMoi != _hoTen) {
          await _capNhatTen(tenMoi);
        }
        if (mounted) Navigator.pop(context);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: const Center(
          child: Text(
            'Lưu',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  /// Cập nhật tên hiển thị
  Future<void> _capNhatTen(String tenMoi) async {
    if (tenMoi.length > 20) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tên không được vượt quá 20 ký tự')),
      );
      return;
    }

    // VIẾT HOA CHỮ CÁI ĐẦU MỖI TỪ
    final tenDaChuanHoa = _vietHoaChuCaiDau(tenMoi);

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      await user.updateDisplayName(tenDaChuanHoa);
      await _nguoiDungService.capNhatTenHienThi(tenDaChuanHoa);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Đã cập nhật tên')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi: $e')),
        );
      }
    }
  }

  /// Chọn ảnh từ thư viện và upload
  Future<void> _chonVaUploadAvatar() async {
    final nguon = await showDialog<ImageSource>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Chọn ảnh đại diện'),
        content: const Text('Bạn muốn chọn ảnh từ đâu?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, ImageSource.gallery),
            child: const Text('Thư viện'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, ImageSource.camera),
            child: const Text('Chụp ảnh'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
        ],
      ),
    );

    if (nguon == null) return;

    setState(() => _dangUpload = true);

    try {
      final pickedFile = await _imagePicker.pickImage(source: nguon);
      if (pickedFile == null) {
        setState(() => _dangUpload = false);
        return;
      }

      final file = File(pickedFile.path);
      final downloadUrl = await _storageService.uploadAvatar(file);

      if (downloadUrl != null) {
        await _nguoiDungService.capNhatAvatar(downloadUrl);
        setState(() {
          _avatarUrl = downloadUrl;
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Đã cập nhật ảnh đại diện')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi: $e')),
        );
      }
    } finally {
      setState(() => _dangUpload = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: _dangTai
          ? const Center(child: CircularProgressIndicator())
          : CustomScrollView(
        slivers: [
          _buildAppBar(),
          SliverToBoxAdapter(
            child: Column(
              children: [
                _buildPremiumHeader(),
                const SizedBox(height: 16),
                _buildMenuGroup(),
                const SizedBox(height: 24),
                _buildLogoutButton(),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      title: const Text(
        'Cá nhân',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
        ),
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
      actions: [
        IconButton(
          icon: const Icon(Icons.edit, color: AppColors.primary),
          onPressed: _moDialogChinhSua,
          tooltip: 'Chỉnh sửa thông tin',
        ),
      ],
    );
  }

  Widget _buildPremiumHeader() {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          height: 160,
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.primary,
                AppColors.primaryLight,
                AppColors.accent,
              ],
            ),
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(28),
              bottomRight: Radius.circular(28),
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                right: -30,
                top: -30,
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              Positioned(
                left: -20,
                bottom: -20,
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.08),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
        ),

        Positioned(
          top: 100,
          left: 20,
          right: 20,
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              children: [
                Transform.translate(
                  offset: const Offset(0, -40),
                  child: GestureDetector(
                    onTap: _moDialogChonAvatar,
                    child: Container(
                      width: 90,
                      height: 90,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: AvatarWidget(
                        avatarId: _avatarId,
                        size: 80,
                        onTap: _moDialogChonAvatar,
                        showBadge: true,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                  child: Column(
                    children: [
                      Text(
                        _hoTen,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _email,
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 280),
      ],
    );
  }

  Widget _buildMenuGroup() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildMenuItem(
            icon: Icons.calendar_today,
            title: 'Lịch học của tôi',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const LichHocScreen()),
              );
            },
          ),
          _buildDivider(),
          _buildMenuItem(
            icon: Icons.question_answer,
            title: 'Câu hỏi của tôi',
            onTap: () {
              _thongBaoPhatTrien();
            },
          ),
          _buildDivider(),
          _buildMenuItem(
            icon: Icons.notifications,
            title: 'Cài đặt thông báo',
            onTap: () {
              _thongBaoPhatTrien();
            },
          ),
          _buildDivider(),
          _buildMenuItem(
            icon: Icons.info,
            title: 'Giới thiệu ứng dụng',
            onTap: () {
              _thongBaoPhatTrien();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, size: 20, color: AppColors.primary),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              Icon(
                Icons.chevron_right,
                size: 20,
                color: AppColors.textTertiary,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 0,
      thickness: 1,
      color: AppColors.border.withOpacity(0.5),
    );
  }

  Widget _buildLogoutButton() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _xacNhanDangXuat,
          borderRadius: BorderRadius.circular(24),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.error.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(Icons.logout, size: 20, color: AppColors.error),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    'Đăng xuất',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppColors.error,
                    ),
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  size: 20,
                  color: AppColors.error.withOpacity(0.6),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _thongBaoPhatTrien() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Tính năng đang phát triển')),
    );
  }

  void _xacNhanDangXuat() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Xác nhận đăng xuất'),
        content: const Text('Bạn có chắc chắn muốn đăng xuất không?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(
              foregroundColor: AppColors.textSecondary,
            ),
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await FirebaseAuth.instance.signOut();
              if (mounted) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const HomeScreen()),
                );
              }
            },
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Đăng xuất'),
          ),
        ],
      ),
    );
  }
  void _moDialogChonAvatar() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.5,
        minChildSize: 0.4,
        maxChildSize: 0.9,
        builder: (context, scrollController) {
          return Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
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

                // Hàng tiêu đề + nút đóng
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Chọn avatar của bạn',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.background,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.close,
                            size: 20,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Grid danh sách avatar
                Expanded(
                  child: GridView.builder(
                    controller: scrollController,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      childAspectRatio: 1,
                    ),
                    itemCount: AvatarMau.danhSachMau().length,
                    itemBuilder: (context, index) {
                      final avatar = AvatarMau.danhSachMau()[index];
                      return _buildAvatarOption(avatar);
                    },
                  ),
                ),

                const SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildAvatarOption(AvatarMau avatar) {
    final isSelected = _avatarId == avatar.id;
    return GestureDetector(
      onTap: () async {
        await _nguoiDungService.capNhatAvatarId(avatar.id);
        setState(() {
          _avatarId = avatar.id;
          _avatarUrl = null;
        });
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Đã cập nhật avatar')),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: avatar.mauSac.withOpacity(0.1),
          shape: BoxShape.circle,
          border: isSelected
              ? Border.all(color: AppColors.primary, width: 3)
              : null,
        ),
        child: CircleAvatar(
          radius: 30,
          backgroundColor: avatar.mauSac.withOpacity(0.2),
          child: Icon(avatar.icon, size: 32, color: avatar.mauSac),
        ),
      ),
    );
  }

  String _vietHoaChuCaiDau(String input) {
    if (input.isEmpty) return input;

    // Chuẩn hóa chuỗi (xóa khoảng trắng thừa ở đầu/cuối, rút gọn khoảng trắng giữa các từ)
    final normalized = input.trim().replaceAll(RegExp(r'\s+'), ' ');

    // Tách thành các từ
    final words = normalized.split(' ');

    //Viết hoa chữ cái đầu mỗi từ, các chữ cái còn lại giữ nguyên (để tránh lỗi viết thường các từ đệm)
    final capitalizedWords = words.map((word) {
      if (word.isEmpty) return word;
      return word[0].toUpperCase() + word.substring(1);
    }).toList();

    return capitalizedWords.join(' ');
  }
}