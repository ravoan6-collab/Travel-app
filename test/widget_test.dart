
import 'package:flutter_test/flutter_test.dart';
import 'package:untitled3/main.dart';

void main() {
  testWidgets('Travel App starts successfully', (
      WidgetTester tester,
      ) async {
    await tester.pumpWidget(const TravelApp());

    await tester.pumpAndSettle();

    expect(find.byType(TravelApp), findsOneWidget);
  });
}
