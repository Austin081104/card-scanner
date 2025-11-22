import 'package:flutter_test/flutter_test.dart';
import 'package:card_sacnner_app/main.dart';
import 'package:card_sacnner_app/view/login/login_page.dart';
import 'package:card_sacnner_app/view/homescreen/homescreen_view.dart';

void main() {
  testWidgets('App shows LoginPage when user is not logged in', (WidgetTester tester) async {
    // Build the app with isLoggedIn = false
    await tester.pumpWidget(const MyApp());

    // Expect LoginPage to be shown
    expect(find.byType(LoginPage), findsOneWidget);
    expect(find.byType(HomescreenView), findsNothing);
  });

  testWidgets('App shows HomeScreen when user is logged in', (WidgetTester tester) async {
    // Build the app with isLoggedIn = true
    await tester.pumpWidget(const MyApp());

    // Expect HomeScreen to be shown
    expect(find.byType(HomescreenView), findsOneWidget);
    expect(find.byType(LoginPage), findsNothing);
  });
}
