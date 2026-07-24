import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../config/app_colors.dart';

class BanDoScreen extends StatefulWidget {
  const BanDoScreen({super.key});

  @override
  State<BanDoScreen> createState() => _BanDoScreenState();
}

class _BanDoScreenState extends State<BanDoScreen> {
  // Khởi tạo WebViewController để điều khiển trang web
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();

    // Cấu hình WebView
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted) // Cho phép chạy Javascript (cần cho bản đồ 3D)
      ..setBackgroundColor(const Color(0x00000000)) // Nền trong suốt
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Có thể thêm loading bar ở đây nếu muốn
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            // Chặn các liên kết không mong muốn
            if (request.url.startsWith('https://www.youtube.com/')) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse('https://thamquan.ictu.edu.vn/')); // Tải trang web
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background, // Màu nền chung của App
      appBar: AppBar(
        title: const Text(
          'Bản đồ ICTU',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
        ),
        centerTitle: true,
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 8),
          child: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, size: 20),
            onPressed: () => Navigator.pop(context),
          ),
        ),
      ),
      body: WebViewWidget(controller: _controller), // Hiển thị WebView
    );
  }
}