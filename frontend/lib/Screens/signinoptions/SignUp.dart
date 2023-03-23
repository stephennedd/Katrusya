import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frontend/screens/signinoptions/SignIn.dart';
import 'package:page_transition/page_transition.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
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
          const Padding(
              padding: EdgeInsets.only(bottom: 200.0),
              child: Text(
                'Sign up',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold),
              )),
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
              padding: const EdgeInsets.only(left: 75.0),
              child: Row(
                children: [
                  const Text(
                    'Already have an account?',
                    style: TextStyle(color: Colors.white),
                  ),
                  MaterialButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                            context,
                            PageTransition(
                                child: const SignIn(),
                                type: PageTransitionType.bottomToTop));
                      },
                      child: const Text('Sign in',
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
