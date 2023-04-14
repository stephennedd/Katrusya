import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/screens/signup.dart';
import 'package:frontend/screens/start.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateMocks([http.Client])
void main() {
  final MockClient mockClient = MockClient();

  TestWidgetsFlutterBinding.ensureInitialized().window.physicalSizeTestValue = Size(851, 393);
  testWidgets('start page UI test', (WidgetTester tester) async {
    // Configure the screen size

    // Build our app and trigger a frame.
    await tester.pumpWidget(MaterialApp(home: StartPage()));

    // Verify that our counter starts at 0.
    expect(find.text("Don't just learn, earn with Katrusya"), findsOneWidget);
    expect(find.text("Invest in your education and your future. sign up now!"), findsOneWidget);
  });

  testWidgets('login flow', (tester) async {

    when(mockClient.post(Uri.parse('http://192.168.178.151:3000/auth/login'),
        body: {
          "email":"sn@gmail.com",
          "password":"pass",
        })).thenAnswer((_) async =>
        http.Response(json.encode({"succeeded":true}), 201));
    // final navigator = MockNavigator();
    // when(() => navigator.push(any())).thenAnswer((_) async {});

    await tester.pumpWidget(MaterialApp(
      home: StartPage(),
      routes: {
        SignupPage.routeName: (context) => const SignupPage()
      },
    ));

    await tester.tap(find.byKey(Key("getStartedButton")));
    await tester.pumpAndSettle();

    // Expect RootApp page to be pushed onto the Navigator
    expect(find.byType(SignupPage), findsOneWidget);
  });
}

class MockClient extends Mock implements http.Client {
}