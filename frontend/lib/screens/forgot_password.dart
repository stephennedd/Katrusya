import 'package:flutter/material.dart';

import '../Themes/app_colors.dart';
import '../widgets/button.dart';
import '../widgets/text_input.dart';
import 'login.dart';

class ForgotPage extends StatefulWidget {
  const ForgotPage({Key? key}) : super(key: key);
  static const String routeName = "/forgot";

  @override
  State<ForgotPage> createState() => _ForgotPageState();
}

class _ForgotPageState extends State<ForgotPage> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppbar(),
      body: buildBody(),
      bottomNavigationBar: buildBottomNavBar(),
      backgroundColor: Colors.white,
    );
  }

  AppBar buildAppbar() {
    return AppBar(
      automaticallyImplyLeading: false,
      elevation: 0,
      backgroundColor: appBarColor,
      leading: const BackButton(
        color: textColor,
      ),
      centerTitle: true,
      title: const Text(
        "Katrusya",
        style: TextStyle(
            fontFamily: 'Nexa-Trial',
            fontSize: 26,
            color: textColor,
            fontWeight: FontWeight.w700
        ),),
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
                  "Find your account",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: 'Nexa-Trial',
                      fontWeight: FontWeight.w800,
                      fontSize: 24,
                      color: textColor
                  ),
                ),
                const Text(
                  "Enter the email address associated with your account to change your password",
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
                          text: 'email',
                          icon: "assets/icons/email.svg",
                          type: TextInputType.emailAddress,
                          validatorText: "an email",
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
              text: "reset password",
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
