import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:remember/main.dart';

void main() {
  testWidgets('App renders main navigation', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: RememberApp()));
    expect(find.text('Today'), findsWidgets);
  });
}
