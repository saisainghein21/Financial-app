import 'package:financialapp/views/top_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('TopNeuCard Widget Test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: TopNeuCard(
            balance: '1000',
            income: '500',
            expense: '200',
          ),
        ),
      ),
    );

    // Verify that the 'B A L A N C E' text is displayed
    expect(find.text('B A L A N C E'), findsOneWidget);

    // Verify that the balance amount is displayed
    expect(find.text('\$1000'), findsOneWidget);

    // Verify that the 'Income' and 'Expense' texts are displayed
    expect(find.text('Income'), findsOneWidget);
    expect(find.text('Expense'), findsOneWidget);

    // Verify that the income and expense amounts are displayed
    expect(find.text('\$500'), findsOneWidget);
    expect(find.text('\$200'), findsOneWidget);
  });
}
