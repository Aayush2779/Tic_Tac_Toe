import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sizer/sizer.dart';

import 'package:flutter_application/main.dart'; // 👈 Update this to match your app name

void main() {
  testWidgets('Tapping cells places O and X alternately', (WidgetTester tester) async {
    await tester.pumpWidget(
      Sizer(
        builder: (context, orientation, deviceType) {
          return const MaterialApp(
            home: HomePage(),
          );
        },
      ),
    );

    // First tap should show 'O'
    await tester.tap(find.byType(GestureDetector).at(0));
    await tester.pump();
    expect(find.text('O'), findsOneWidget);

    // Second tap should show 'X'
    await tester.tap(find.byType(GestureDetector).at(1));
    await tester.pump();
    expect(find.text('X'), findsOneWidget);

    // Third tap should show another 'O'
    await tester.tap(find.byType(GestureDetector).at(2));
    await tester.pump();
    expect(find.text('O'), findsNWidgets(2));
  });

  testWidgets('Clear Score Board resets scores and board', (WidgetTester tester) async {
    await tester.pumpWidget(
      Sizer(
        builder: (context, orientation, deviceType) {
          return const MaterialApp(
            home: HomePage(),
          );
        },
      ),
    );

    // Make some moves
    await tester.tap(find.byType(GestureDetector).at(0));
    await tester.pump();
    await tester.tap(find.byType(GestureDetector).at(1));
    await tester.pump();

    expect(find.text('O'), findsOneWidget);
    expect(find.text('X'), findsOneWidget);

    // Tap "Clear Score Board"
    await tester.tap(find.text('Clear Score Board'));
    await tester.pumpAndSettle();

    // Verify board is cleared
    expect(find.text('O'), findsNothing);
    expect(find.text('X'), findsNothing);
  });
}
