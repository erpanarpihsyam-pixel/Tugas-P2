import 'package:flutter_test/flutter_test.dart';
import 'package:mopro_tugasp2/main.dart';

void main() {
  testWidgets('App loads smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const KantinBuSariApp());

    // Verify that app title or store name is displayed
    expect(find.text('Kantin Bu Sari'), findsOneWidget);
  });
}
