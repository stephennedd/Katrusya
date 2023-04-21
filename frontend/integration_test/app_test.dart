import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/Screens/search.dart';
import 'package:frontend/screens/course_landing_page.dart';
import 'package:frontend/screens/favorites.dart';
import 'package:frontend/screens/home.dart';
import 'package:frontend/screens/login.dart';
import 'package:frontend/screens/root_app.dart';
import 'package:frontend/widgets/bookmark_box.dart';
import 'package:frontend/widgets/bottombar_item.dart';
import 'package:frontend/widgets/category_box.dart';
import 'package:frontend/widgets/category_item.dart';
import 'package:frontend/widgets/course_complete_item.dart';
import 'package:frontend/widgets/course_item.dart';
import 'package:frontend/widgets/favorites_item.dart';
import 'package:frontend/widgets/featured_item.dart';
import 'package:frontend/widgets/recommended_item.dart';
import 'package:integration_test/integration_test.dart';
import 'package:frontend/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  String uniqueId = DateTime.now().millisecondsSinceEpoch.toString();

  group('Signup Test', () {
    // T1: create a new account
    testWidgets('T1: signup test GW', (widgetTester) async {
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

      // verify the login page is shown and no errors
      expect(find.byType(AlertDialog), findsNothing);
      expect(find.byType(LoginPage), findsOneWidget);
    });

    // T2: create account using a email that already exists in database
    testWidgets('T2 signup test BW (user already exists)', (widgetTester) async {

      // sign up
      app.main();
      await widgetTester.pumpAndSettle();

      final toSignupScreenButton = find.byKey(const Key('getStartedButton'));
      await widgetTester.tap(toSignupScreenButton);
      await widgetTester.pumpAndSettle();

      await widgetTester.enterText(find.byKey(const Key('usernameField')), 'Test User $uniqueId');
      await widgetTester.enterText(find.byKey(const Key('phoneField')), uniqueId);
      await widgetTester.enterText(find.byKey(const Key('emailField')), 'newuser$uniqueId@gmail.com');
      await widgetTester.enterText(find.byKey(const Key('passwordField')), 'pass');
      await widgetTester.pumpAndSettle();

      await widgetTester.tap(find.byKey(const Key('signupButton')));
      await widgetTester.pumpAndSettle();

      expect(find.byType(LoginPage), findsNothing);
      expect(find.byType(AlertDialog), findsOneWidget);
    });
  });

  group('Login Test', () {
    // T3: login and assert that you are navigated to homepage
    testWidgets('T3 login test GW (existing user found)', (widgetTester) async {

      // login
      app.main();
      await widgetTester.pumpAndSettle();

      final toLoginScreenButton = find.byKey(const Key('toLoginButton'));
      await widgetTester.tap(toLoginScreenButton);
      await widgetTester.pumpAndSettle();

      await widgetTester.enterText(find.byKey(const Key('emailField')), 'newuser$uniqueId@gmail.com');
      await widgetTester.enterText(find.byKey(const Key('passwordField')), 'pass');
      await widgetTester.pumpAndSettle();

      await widgetTester.tap(find.byKey(const Key('loginButton')));
      await widgetTester.pumpAndSettle();

      // verify that the homepage is shown
      expect(find.byType(RootApp), findsOneWidget);
    });

    //T4: login with a email that does not exist in database
    testWidgets('T4 login test BW (no existing user found)', (widgetTester) async {
      // login
      app.main();
      await widgetTester.pumpAndSettle();

      final toLoginScreenButton = find.byKey(const Key('toLoginButton'));
      await widgetTester.tap(toLoginScreenButton);
      await widgetTester.pumpAndSettle();

      await widgetTester.enterText(find.byKey(const Key('emailField')), 'unknownuser@gmail.com');
      await widgetTester.enterText(find.byKey(const Key('passwordField')), 'pass');
      await widgetTester.pumpAndSettle();

      await widgetTester.tap(find.byKey(const Key('loginButton')));
      await widgetTester.pumpAndSettle();

      // verify that the error dialog box is shown
      expect(find.byType(AlertDialog), findsOneWidget);
      expect(find.byType(RootApp), findsNothing);
    });

    //T5: try tapping the login button with all fields empty (should not validate form)
    testWidgets('T5 login test BW (all empty fields)', (widgetTester) async {
      app.main();
      await widgetTester.pumpAndSettle();

      final toLoginScreenButton = find.byKey(const Key('toLoginButton'));
      await widgetTester.tap(toLoginScreenButton);
      await widgetTester.pumpAndSettle();


      await widgetTester.tap(find.byKey(const Key('loginButton')));
      await widgetTester.pumpAndSettle();
      expect(find.text('Please enter an email'), findsOneWidget);
      expect(find.text('Please enter a password'), findsOneWidget);
      expect(find.byType(RootApp), findsNothing);
    });
  });
  
  group('Homepage Test', () {
    //T6: load homepage and assert that all widgets are loaded
    testWidgets('T6 homepage data loaded GW', (widgetTester) async {
      // login
      app.main();
      await widgetTester.pumpAndSettle();
      final toLoginScreenButton = find.byKey(const Key('toLoginButton'));
      await widgetTester.tap(toLoginScreenButton);
      await widgetTester.pumpAndSettle();

      await widgetTester.enterText(find.byKey(const Key('emailField')), 'newuser$uniqueId@gmail.com');
      await widgetTester.enterText(find.byKey(const Key('passwordField')), 'pass');
      await widgetTester.pumpAndSettle();

      await widgetTester.tap(find.byKey(const Key('loginButton')));
      await widgetTester.pumpAndSettle();

      // verify all the widgets are shown on homepage
      expect(find.byType(RootApp), findsOneWidget);
      expect(find.byKey(const Key('usernameText')), findsWidgets);
      expect(find.byKey(const Key('userProfilePicture')), findsOneWidget);
      expect(find.byKey(const Key('categoriesScroll')), findsWidgets);
      expect(find.byType(CategoryBox), findsWidgets);
      expect(find.byKey(const Key('featuredCarousel')), findsWidgets);
      expect(find.byType(FeaturedItem), findsWidgets);
      expect(find.byKey(const Key('recommendedCarousel')), findsWidgets);
      expect(find.byType(RecommendItem), findsWidgets);
    });

    //T7: Verify that tapping on a featured item navigates to the correct page the CourseLandingPage, using the onTap callback of the FeaturedItem widget.
    testWidgets('T7 navigate to featured item GW', (widgetTester) async {
      app.main();
      await widgetTester.pumpAndSettle();
      await widgetTester.tap(find.byKey(const Key('toLoginButton')));
      await widgetTester.pumpAndSettle();

      await widgetTester.enterText(find.byKey(const Key('emailField')), 'newuser$uniqueId@gmail.com');
      await widgetTester.enterText(find.byKey(const Key('passwordField')), 'pass');
      await widgetTester.pumpAndSettle();

      await widgetTester.tap(find.byKey(const Key('loginButton')));
      await widgetTester.pumpAndSettle();

      await widgetTester.tap(find.byKey(const Key('featuredItem1')));
      await widgetTester.pumpAndSettle();
      expect(find.byType(CourseLandingPage), findsOneWidget);
    });

    //T8: Verify that tapping on a recommended item navigates to the correct page the CourseLandingPage, using the onTap callback of the RecommendItem widget.
    testWidgets('T8 navigate to recommended item GW', (widgetTester) async {

      app.main();
      await widgetTester.pumpAndSettle();
      await widgetTester.tap(find.byKey(const Key('toLoginButton')));
      await widgetTester.pumpAndSettle();

      await widgetTester.enterText(find.byKey(const Key('emailField')), 'newuser$uniqueId@gmail.com');
      await widgetTester.enterText(find.byKey(const Key('passwordField')), 'pass');
      await widgetTester.pumpAndSettle();

      await widgetTester.tap(find.byKey(const Key('loginButton')));
      await widgetTester.pumpAndSettle();

      await widgetTester.tap(find.byType(RecommendItem).at(0));
      await widgetTester.pumpAndSettle();
      expect(find.byType(CourseLandingPage), findsOneWidget);
    });

    //T9: Verify that tapping a category will update the featured carousel and recommended carousel.
    testWidgets('T9 tap a category', (widgetTester) async {

      app.main();
      // login
      await widgetTester.pumpAndSettle();
      await widgetTester.tap(find.byKey(const Key('toLoginButton')));
      await widgetTester.pumpAndSettle();

      await widgetTester.enterText(find.byKey(const Key('emailField')), 'newuser$uniqueId@gmail.com');
      await widgetTester.enterText(find.byKey(const Key('passwordField')), 'pass');
      await widgetTester.pumpAndSettle();

      await widgetTester.tap(find.byKey(const Key('loginButton')));
      await widgetTester.pumpAndSettle();

      await widgetTester.tap(find.byType(CategoryBox).at(1));
      await widgetTester.pumpAndSettle();

      // should only have 1 item in this list
      expect(find.byType(FeaturedItem), findsOneWidget);
      expect(find.byType(RecommendItem), findsNothing);
    });
  });

  group('Search-page test', () {
    //T10: Verify that the SearchPage renders without any errors and displays the expected UI components.
    testWidgets('T10 search-page loaded GW', (widgetTester) async {
      app.main();
      // login
      await widgetTester.pumpAndSettle();
      await widgetTester.tap(find.byKey(const Key('toLoginButton')));
      await widgetTester.pumpAndSettle();

      await widgetTester.enterText(find.byKey(const Key('emailField')), 'newuser$uniqueId@gmail.com');
      await widgetTester.enterText(find.byKey(const Key('passwordField')), 'pass');
      await widgetTester.pumpAndSettle();

      await widgetTester.tap(find.byKey(const Key('loginButton')));
      await widgetTester.pumpAndSettle();

      // navigate to search page,
      await widgetTester.tap(find.byType(BottomBarItem).at(1));
      await widgetTester.pumpAndSettle();

      // assert that all the page widgets have been properly loaded
      expect(find.byType(SearchPage), findsOneWidget);
      expect(find.byKey(const Key('searchBar')), findsOneWidget);
      expect(find.byKey(const Key('categories')), findsOneWidget);
      expect(find.byType(CourseItem), findsWidgets);
    });

    //T11: Enter a search query in the search box and submit it. Verify that the getSearchedCourses() method is called with the correct parameters, and the searched courses are displayed accordingly.
    testWidgets('T11 search for course query GW', (widgetTester) async {
      app.main();
      // login
      await widgetTester.pumpAndSettle();
      await widgetTester.tap(find.byKey(const Key('toLoginButton')));
      await widgetTester.pumpAndSettle();

      await widgetTester.enterText(find.byKey(const Key('emailField')), 'newuser$uniqueId@gmail.com');
      await widgetTester.enterText(find.byKey(const Key('passwordField')), 'pass');
      await widgetTester.pumpAndSettle();

      await widgetTester.tap(find.byKey(const Key('loginButton')));
      await widgetTester.pumpAndSettle();

      // navigate to search page
      await widgetTester.tap(find.byType(BottomBarItem).at(1));
      await widgetTester.pumpAndSettle();

      // enter a search query into search bar
      await widgetTester.enterText(find.byKey(const Key('searchTextField')), 'ui');
      await widgetTester.testTextInput.receiveAction(TextInputAction.done);
      await widgetTester.pumpAndSettle();

      // assert that the searched course is being displayed
      expect(find.byType(CourseItem), findsOneWidget);
    });
    
    //T12: Verify that clicking a category updates the search result to only show courses from that category.
    testWidgets('T12 search results based on category GW', (widgetTester) async {
      app.main();
      // login
      await widgetTester.pumpAndSettle();
      await widgetTester.tap(find.byKey(const Key('toLoginButton')));
      await widgetTester.pumpAndSettle();

      await widgetTester.enterText(find.byKey(const Key('emailField')), 'newuser$uniqueId@gmail.com');
      await widgetTester.enterText(find.byKey(const Key('passwordField')), 'pass');
      await widgetTester.pumpAndSettle();

      await widgetTester.tap(find.byKey(const Key('loginButton')));
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
      expect(find.text('Programming'), findsWidgets);
    });

    //T13: Verify that clicking the favorites button on a course adds it to your list of favorites and clicking the favorite button twice removes it.
    testWidgets('T13 adding a course to favorites GW', (widgetTester) async {
      app.main();
      // login
      await widgetTester.pumpAndSettle();
      await widgetTester.tap(find.byKey(const Key('toLoginButton')));
      await widgetTester.pumpAndSettle();

      await widgetTester.enterText(find.byKey(const Key('emailField')), 'newuser$uniqueId@gmail.com');
      await widgetTester.enterText(find.byKey(const Key('passwordField')), 'pass');
      await widgetTester.pumpAndSettle();

      await widgetTester.tap(find.byKey(const Key('loginButton')));
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

      // unfavorite course
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

  group('My courses test', () {
    //T14: Verify all widgets are loaded properly on the page
    testWidgets('T14 my courses page loaded GW', (widgetTester) async {
      // login
      app.main();
      await widgetTester.pumpAndSettle();
      await widgetTester.tap(find.byKey(const Key('toLoginButton')));
      await widgetTester.pumpAndSettle();

      await widgetTester.enterText(find.byKey(const Key('emailField')), 'newuser$uniqueId@gmail.com');
      await widgetTester.enterText(find.byKey(const Key('passwordField')), 'pass');
      await widgetTester.pumpAndSettle();

      await widgetTester.tap(find.byKey(const Key('loginButton')));
      await widgetTester.pumpAndSettle();

      // go to my courses page
      await widgetTester.tap(find.byType(BottomBarItem).at(2));
      await widgetTester.pumpAndSettle();

      // assert the widgets are loaded
      expect(find.text('My Courses'), findsOneWidget);
      expect(find.byType(TabBar), findsOneWidget);
    });

    //T15: Verify that courses that are purchased are added to my courses
    testWidgets('T15 my courses shows courses that are purchased GW', (widgetTester) async {
      // login
      app.main();
      await widgetTester.pumpAndSettle();
      await widgetTester.tap(find.byKey(const Key('toLoginButton')));
      await widgetTester.pumpAndSettle();

      await widgetTester.enterText(find.byKey(const Key('emailField')), 'newuser$uniqueId@gmail.com');
      //await widgetTester.enterText(find.byKey(Key("emailField")), "newuser@gmail.com");
      await widgetTester.enterText(find.byKey(const Key('passwordField')), 'pass');
      await widgetTester.pumpAndSettle();

      await widgetTester.tap(find.byKey(const Key('loginButton')));
      await widgetTester.pumpAndSettle();

      // go to my courses page and make sure the course has not been purchased
      await widgetTester.tap(find.byType(BottomBarItem).at(2));
      await widgetTester.pumpAndSettle();
      
      expect(find.byType(CourseCompleteItem), findsNothing);


      // go to homepage and click on course buy it and return to my courses
      await widgetTester.tap(find.byType(BottomBarItem).at(0));
      await widgetTester.pumpAndSettle();

      await widgetTester.tap(find.text('Programming').first);
      await widgetTester.pumpAndSettle();

      await widgetTester.tap(find.byKey(const Key('buyCourseButton')));
      await widgetTester.pumpAndSettle();

      await widgetTester.tap(find.byType(BackButton).first);
      await widgetTester.pumpAndSettle();

      await widgetTester.tap(find.byType(BottomBarItem).at(2));
      await widgetTester.pumpAndSettle();

      // expect to find the purchased course in the list
      expect(find.byType(CourseCompleteItem), findsOneWidget);
    });
  });

  group('Wishlist test', () {
    //T:16 Verify the wishlist page loads and all the widgets are shown
    testWidgets('T16 widgets loaded GW', (widgetTester) async {
      app.main();
      // login
      await widgetTester.pumpAndSettle();
      await widgetTester.tap(find.byKey(const Key('toLoginButton')));
      await widgetTester.pumpAndSettle();

      await widgetTester.enterText(find.byKey(const Key('emailField')), 'newuser$uniqueId@gmail.com');
      //await widgetTester.enterText(find.byKey(const Key('emailField')), 'newuser@gmail.com');
      await widgetTester.enterText(find.byKey(const Key('passwordField')), 'pass');
      await widgetTester.pumpAndSettle();

      await widgetTester.tap(find.byKey(const Key('loginButton')));
      await widgetTester.pumpAndSettle();

      // go to wishlist page
      await widgetTester.tap(find.byType(BottomBarItem).at(3));
      await widgetTester.pumpAndSettle();

      expect(find.byType(FavoritesPage), findsOneWidget);
      expect(find.byKey(const Key('favoritesList')), findsOneWidget);
      expect(find.byKey(const Key('favoritesAppBar')), findsOneWidget);
    });

    //T:17 Verify that favorites can be removed by swiping
    testWidgets('T17 Swipe to remove', (widgetTester) async {
      app.main();
      // login
      await widgetTester.pumpAndSettle();
      await widgetTester.tap(find.byKey(const Key('toLoginButton')));
      await widgetTester.pumpAndSettle();

      await widgetTester.enterText(find.byKey(const Key('emailField')), 'newuser$uniqueId@gmail.com');
      //await widgetTester.enterText(find.byKey(const Key('emailField')), 'newuser@gmail.com');
      await widgetTester.enterText(find.byKey(const Key('passwordField')), 'pass');
      await widgetTester.pumpAndSettle();

      await widgetTester.tap(find.byKey(const Key('loginButton')));
      await widgetTester.pumpAndSettle();

      await widgetTester.tap(find.byType(CourseItem).first);
      await widgetTester.pumpAndSettle();

      await widgetTester.tap(find.byType(BookmarkBox).first);
      await widgetTester.pumpAndSettle();

      // goto homepage
      await widgetTester.tap(find.byType(BackButton));
      await widgetTester.pumpAndSettle();
      expect(find.byType(HomePage), findsOneWidget);

      // go to wishlist page
      await widgetTester.tap(find.byType(BottomBarItem).at(3));
      await widgetTester.pumpAndSettle();
      expect(find.byType(FavoritesPage), findsOneWidget);
      expect(find.byType(FavoritesItem), findsWidgets);

      // drag the item off the screen and assert that the dialog box shows
      await widgetTester.drag(find.byType(FavoritesItem).first, const Offset(200, 0));
      await widgetTester.pumpAndSettle();
      expect(find.byType(CupertinoAlertDialog), findsOneWidget);
    });

    // T18: Verify that users can navigate to the course from the favorites page
    testWidgets('T18 User navigates to course GW', (widgetTester) async {
      app.main();
      // login
      await widgetTester.pumpAndSettle();
      await widgetTester.tap(find.byKey(const Key('toLoginButton')));
      await widgetTester.pumpAndSettle();

      //await widgetTester.enterText(find.byKey(const Key('emailField')), 'newuser$uniqueId@gmail.com');
      await widgetTester.enterText(find.byKey(const Key('emailField')), 'newuser@gmail.com');
      await widgetTester.enterText(find.byKey(const Key('passwordField')), 'pass');
      await widgetTester.pumpAndSettle();

      await widgetTester.tap(find.byKey(const Key('loginButton')));
      await widgetTester.pumpAndSettle();

      await widgetTester.tap(find.byType(RecommendItem).first);
      await widgetTester.pumpAndSettle();

      await widgetTester.tap(find.byType(BookmarkBox).first);
      await widgetTester.pumpAndSettle();

      await widgetTester.tap(find.byType(BackButton));
      await widgetTester.pumpAndSettle();

      // go to wishlist page
      await widgetTester.tap(find.byType(BottomBarItem).at(3));
      await widgetTester.pumpAndSettle();

      // click the favorited item
      await widgetTester.tap(find.byType(FavoritesItem));
      await widgetTester.pumpAndSettle();

      expect(find.byType(CourseLandingPage), findsOneWidget);
    });
  });

  group('Account page test', () {
    // T19: Verify that all widgets loaded properly
    testWidgets('T19 Account page loaded GW', (widgetTester) async {
      app.main();
      await widgetTester.pumpAndSettle();
      await widgetTester.tap(find.byKey(const Key('toLoginButton')));
      await widgetTester.pumpAndSettle();

      await widgetTester.enterText(find.byKey(const Key('emailField')), 'newuser$uniqueId@gmail.com');
      await widgetTester.enterText(find.byKey(const Key('passwordField')), 'pass');
      await widgetTester.pumpAndSettle();
      
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