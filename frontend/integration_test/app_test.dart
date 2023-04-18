import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/Screens/search.dart';
import 'package:frontend/screens/course_landing_page.dart';
import 'package:frontend/screens/favorites.dart';
import 'package:frontend/screens/login.dart';
import 'package:frontend/screens/root_app.dart';
import 'package:frontend/widgets/bookmark_box.dart';
import 'package:frontend/widgets/bottombar_item.dart';
import 'package:frontend/widgets/category_box.dart';
import 'package:frontend/widgets/category_item.dart';
import 'package:frontend/widgets/course_item.dart';
import 'package:frontend/widgets/favorites_item.dart';
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
      // FlutterError.onError = (FlutterErrorDetails details) {
      //   if(details.exception is TypeError) {
      //     return;
      //   }
      //   FlutterError.dumpErrorToConsole(details);
      // };
      app.main();
      await widgetTester.pumpAndSettle();
      
      await widgetTester.tap(find.byKey(Key("getStartedButton")));
      await widgetTester.pumpAndSettle();

      await widgetTester.enterText(find.byKey(Key("usernameField")), "Test User");
      await widgetTester.enterText(find.byKey(Key("phoneField")), "651654984");
      await widgetTester.enterText(find.byKey(Key("emailField")), "newuser@gmail.com");
      await widgetTester.enterText(find.byKey(Key("passwordField")), "pass");
      await widgetTester.pumpAndSettle();

      await widgetTester.tap(find.byKey(Key("signupButton")));
      await widgetTester.pumpAndSettle();

      expect(find.byType(LoginPage), findsOneWidget);
      sleep(Duration(seconds: 5));
    });

    // create account using a email that already exists in database
    testWidgets("signup test BW (user already exists)", (widgetTester) async {
      // FlutterError.onError = (FlutterErrorDetails details) {
      //   if(details.exception is TypeError) {
      //     return;
      //   }
      //   FlutterError.dumpErrorToConsole(details);
      // };
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
      // FlutterError.onError = (FlutterErrorDetails details) {
      //   if(details.exception is TypeError) {
      //     return;
      //   }
      //   FlutterError.dumpErrorToConsole(details);
      // };
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
      // FlutterError.onError = (FlutterErrorDetails details) {
      //   if(details.exception is TypeError) {
      //     return;
      //   }
      //   FlutterError.dumpErrorToConsole(details);
      // };

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
      await widgetTester.pumpAndSettle(Duration(seconds: 3));
      expect(find.byType(CourseLandingPage), findsOneWidget);
    });

    // Verify that tapping on a recommended item navigates to the correct page the CourseLandingPage, using the onTap callback of the RecommendItem widget.
    testWidgets("navigate to recommended item GW", (widgetTester) async {
      // FlutterError.onError = (FlutterErrorDetails details) {
      //   if(details.exception is TypeError) {
      //     return;
      //   }
      //   FlutterError.dumpErrorToConsole(details);
      // };

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
      // FlutterError.onError = (FlutterErrorDetails details) {
      //   if(details.exception is TypeError) {
      //     return;
      //   }
      //   FlutterError.dumpErrorToConsole(details);
      // };

      app.main();
      // login
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

  group("Search-page test", () {
    //Verify that the SearchPage renders without any errors and displays the expected UI components.
    testWidgets("searchpage loaded GW", (widgetTester) async {
      app.main();
      // login
      await widgetTester.pumpAndSettle();
      await widgetTester.tap(find.byKey(Key("toLoginButton")));
      await widgetTester.pumpAndSettle();

      await widgetTester.enterText(find.byKey(Key("emailField")), "newuser@gmail.com");
      await widgetTester.enterText(find.byKey(Key("passwordField")), "pass");
      await widgetTester.pumpAndSettle();

      await widgetTester.tap(find.byKey(Key("loginButton")));
      await widgetTester.pumpAndSettle();

      // navigate to search page,
      await widgetTester.tap(find.byType(BottomBarItem).at(1));
      await widgetTester.pumpAndSettle();

      // assert that all the page widgets have been properly loaded
      expect(find.byType(SearchPage), findsOneWidget);
      expect(find.byKey(Key("searchBar")), findsOneWidget);
      expect(find.byKey(Key("categories")), findsOneWidget);
      expect(find.byType(CourseItem), findsWidgets);
    });

    // Enter a search query in the search box and submit it. Verify that the getSearchedCourses() method is called with the correct parameters, and the searched courses are displayed accordingly.
    testWidgets("search for course query GW", (widgetTester) async {
      app.main();
      // login
      await widgetTester.pumpAndSettle();
      await widgetTester.tap(find.byKey(Key("toLoginButton")));
      await widgetTester.pumpAndSettle();

      await widgetTester.enterText(find.byKey(Key("emailField")), "newuser@gmail.com");
      await widgetTester.enterText(find.byKey(Key("passwordField")), "pass");
      await widgetTester.pumpAndSettle();

      await widgetTester.tap(find.byKey(Key("loginButton")));
      await widgetTester.pumpAndSettle();

      // navigate to search page
      await widgetTester.tap(find.byType(BottomBarItem).at(1));
      await widgetTester.pumpAndSettle();

      // enter a search query into search bar
      await widgetTester.enterText(find.byKey(Key("searchTextField")), "ui");
      await widgetTester.testTextInput.receiveAction(TextInputAction.done);
      await widgetTester.pumpAndSettle();

      // assert that the searched course is being displayed
      expect(find.byType(CourseItem), findsOneWidget);
    });
    
    // Verify that clicking a category updates the search result to only show courses from that category.
    testWidgets("search results based on category GW", (widgetTester) async {
      app.main();
      // login
      await widgetTester.pumpAndSettle();
      await widgetTester.tap(find.byKey(Key("toLoginButton")));
      await widgetTester.pumpAndSettle();

      await widgetTester.enterText(find.byKey(Key("emailField")), "newuser@gmail.com");
      await widgetTester.enterText(find.byKey(Key("passwordField")), "pass");
      await widgetTester.pumpAndSettle();

      await widgetTester.tap(find.byKey(Key("loginButton")));
      await widgetTester.pumpAndSettle();

      // navigate to search page
      await widgetTester.tap(find.byType(BottomBarItem).at(1));
      await widgetTester.pumpAndSettle();

      // assert that all courses are being displayed
      expect(find.byType(CourseItem), findsWidgets);
      
      await widgetTester.tap(find.byType(CategoryItem).at(1));
      await widgetTester.pumpAndSettle();

      // assert that the search results have been narrowed down to only those in the category
      expect(find.byType(CourseItem), findsOneWidget);
      expect(find.text("Programming"), findsWidgets);
    });

    // Verify that clicking the favorites button on a course adds it to your list of favorites.
    // prerequisite: no courses have been added to favorites for this account.
    testWidgets("adding a course to favorites GW", (widgetTester) async {
      app.main();
      // login
      await widgetTester.pumpAndSettle();
      await widgetTester.tap(find.byKey(Key("toLoginButton")));
      await widgetTester.pumpAndSettle();

      await widgetTester.enterText(find.byKey(Key("emailField")), "newuser@gmail.com");
      await widgetTester.enterText(find.byKey(Key("passwordField")), "pass");
      await widgetTester.pumpAndSettle();

      await widgetTester.tap(find.byKey(Key("loginButton")));
      await widgetTester.pumpAndSettle();

      // navigate to favorites page and assert its empty
      await widgetTester.tap(find.byType(BottomBarItem).at(3));
      await widgetTester.pumpAndSettle();
      expect(find.byType(FavoritesPage), findsOneWidget);
      expect(find.byType(FavoritesItem), findsNothing);

      // navigate back to search screen and add course to favorites
      await widgetTester.tap(find.byType(BottomBarItem).at(1));
      await widgetTester.pumpAndSettle();
      expect(find.byType(SearchPage), findsOneWidget);
      await widgetTester.tap(find.byType(BookmarkBox).first);
      await widgetTester.pumpAndSettle();

      // navigate to favorites page and assert the course has been added
      await widgetTester.tap(find.byType(BottomBarItem).at(3));
      await widgetTester.pumpAndSettle();
      expect(find.byType(FavoritesPage), findsOneWidget);
      expect(find.byType(FavoritesItem), findsOneWidget);

      // undo action (for future testing)
      await widgetTester.tap(find.byType(BottomBarItem).at(1));
      await widgetTester.pumpAndSettle();
      expect(find.byType(SearchPage), findsOneWidget);
      await widgetTester.tap(find.byType(BookmarkBox).first);
      await widgetTester.pumpAndSettle();

      // navigate to favorites page and assert the course has been removed
      await widgetTester.tap(find.byType(BottomBarItem).at(3));
      await widgetTester.pumpAndSettle();
      expect(find.byType(FavoritesPage), findsOneWidget);
      expect(find.byType(FavoritesItem), findsNothing);
    });
  });

  group("My courses test", () {
    // Verify all widgets are loaded properly on the page
    testWidgets("My courses page loaded GW", (widgetTester) async {
      // login
      app.main();
      await widgetTester.pumpAndSettle();
      await widgetTester.tap(find.byKey(Key("toLoginButton")));
      await widgetTester.pumpAndSettle();

      await widgetTester.enterText(find.byKey(Key("emailField")), "newuser@gmail.com");
      await widgetTester.enterText(find.byKey(Key("passwordField")), "pass");
      await widgetTester.pumpAndSettle();

      await widgetTester.tap(find.byKey(Key("loginButton")));
      await widgetTester.pumpAndSettle();

      //
    });
  });
}