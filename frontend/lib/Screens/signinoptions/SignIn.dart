import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frontend/Screens/homeScreen.dart';
import 'package:frontend/Screens/signinoptions/SignUp.dart';
import 'package:page_transition/page_transition.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      // ignore: sort_child_properties_last
      child: Center(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
              padding: EdgeInsets.only(bottom: 200.0),
              child: Text(
                'Sign in',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold),
              )),
          Padding(
              padding: const EdgeInsets.only(bottom: 0.0),
              child: ElevatedButton.icon(
                onPressed: () async {
                  Navigator.pushReplacement(
                      context,
                      PageTransition(
                          child: const HomeScreen(),
                          type: PageTransitionType.rightToLeftWithFade));
                },
                icon: const Icon(EvaIcons.email),
                label: const Text("Sign in with Email"),
              )),
          Padding(
            padding: const EdgeInsets.only(bottom: 15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 180.0,
                  child: Divider(color: Colors.white),
                ),
                Text('or', style: TextStyle(color: Colors.white)),
                SizedBox(width: 180.0, child: Divider(color: Colors.white)),
              ],
            ),
          ),
          Padding(
              padding: const EdgeInsets.only(bottom: 15.0),
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(EvaIcons.google),
                label: const Text("Sign in with google"),
              )),
          Padding(
              padding: const EdgeInsets.only(bottom: 15.0),
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(EvaIcons.facebook),
                label: const Text("Sign in with facebook"),
              )),
          Padding(
              padding: const EdgeInsets.only(bottom: 15.0),
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(FontAwesomeIcons.apple),
                label: const Text("Sign in with apple"),
              )),
          Padding(
              padding: const EdgeInsets.only(left: 130.0),
              child: Row(
                children: [
                  const Text(
                    'New user?',
                    style: TextStyle(color: Colors.white),
                  ),
                  MaterialButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                            context,
                            PageTransition(
                                child: const SignUp(),
                                type: PageTransitionType.bottomToTop));
                      },
                      child: const Text('Sign up',
                          style: TextStyle(color: Colors.white)))
                ],
              ))
        ],
      )),
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('images/landingPageBg.png'),
              fit: BoxFit.fitHeight,
              colorFilter: ColorFilter.mode(Colors.black54, BlendMode.darken))),
    ));
  }
}
