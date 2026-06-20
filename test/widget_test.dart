import 'package:flutter_test/flutter_test.dart';
import 'package:ictu_guide/main.dart';

void main() {
  testWidgets('ICTU Guide app test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const ICTUGuideApp());

    // Kiểm tra xem app có chạy được không
    expect(find.text('ICTU Guide'), findsWidgets);
  });
}