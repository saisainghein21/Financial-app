import 'package:financialapp/views/plus_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('PlusButton Widget Test', (WidgetTester tester) async {
    // Define a variable to check if the button is tapped
    bool isTapped = false;

    // Build our app and trigger a frame.
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: PlusButton(
            function: () {
              // Set the variable to true when the button is tapped
              isTapped = true;
            },
          ),
        ),
      ),
    );

    // Verify that the button is initially not tapped
    expect(isTapped, isFalse);

    // Tap on the PlusButton
    await tester.tap(find.byType(PlusButton));
    await tester.pumpAndSettle();

    // Verify that the button is tapped after the tap action
    expect(isTapped, isTrue);

    // Example: Verify that the container has a BoxDecoration with a certain color
    final containerDecoration =
        tester.widget<Container>(find.byType(Container));
    expect(containerDecoration.decoration, isA<Decoration>());
    expect((containerDecoration.decoration as BoxDecoration).color,
        equals(const Color(0xFFeaddff)));

    // Example: Verify that the GestureDetector is present
    expect(find.byType(GestureDetector), findsOneWidget);

    // Example: Verify that the Icon is present with the specified properties
    final iconWidget = tester.widget<Icon>(find.byIcon(Icons.add));
    expect(iconWidget.icon, equals(Icons.add));
    expect(iconWidget.color, equals(Colors.black));
    expect(iconWidget.size, equals(30));
  });
}
