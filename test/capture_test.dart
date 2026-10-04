import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:remember/features/add/add_screen.dart';

void main() {
  testWidgets('AddScreen parses input and renders ConfirmCard', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: AddScreen(),
        ),
      ),
    );

    expect(find.text('Capture Reminder'), findsOneWidget);

    // Enter text in text field
    final textField = find.byType(TextField);
    expect(textField, findsOneWidget);
    await tester.enterText(textField, 'Call Rahul about rent tomorrow evening');

    // Tap parse arrow
    final parseBtn = find.byIcon(Icons.arrow_forward_rounded);
    await tester.tap(parseBtn);
    await tester.pumpAndSettle();

    // Verify ConfirmCard rendered
    expect(find.text('Parsed Items (1)'), findsOneWidget);
    expect(find.text('Commitment'), findsOneWidget);
    expect(find.text('Save Reminder'), findsOneWidget);
  });
}
