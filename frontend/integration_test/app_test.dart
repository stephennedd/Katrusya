import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/Screens/search.dart';
import 'package:frontend/screens/course_landing_page.dart';
import 'package:frontend/screens/login.dart';
import 'package:frontend/screens/root_app.dart';
import 'package:frontend/widgets/bottombar_item.dart';
import 'package:frontend/widgets/category_box.dart';
import 'package:frontend/widgets/featured_item.dart';
import 'package:frontend/widgets/recommended_item.dart';
import 'package:integration_test/integration_test.dart';
import 'package:frontend/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  //TODO add tests for deleting user account

  group("Signup Test", () {
    // create a new account
    testWidgets("signup test GW", (widgetTester) async {
      FlutterError.onError = (FlutterErrorDetails details) {
        if(details.exception is TypeError) {
          return;
        }
        FlutterError.dumpErrorToConsole(details);
      };
      app.main();
      await widgetTester.pumpAndSettle();

      final toSignupScreenButton = find.byKey(Key("getStartedButton"));
      await widgetTester.tap(toSignupScreenButton);
      await widgetTester.pumpAndSettle();

      final usernameTextField = find.byKey(Key("usernameField"));
      final phoneTextField = find.byKey(Key("phoneField"));
      final emailTextField = find.byKey(Key("emailField"));
      final passwordTextField = find.byKey(Key("passwordField"));
      await widgetTester.enterText(usernameTextField, "Test User");
      await widgetTester.enterText(phoneTextField, "651654984");
      await widgetTester.enterText(emailTextField, "newuser@gmail.com");
      await widgetTester.enterText(passwordTextField, "pass");
      await widgetTester.pumpAndSettle();

      await widgetTester.tap(find.byKey(Key("signupButton")));
      await widgetTester.pumpAndSettle();

      expect(find.byType(LoginPage), findsOneWidget);
      sleep(Duration(seconds: 5));
    });

    // create account using a email that already exists in database
    testWidgets("signup test BW (user already exists)", (widgetTester) async {
      FlutterError.onError = (FlutterErrorDetails details) {
        if(details.exception is TypeError) {
          return;
        }
        FlutterError.dumpErrorToConsole(details);
      };
      app.main();
      await widgetTester.pumpAndSettle();

      final toSignupScreenButton = find.byKey(Key("getStartedButton"));
      await widgetTester.tap(toSignupScreenButton);
      await widgetTester.pumpAndSettle();

      final usernameTextField = find.byKey(Key("usernameField"));
      final phoneTextField = find.byKey(Key("phoneField"));
      final emailTextField = find.byKey(Key("emailField"));
      final passwordTextField = find.byKey(Key("passwordField"));
      await widgetTester.enterText(usernameTextField, "Test User");
      await widgetTester.enterText(phoneTextField, "651654984");
      await widgetTester.enterText(emailTextField, "newuser@gmail.com");
      await widgetTester.enterText(passwordTextField, "pass");
      await widgetTester.pumpAndSettle();

      await widgetTester.tap(find.byKey(Key("signupButton")));
      await widgetTester.pumpAndSettle();

      expect(find.byType(LoginPage), findsNothing);
      expect(find.byType(AlertDialog), findsOneWidget);
    });
  });

  group('Login Test', () {
    // login and assert that you are navigated to homepage
    testWidgets("login test GW (existing user)", (widgetTester) async {
      FlutterError.onError = (FlutterErrorDetails details) {
        if(details.exception is TypeError) {
          return;
        }
        FlutterError.dumpErrorToConsole(details);
      };
      app.main();
      await widgetTester.pumpAndSettle();

      final toLoginScreenButton = find.byKey(Key("toLoginButton"));
      await widgetTester.tap(toLoginScreenButton);
      await widgetTester.pumpAndSettle();

      final emailTextField = find.byKey(Key("emailField"));
      final passwordTextField = find.byKey(Key("passwordField"));
      await widgetTester.enterText(emailTextField, "newuser@gmail.com");
      await widgetTester.enterText(passwordTextField, "pass");
      await widgetTester.pumpAndSettle();

      await widgetTester.tap(find.byKey(Key("loginButton")));
      await widgetTester.pumpAndSettle();

      expect(find.byType(RootApp), findsOneWidget);
    });

    // login with a email that does not exist in database
    testWidgets("login test BW (user not found)", (widgetTester) async {
      app.main();
      await widgetTester.pumpAndSettle();

      final toLoginScreenButton = find.byKey(Key("toLoginButton"));
      await widgetTester.tap(toLoginScreenButton);
      await widgetTester.pumpAndSettle();

      final emailTextField = find.byKey(Key("emailField"));
      final passwordTextField = find.byKey(Key("passwordField"));
      await widgetTester.enterText(emailTextField, "unknownuser@gmail.com");
      await widgetTester.enterText(passwordTextField, "pass");
      await widgetTester.pumpAndSettle();

      await widgetTester.tap(find.byKey(Key("loginButton")));
      await widgetTester.pumpAndSettle();
      expect(find.byType(AlertDialog), findsOneWidget);
      expect(find.byType(RootApp), findsNothing);
    });

    // try tapping the login button with all fields empty (should not validate form)
    testWidgets("login test BW (all empty fields)", (widgetTester) async {
      app.main();
      await widgetTester.pumpAndSettle();

      final toLoginScreenButton = find.byKey(Key("toLoginButton"));
      await widgetTester.tap(toLoginScreenButton);
      await widgetTester.pumpAndSettle();


      await widgetTester.tap(find.byKey(Key("loginButton")));
      await widgetTester.pumpAndSettle();
      expect(find.text("Please enter an email"), findsOneWidget);
      expect(find.text("Please enter a password"), findsOneWidget);
      expect(find.byType(RootApp), findsNothing);
    });
  });
  
  group('Homepage Test', () {
    // load homepage and assert that all widgets are loaded
    testWidgets("homepage data loaded GW", (widgetTester) async {
      FlutterError.onError = (FlutterErrorDetails details) {
        if(details.exception is TypeError) {
          return;
        }
        FlutterError.dumpErrorToConsole(details);
      };

      app.main();
      await widgetTester.pumpAndSettle();
      final toLoginScreenButton = find.byKey(Key("toLoginButton"));
      await widgetTester.tap(toLoginScreenButton);
      await widgetTester.pumpAndSettle();

      final emailTextField = find.byKey(Key("emailField"));
      final passwordTextField = find.byKey(Key("passwordField"));
      await widgetTester.enterText(emailTextField, "newuser@gmail.com");
      await widgetTester.enterText(passwordTextField, "pass");
      await widgetTester.pumpAndSettle();

      await widgetTester.tap(find.byKey(Key("loginButton")));
      await widgetTester.pumpAndSettle();

      expect(find.byType(RootApp), findsOneWidget);
      expect(find.byKey(Key("usernameText")), findsWidgets);
      expect(find.byKey(Key("userProfilePicture")), findsOneWidget);
      expect(find.byKey(Key("categoriesScroll")), findsWidgets);
      expect(find.byType(CategoryBox), findsWidgets);
      expect(find.byKey(Key("featuredCarousel")), findsWidgets);
      expect(find.byType(FeaturedItem), findsWidgets);
      expect(find.byKey(Key("recommendedCarousel")), findsWidgets);
      expect(find.byType(RecommendItem), findsWidgets);
    });

    // Verify that tapping on a featured item navigates to the correct page the CourseLandingPage, using the onTap callback of the FeaturedItem widget.
    testWidgets("navigate to featured item GW", (widgetTester) async {
      FlutterError.onError = (FlutterErrorDetails details) {
        if(details.exception is TypeError) {
          return;
        }
        FlutterError.dumpErrorToConsole(details);
      };

      app.main();
      await widgetTester.pumpAndSettle();
      await widgetTester.tap(find.byKey(Key("toLoginButton")));
      await widgetTester.pumpAndSettle();

      await widgetTester.enterText(find.byKey(Key("emailField")), "newuser@gmail.com");
      await widgetTester.enterText(find.byKey(Key("passwordField")), "pass");
      await widgetTester.pumpAndSettle();

      await widgetTester.tap(find.byKey(Key("loginButton")));
      await widgetTester.pumpAndSettle();

      await widgetTester.tap(find.byType(FeaturedItem).at(1));
      await widgetTester.pumpAndSettle();
      expect(find.byType(CourseLandingPage), findsOneWidget);
    });

    // Verify that tapping on a recommended item navigates to the correct page the CourseLandingPage, using the onTap callback of the RecommendItem widget.
    testWidgets("navigate to recommended item GW", (widgetTester) async {
      FlutterError.onError = (FlutterErrorDetails details) {
        if(details.exception is TypeError) {
          return;
        }
        FlutterError.dumpErrorToConsole(details);
      };

      app.main();
      await widgetTester.pumpAndSettle();
      await widgetTester.tap(find.byKey(Key("toLoginButton")));
      await widgetTester.pumpAndSettle();

      await widgetTester.enterText(find.byKey(Key("emailField")), "newuser@gmail.com");
      await widgetTester.enterText(find.byKey(Key("passwordField")), "pass");
      await widgetTester.pumpAndSettle();

      await widgetTester.tap(find.byKey(Key("loginButton")));
      await widgetTester.pumpAndSettle();

      await widgetTester.tap(find.byType(RecommendItem).at(0));
      await widgetTester.pumpAndSettle();
      expect(find.byType(CourseLandingPage), findsOneWidget);
    });

    // Verify that tapping a category will update the featured carousel and recommended carousel.
    testWidgets("tap a category", (widgetTester) async {
      FlutterError.onError = (FlutterErrorDetails details) {
        if(details.exception is TypeError) {
          return;
        }
        FlutterError.dumpErrorToConsole(details);
      };

      app.main();
      await widgetTester.pumpAndSettle();
      await widgetTester.tap(find.byKey(Key("toLoginButton")));
      await widgetTester.pumpAndSettle();

      await widgetTester.enterText(find.byKey(Key("emailField")), "newuser@gmail.com");
      await widgetTester.enterText(find.byKey(Key("passwordField")), "pass");
      await widgetTester.pumpAndSettle();

      await widgetTester.tap(find.byKey(Key("loginButton")));
      await widgetTester.pumpAndSettle();

      await widgetTester.tap(find.byType(CategoryBox).at(1));
      await widgetTester.pumpAndSettle();

      // should only have 1 item in this list
      expect(find.byType(FeaturedItem), findsOneWidget);
      expect(find.byType(RecommendItem), findsNothing);
    });
  });

  group("Search-page Test", () {
    testWidgets("searchpage loaded GW", (widgetTester) async {
      FlutterError.onError = (FlutterErrorDetails details) {
        if(details.exception is TypeError) {
          return;
        }
        FlutterError.dumpErrorToConsole(details);
      };

      app.main();
      await widgetTester.pumpAndSettle();
      await widgetTester.tap(find.byKey(Key("toLoginButton")));
      await widgetTester.pumpAndSettle();

      await widgetTester.enterText(find.byKey(Key("emailField")), "newuser@gmail.com");
      await widgetTester.enterText(find.byKey(Key("passwordField")), "pass");
      await widgetTester.pumpAndSettle();

      await widgetTester.tap(find.byKey(Key("loginButton")));
      await widgetTester.pumpAndSettle();

      await widgetTester.tap(find.byType(BottomBarItem).at(1));
      await widgetTester.pumpAndSettle();

      expect(find.byType(SearchPage), findsOneWidget);
    });
  });
}