/*
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/Screens/root_app.dart';
import 'package:frontend/screens/login.dart';
import 'package:frontend/widgets/button.dart';

*/
/*void main() {
  testWidgets('testLoginGoodWeather', (tester) async {
    //Build the login screen widget
    await tester.pumpWidget(MaterialApp(home: LoginPage()));

    //Enter valid credentials in the login form inputs
    await tester.enterText(find.byKey(Key("emailField")), 'sn@gmail.com');
    await tester.enterText(find.byKey(Key("passwordField")), 'pass');
    await tester.tap(find.byKey(Key("loginButton")));
    await tester.pumpAndSettle();

    expect(find.text('welcome'), findsOneWidget);
  });
}*//*


void main() {
  group('LoginPage', () {
    // Set device screen size
    TestWidgetsFlutterBinding.ensureInitialized().window.physicalSizeTestValue = Size(851, 393);


    testWidgets('Check login button is present', (tester) async {
      await tester.pumpWidget(MaterialApp(home: LoginPage()));

      expect(find.widgetWithText(ButtonSimple, 'login'), findsOneWidget);
    });

    testWidgets('Check email and password fields are present', (tester) async {
      await tester.pumpWidget(MaterialApp(home: LoginPage()));

      expect(find.byKey(Key('emailField')), findsWidgets);
      expect(find.byKey(Key('passwordField')), findsWidgets);
    });

    testWidgets('Check form validation', (tester) async {
      await tester.pumpWidget(MaterialApp(home: LoginPage()));

      // Enter invalid email and password
      await tester.enterText(find.byKey(Key('emailField')), 'invalidemail');
      await tester.enterText(find.byKey(Key('passwordField')), '');

      await tester.tap(find.widgetWithText(ButtonSimple, 'login'));
      await tester.pumpAndSettle();

      // Expect error messages to be displayed
      expect(find.text('Please enter a valid email address'), findsOneWidget);
      expect(find.text('Please enter a password'), findsOneWidget);
    });

    testWidgets('Check login button tap navigates to RootApp', (tester) async {
      await tester.pumpWidget(MaterialApp(home: LoginPage()));

      await tester.tap(find.widgetWithText(ButtonSimple, 'login'));
      await tester.pumpAndSettle();

      // Expect RootApp page to be pushed onto the Navigator
      expect(find.byType(RootApp), findsOneWidget);
    });
  });
}*/

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:frontend/Screens/root_app.dart';
import 'package:frontend/screens/login.dart';
import 'package:frontend/widgets/button.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http; // Import the http package
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart'; // Import the flutter_test package

void main() {
  // Define a mock HTTP client using http package's MockClient
  final MockClient mockClient = MockClient();

  // Define a function to set up the test
  setUp(() {
    // Initialize the GetStorage instance
    GetStorage.init();
  });

  // Define a function to tear down the test
  tearDown(() {
    // Reset the GetStorage instance
    GetStorage().erase();
  });

  // Define the test
  testWidgets('Test login functionality', (WidgetTester tester) async {
    // Mock the API response
    final loginResponse = {
      "succeeded": true,
      "data": {
        "id": 2,
        "user_guid": null,
        "name": null,
        "username": "Stephen Nedd",
        "balance_of_tokens": 0,
        "avatar": null,
        "email": "sn@gmail.com",
        "phone": "123456789",
        "is_active": 1,
        "roles": [
          "teacher"
        ],
        "email_verified_at": null,
        "email_confirmed": 0,
        "created_at": "2023-04-11T18:41:27.000Z",
        "updated_at": null,
        "isAuthenticated": true,
        "accessToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VybmFtZSI6IlN0ZXBoZW4gTmVkZCIsImlkIjoyLCJpYXQiOjE2ODEzODkxNjQsImV4cCI6MTY4MTM5Mjc2NH0.36ILChSzQb8ArQGWCVk_TBfABI1sI9HYzuZztu0LALg",
        "expiresIn": 60,
        // Add other relevant data as needed
      }
    };

    when(mockClient.post(Uri.parse('http://192.168.178.151:3000/auth/login'),
        body: {
          "email":"sn@gmail.com",
          "password":"pass",
        })).thenAnswer((_) async =>
        http.Response(json.encode(loginResponse), 201)); // Return the mock response

    // Build the LoginPage widget
    await tester.pumpWidget(
      MaterialApp(
        home: LoginPage(),
      ),
    );

    // Enter email and password in the text fields
    await tester.enterText(find.byKey(Key('emailField')), 'sn@gmail.com');
    await tester.enterText(find.byKey(Key('passwordField')), 'pass');

    // Tap the login button
    await tester.tap(find.widgetWithText(ButtonSimple, 'login'));
    await tester.pump();

    // Verify that the API was called with the correct URL and body
    verify(mockClient.post(Uri.parse('http://192.168.178.151:3000/auth/login'),
        body: {
          "email":"sn@gmail.com",
          "password":"pass",
        }));

    // Verify that the user was logged in and navigated to the RootApp screen
    expect(find.byType(RootApp), findsOneWidget);
  });
}

// Define a mock HTTP client using the http package's MockClient
class MockClient extends Mock implements http.Client {
}
