import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend/Screens/root_app.dart';
import 'package:frontend/Themes/app_colors.dart';
import 'package:frontend/screens/forgot_password.dart';
import 'package:frontend/widgets/button.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);
  static const String routeName = "/login";

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppbar(),
      body: buildBody(),
      backgroundColor: Colors.white,
      bottomNavigationBar: buildBottomNavBar()
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
    double screenWidth = MediaQuery.of(context).size.width;
    return Container(
      padding: const EdgeInsets.only(left: 25, right: 25),
      child: Center(
        child: Column(
          children: [
            Image.asset(
              "images/logo_graphic.png",
              height: screenWidth * 0.5,
              width: screenWidth * 0.5,
            ),

            SizedBox(
              height: screenWidth * 0.10,
            ),

            Form(
              key: _formKey,
              child: Column(

              children: [
                Container(
                  padding: const EdgeInsets.only(left: 10 ,bottom: 3),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: appBarColor,
                      boxShadow: [
                        BoxShadow(
                            color: shadowColor.withOpacity(.1),
                            spreadRadius: .5,
                            blurRadius: .5,
                            offset: const Offset(0, 0)
                        )
                      ]
                  ),

                  child: TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter an email';
                      } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value))
                        {
                          return 'Please enter a valid email address';
                        }
                      return null;
                    },
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: InputDecoration(
                        prefixIcon: Padding(
                          padding: const EdgeInsets.only(right: 5),
                          child: SvgPicture.asset(
                              "assets/icons/email.svg"
                          ),
                        ),
                        prefixIconConstraints: const BoxConstraints(
                            maxWidth: 30,
                            maxHeight: 30
                        ),
                        border: InputBorder.none,
                        hintText: "email",
                        hintStyle: const TextStyle(
                            fontFamily: 'Nexa-Trial',
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                            color: Colors.grey
                        )
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),

                Container(
                  padding: const EdgeInsets.only(left: 10, bottom: 3),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: appBarColor,
                      boxShadow: [
                        BoxShadow(
                            color: shadowColor.withOpacity(.1),
                            spreadRadius: .5,
                            blurRadius: .5,
                            offset: const Offset(0, 0)
                        )
                      ]
                  ),
                  child: TextFormField(
                    obscureText: true,
                    validator: (value) {
                      if(value == null || value.isEmpty) {
                        return 'Please enter a password';
                      }
                      return null;
                    },
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: InputDecoration(
                        prefixIcon: Padding(
                          padding: const EdgeInsets.only(right: 5),
                          child: SvgPicture.asset(
                            "assets/icons/password.svg",
                          ),
                        ),
                        prefixIconConstraints: const BoxConstraints(maxHeight: 30, maxWidth: 30),
                        border: InputBorder.none,
                        hintText: "password",
                        hintStyle: const TextStyle(
                            fontFamily: 'Nexa-Trial',
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                            color: Colors.grey
                        )
                    ),
                  ),
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(onPressed: () {
                      Navigator.pushNamed(context, ForgotPage.routeName);
                      },
                      child: const Text(
                        "forgot your password",
                      style: TextStyle(
                        fontFamily: 'Nexa-Trial',
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: primaryDark
                      ),
                    ))
                  ],
                ),

              ],
            )),
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
              text: "login with Google",
              color: primaryDark,
              textColor: Colors.white,
              onPressed: () {
                print("google login pressed");
              },
            ),

            const SizedBox(
              height: 25,
              child: Text(
                "or",
                style: TextStyle(
                    fontFamily: 'Nexa-Trial',
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                    color: textColor
                ),
              ),
            ),

            ButtonSimple(
              text: "login",
              color: primary,
              onPressed: () {
                if(_formKey.currentState!.validate()) {
                  // TODO check if form field data authenticates.
                  Navigator.pushNamed(context, RootApp.routeName);
                }
              },
            )
          ],
        ),
      ),
    );
  }

}
