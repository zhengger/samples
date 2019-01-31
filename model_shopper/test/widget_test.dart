// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:model_shopper/main.dart';
import 'package:model_shopper/models/cart.dart';
import 'package:scoped_model/scoped_model.dart';

void main() {
  testWidgets('app smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      ScopedModel<CartModel>(
        model: CartModel(),
        child: MyApp(),
      ),
    );

    // Verify that our app starts at the login screen.
    expect(find.text('Welcome'), findsOneWidget);
    expect(find.text('Catalog'), findsNothing);

    // Tap 'Enter'.
    await tester.tap(find.text('ENTER').first);
    await tester.pumpAndSettle();

    // Verify that we changed screens.
    expect(find.text('Welcome'), findsNothing);
    expect(find.text('Catalog'), findsOneWidget);
  });
}
