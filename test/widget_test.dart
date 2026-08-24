import 'package:city_pulse/main.dart';
import 'package:flutter_test/flutter_test.dart';



void main() {
  testWidgets('CityPulse loads and shows the check button', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const CityPulseApp());

    // Title is visible on load.
    expect(find.text('CityPulse'), findsOneWidget);

    // The Check City button is present before any check is run.
    expect(find.text('Check City'), findsOneWidget);

    // No result or error card should be showing yet.
    expect(find.text('Something went wrong'), findsNothing);
  });
}
