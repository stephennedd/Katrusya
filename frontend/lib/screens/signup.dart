import 'package:flutter/material.dart';
import 'package:frontend/screens/login.dart';
import 'package:frontend/widgets/app_bar_box.dart';
import 'package:frontend/widgets/text_input.dart';
import '../Themes/app_colors.dart';
import '../widgets/button.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);
  static const String routeName = "/signup";

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        title: "Katrusya",
      ),
      body: buildBody(),
      bottomNavigationBar: buildBottomNavBar(),
      backgroundColor: Colors.white,
    );
  }

  Widget buildBody() {
    return Container(
      padding: const EdgeInsets.only(left: 25, right: 25),
      child: Center(
        child: Column(
          children: [
            Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  "Create an account",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: 'Nexa-Trial',
                      fontWeight: FontWeight.w800,
                      fontSize: 24,
                      color: textColor
                  ),
                ),
                const Text(
                  "Enter your details",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: 'Nexa-Trial',
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      color: textColor
                  ),
                ),

                const SizedBox(
                  height: 20,
                ),

                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      FormInput(
                        text: 'full name',
                        icon: "assets/icons/user.svg",
                        type: TextInputType.text,
                        validatorText: "a full name",
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      FormInput(
                        text: 'phone',
                        icon: "assets/icons/phone.svg",
                        type: TextInputType.phone,
                        validatorText: "a phone number",
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      FormInput(
                        text: 'email',
                        icon: "assets/icons/email.svg",
                        type: TextInputType.emailAddress,
                        validatorText: "an email address",
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      FormInput(
                        text: 'password',
                        icon: "assets/icons/password.svg",
                        type: TextInputType.text,
                        isPassword: true,
                        validatorText: "a password",
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                    ],
                  )
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildBottomNavBar() {
    return Padding(
      padding: const EdgeInsets.only(left: 25, right: 25),
      child: SizedBox(
        height: 140,
        child: Column(
          children: [
            ButtonSimple(
              text: "sign up",
              color: primary,
              textColor: primaryDark,
              onPressed: () {
                if(_formKey.currentState!.validate()) {
                  // TODO add user to users in database
                  Navigator.pushNamed(context, LoginPage.routeName);
                  }
              },
            ),
          ],
        ),
      ),
    );
  }
}
