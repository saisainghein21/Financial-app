import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:financialapp/views/home_page.dart';

void main() {
  testWidgets('Update Note Test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MaterialApp(home: HomePage()));

    // Open the add note dialog
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();

    // Enter text in the TextField
    await tester.enterText(find.byType(TextField), 'Test Note');

    // Tap the add button
    await tester.tap(find.text('Add'));
    await tester.pumpAndSettle();

    // Open the update note dialog
    await tester.longPress(find.text('Test Note'));
    await tester.pumpAndSettle();

    // Verify that the dialog is displayed
    expect(find.byType(AlertDialog), findsOneWidget);

    // Enter updated text in the TextField
    await tester.enterText(find.byType(TextField), 'Updated Note');

    // Tap the update button
    await tester.tap(find.text('Add'));
    await tester.pumpAndSettle();

    // Verify that the dialog is closed
    expect(find.byType(AlertDialog), findsNothing);

    // Verify that the note is updated in the list
    expect(find.text('Updated Note'), findsOneWidget);
  });
}