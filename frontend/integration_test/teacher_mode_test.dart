import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/main.dart' as app;
import 'package:frontend/screens/login.dart';
import 'package:frontend/widgets/bottombar_item.dart';
import 'package:integration_test/integration_test.dart';



void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  //TODO add tests for deleting user account
  String uniqueId = DateTime.now().millisecondsSinceEpoch.toString();

  group('account page test', () {
    testWidgets('signup test GW', (widgetTester) async {
      app.main();
      await widgetTester.pumpAndSettle();

      await widgetTester.tap(find.byKey(const Key('getStartedButton')));
      await widgetTester.pumpAndSettle();

      await widgetTester.enterText(find.byKey(const Key('usernameField')), 'Test User $uniqueId');
      await widgetTester.enterText(find.byKey(const Key('phoneField')), uniqueId);
      await widgetTester.enterText(find.byKey(const Key('emailField')), 'newuser$uniqueId@gmail.com');
      await widgetTester.enterText(find.byKey(const Key('passwordField')), 'pass');
      await widgetTester.pumpAndSettle();

      await widgetTester.tap(find.byKey(const Key('signupButton')));
      await widgetTester.pumpAndSettle();

      expect(find.byType(LoginPage), findsOneWidget);
    });

    testWidgets('Verify widgets load properly GW', (widgetTester) async {
      app.main();
      await widgetTester.pumpAndSettle();
      // login
      await widgetTester.enterText(find.byKey(const Key('emailField')), 'newuser$uniqueId@gmail.com');
      await widgetTester.enterText(find.byKey(const Key('passwordField')), 'pass');
      await widgetTester.pumpAndSettle();

      await widgetTester.tap(find.byKey(const Key('loginButton')));
      await widgetTester.pumpAndSettle();

      // navigate to Account page
      await widgetTester.tap(find.byType(BottomBarItem).at(4));
      await widgetTester.pumpAndSettle();

      // appbar
      expect(find.byKey(const Key('accountAppBar')), findsOneWidget);
      // profile image
      expect(find.byKey(const Key('profileImage')), findsOneWidget);
      // teacher mode switch
      expect(find.byKey(const Key('teacherModeSwitch')), findsOneWidget);
      // balance
      expect(find.byKey(const Key('balance')), findsOneWidget);
      // information
      expect(find.byKey(const Key('information')), findsOneWidget);
      // settings
      expect(find.byKey(const Key('settingsBar')), findsOneWidget);
    });
  });
}