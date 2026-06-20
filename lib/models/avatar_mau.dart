import 'package:flutter/material.dart';

class AvatarMau {
  final String id;
  final IconData icon;
  final String ten;
  final Color mauSac;

  AvatarMau({
    required this.id,
    required this.icon,
    required this.ten,
    required this.mauSac,
  });

  static List<AvatarMau> danhSachMau() {
    return [
      // Lập trình viên
      AvatarMau(id: 'dev1', icon: Icons.code, ten: 'Code', mauSac: Colors.blue),
      AvatarMau(id: 'dev2', icon: Icons.computer, ten: 'Computer', mauSac: Colors.cyan),
      AvatarMau(id: 'dev3', icon: Icons.laptop, ten: 'Laptop', mauSac: Colors.indigo),
      AvatarMau(id: 'dev4', icon: Icons.terminal, ten: 'Terminal', mauSac: Colors.deepPurple),

      // Sinh viên
      AvatarMau(id: 'student1', icon: Icons.school, ten: 'Sinh viên', mauSac: Colors.green),
      AvatarMau(id: 'student2', icon: Icons.book, ten: 'Sách', mauSac: Colors.teal),
      AvatarMau(id: 'student3', icon: Icons.library_books, ten: 'Thư viện', mauSac: Colors.lightGreen),

      // Công nghệ
      AvatarMau(id: 'tech1', icon: Icons.android, ten: 'Android', mauSac: Colors.green),
      AvatarMau(id: 'tech2', icon: Icons.apple, ten: 'Apple', mauSac: Colors.grey),
      AvatarMau(id: 'tech3', icon: Icons.cloud, ten: 'Cloud', mauSac: Colors.lightBlue),
      AvatarMau(id: 'tech4', icon: Icons.storage, ten: 'Storage', mauSac: Colors.blueGrey),
      AvatarMau(id: 'tech5', icon: Icons.security, ten: 'Bảo mật', mauSac: Colors.red),
      AvatarMau(id: 'tech6', icon: Icons.router, ten: 'Mạng', mauSac: Colors.orange),
      AvatarMau(id: 'tech7', icon: Icons.memory, ten: 'RAM', mauSac: Colors.deepPurple),

      // AI & Robot
      AvatarMau(id: 'ai1', icon: Icons.psychology, ten: 'AI', mauSac: Colors.purple),
      AvatarMau(id: 'ai2', icon: Icons.smart_toy, ten: 'Robot', mauSac: Colors.blueGrey),
      AvatarMau(id: 'ai3', icon: Icons.memory, ten: 'Chip', mauSac: Colors.indigo),

      // Game & Giải trí
      AvatarMau(id: 'game1', icon: Icons.sports_esports, ten: 'Gamer', mauSac: Colors.red),
      AvatarMau(id: 'game2', icon: Icons.videogame_asset, ten: 'Game', mauSac: Colors.purple),
      AvatarMau(id: 'game3', icon: Icons.music_note, ten: 'Âm nhạc', mauSac: Colors.pink),
      AvatarMau(id: 'game4', icon: Icons.movie, ten: 'Phim', mauSac: Colors.deepPurple),

      // Động vật
      AvatarMau(id: 'pet1', icon: Icons.pets, ten: 'Mèo', mauSac: Colors.orange),
      AvatarMau(id: 'pet2', icon: Icons.pets, ten: 'Chó', mauSac: Colors.brown),
      AvatarMau(id: 'pet3', icon: Icons.pets, ten: 'Thỏ', mauSac: Colors.pink),

      // Hình khối & Biểu tượng
      AvatarMau(id: 'shape1', icon: Icons.star, ten: 'Sao', mauSac: Colors.amber),
      AvatarMau(id: 'shape2', icon: Icons.favorite, ten: 'Trái tim', mauSac: Colors.red),
      AvatarMau(id: 'shape3', icon: Icons.circle, ten: 'Hình tròn', mauSac: Colors.blue),
      AvatarMau(id: 'shape4', icon: Icons.square, ten: 'Hình vuông', mauSac: Colors.green),

      // Phương tiện
      AvatarMau(id: 'vehicle1', icon: Icons.directions_car, ten: 'Xe hơi', mauSac: Colors.red),
      AvatarMau(id: 'vehicle2', icon: Icons.motorcycle, ten: 'Xe máy', mauSac: Colors.orange),
      AvatarMau(id: 'vehicle3', icon: Icons.directions_bike, ten: 'Xe đạp', mauSac: Colors.green),
      AvatarMau(id: 'vehicle4', icon: Icons.flight, ten: 'Máy bay', mauSac: Colors.blue),
      AvatarMau(id: 'vehicle5', icon: Icons.train, ten: 'Tàu hỏa', mauSac: Colors.brown),

      // Thể thao
      AvatarMau(id: 'sport1', icon: Icons.sports_soccer, ten: 'Bóng đá', mauSac: Colors.green),
      AvatarMau(id: 'sport2', icon: Icons.sports_basketball, ten: 'Bóng rổ', mauSac: Colors.orange),
      AvatarMau(id: 'sport3', icon: Icons.sports_tennis, ten: 'Quần vợt', mauSac: Colors.yellow),
      AvatarMau(id: 'sport4', icon: Icons.fitness_center, ten: 'Gym', mauSac: Colors.red),

      // Thiên nhiên
      AvatarMau(id: 'nature1', icon: Icons.forest, ten: 'Rừng', mauSac: Colors.green),
      AvatarMau(id: 'nature2', icon: Icons.water, ten: 'Nước', mauSac: Colors.blue),
      AvatarMau(id: 'nature3', icon: Icons.wb_sunny, ten: 'Mặt trời', mauSac: Colors.amber),
      AvatarMau(id: 'nature4', icon: Icons.nightlight, ten: 'Mặt trăng', mauSac: Colors.indigo),

      // Ẩm thực
      AvatarMau(id: 'food1', icon: Icons.lunch_dining, ten: 'Ăn trưa', mauSac: Colors.orange),
      AvatarMau(id: 'food2', icon: Icons.cake, ten: 'Bánh', mauSac: Colors.pink),
      AvatarMau(id: 'food3', icon: Icons.coffee, ten: 'Cà phê', mauSac: Colors.brown),
      AvatarMau(id: 'food4', icon: Icons.icecream, ten: 'Kem', mauSac: Colors.purple),

      // Cảm xúc
      AvatarMau(id: 'emoji1', icon: Icons.emoji_emotions, ten: 'Vui vẻ', mauSac: Colors.amber),
      AvatarMau(id: 'emoji2', icon: Icons.emoji_people, ten: 'Hạnh phúc', mauSac: Colors.pink),
      AvatarMau(id: 'emoji3', icon: Icons.emoji_nature, ten: 'Thiên nhiên', mauSac: Colors.green),
      AvatarMau(id: 'emoji4', icon: Icons.emoji_objects, ten: 'Sáng tạo', mauSac: Colors.orange),

      // Khoa học
      AvatarMau(id: 'science1', icon: Icons.science, ten: 'Khoa học', mauSac: Colors.purple),
      AvatarMau(id: 'science2', icon: Icons.medical_services, ten: 'Y tế', mauSac: Colors.red),
      AvatarMau(id: 'science3', icon: Icons.psychology, ten: 'Tâm lý học', mauSac: Colors.indigo),
    ];
  }
}