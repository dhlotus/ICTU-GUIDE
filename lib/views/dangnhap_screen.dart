import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../config/app_colors.dart';
import 'home_screen.dart';

/// Màn hình đăng nhập - Thiết kế cao cấp, hiện đại
class DangNhapScreen extends StatefulWidget {
  const DangNhapScreen({super.key});

  @override
  State<DangNhapScreen> createState() => _DangNhapScreenState();
}

class _DangNhapScreenState extends State<DangNhapScreen> {
  bool _dangTai = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height,
          ),
          child: IntrinsicHeight(
            child: Column(
              children: [
                // Phần trên: Gradient + nội dung chính
                _buildTopSection(),

                // Phần dưới: Nút đăng nhập + footer
                _buildBottomSection(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ==================== PHẦN TRÊN (GRADIENT + NỘI DUNG) ====================

  Widget _buildTopSection() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.55,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Gradient nền với đường cong phía dưới
          ClipPath(
            clipper: _WaveClipper(),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.5,
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
              ),
            ),
          ),

          // Nội dung chính
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Nút quay lại
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
                    onPressed: () => Navigator.pop(context),
                    padding: const EdgeInsets.only(left: 0, top: 8),
                  ),
                  const SizedBox(height: 40),

                  // Logo
                  Center(
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Colors.white.withOpacity(0.3),
                            Colors.white.withOpacity(0.1),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.school,
                        size: 40,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Tên app
                  const Center(
                    child: Text(
                      'ICTU GUIDE',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Slogan
                  Center(
                    child: Text(
                      'Hỗ trợ tân sinh viên ICTU',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.5,
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Illustration (placeholder - hình minh họa)
                  Center(
                    child: Container(
                      width: 200,
                      height: 120,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.smartphone,
                            size: 40,
                            color: Colors.white.withOpacity(0.8),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Học tập thông minh hơn',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white.withOpacity(0.7),
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
        ],
      ),
    );
  }

  // ==================== PHẦN DƯỚI (NÚT ĐĂNG NHẬP + FOOTER) ====================

  Widget _buildBottomSection() {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        color: AppColors.background,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            // Nút đăng nhập Google
            _dangTai
                ? const Center(child: CircularProgressIndicator())
                : _buildGoogleButton(),

            const SizedBox(height: 32),

            // Footer với điều khoản
            _buildFooter(),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildGoogleButton() {
    return GestureDetector(
      onTap: _dangNhapBangGoogle,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border, width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Google icon đa sắc màu (thay thế cho ảnh)
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Text(
                    'G',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              'Đăng nhập với Google',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return GestureDetector(
      onTap: () {
        // TODO: Mở trang điều khoản dịch vụ
      },
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          style: TextStyle(
            fontSize: 12,
            color: AppColors.textSecondary,
          ),
          children: [
            const TextSpan(text: 'Tiếp tục đồng nghĩa với việc bạn đồng ý với '),
            TextSpan(
              text: 'Điều khoản dịch vụ',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            const TextSpan(text: ' của chúng tôi'),
          ],
        ),
      ),
    );
  }

  // ==================== XỬ LÝ ĐĂNG NHẬP ====================

  Future<void> _dangNhapBangGoogle() async {
    setState(() => _dangTai = true);

    try {
      final GoogleSignInAccount? taiKhoanGoogle = await _googleSignIn.signIn();
      if (taiKhoanGoogle == null) {
        setState(() => _dangTai = false);
        return;
      }

      final GoogleSignInAuthentication xacThucGoogle = await taiKhoanGoogle.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: xacThucGoogle.accessToken,
        idToken: xacThucGoogle.idToken,
      );
      await _auth.signInWithCredential(credential);

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      }
    } catch (e) {
      setState(() => _dangTai = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Đăng nhập thất bại: $e')),
      );
    }
  }
}

// ==================== CUSTOM CLIPPER CHO ĐƯỜNG CONG ====================

class _WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 40);
    path.quadraticBezierTo(
      size.width / 2,
      size.height,
      size.width,
      size.height - 40,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}