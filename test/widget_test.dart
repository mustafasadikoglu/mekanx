// This is a basic Flutter widget test for Mekanx app.
import 'package:flutter_test/flutter_test.dart';
import 'package:mekanx/main.dart';

void main() {
  testWidgets('Mekanx app smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MekanxApp());

    // Verify that the splash screen shows the title 'Mekanx'.
    expect(find.text('Mekanx'), findsOneWidget);
    
    // Verify that it asks 'Bugün nasıl hissediyorsun?'.
    expect(find.text('Bugün nasıl hissediyorsun?'), findsOneWidget);
  });
}
