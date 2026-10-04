import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:remember/features/today/today_screen.dart';

void main() {
  testWidgets('TodayScreen renders empty state or list view', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: TodayScreen(),
        ),
      ),
    );

    await tester.pump();
    expect(find.text('Remember Today'), findsOneWidget);
  });
}
