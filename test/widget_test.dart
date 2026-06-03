import 'package:flutter_test/flutter_test.dart';
import 'package:app/main.dart';

void main() {
  testWidgets('App builds', (tester) async {
    await tester.pumpWidget(const App());
  });
}
