import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend/Themes/app_colors.dart';
import 'package:frontend/screens/login.dart';
import 'package:frontend/screens/signup.dart';
import 'package:frontend/widgets/button.dart';

class StartPage extends StatefulWidget {
  const StartPage({Key? key}) : super(key: key);
  static const String routeName = "/start";

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: appBarColor,
      body: buildBody(),
      appBar: getAppBar(),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(left: 25, right: 25),
        child: SizedBox(
          height: 140,
          child: Column(
            children: [
              ButtonSimple(
                key: const Key("getStartedButton"),
                width: double.infinity,
                text: "get started",
                color: primary,
                textColor: primaryDark,
                onPressed: () {
                  Navigator.pushReplacementNamed(context, SignupPage.routeName);
                },
              ),

              const SizedBox(
                height: 10,
              ),

              ButtonSimple(
                key: const Key("toLoginButton"),
                width: double.infinity,
                text: "already have an account",
                color: Colors.white,
                onPressed: () {
                  Navigator.pushReplacementNamed(context, LoginPage.routeName);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  AppBar getAppBar() {
    return AppBar(
      automaticallyImplyLeading: false,
      elevation: 0,
      backgroundColor: appBarColor,
      centerTitle: true,
      title: const Text(
        "Katrusya",
        style: TextStyle(
          fontFamily: 'Nexa-Trial',
          fontSize: 25,
          color: textColor,
          fontWeight: FontWeight.w700
        ),),
    );
  }

  Widget buildBody() {
    double screenWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: const EdgeInsets.only(left: 25, right: 25),
      child: Column(
        children: [
          SizedBox(
            height: screenWidth * 0.10,
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                  "images/hero_cropped.svg",
                width: screenWidth * 0.75
              ),
            ],
          ),

          SizedBox(
            height: screenWidth * 0.10,
          ),

          Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Text(
                  "Don't just learn, earn with Katrusya",
                  maxLines: 2,
                  style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                      fontSize: screenWidth * 0.072,
                      color: textColor
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Text(
                  "Invest in your education and your future. sign up now!",
                  maxLines: 2,
                  style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w300,
                      fontSize: screenWidth * 0.04,
                      color: textColor
                  ),
                ),
              ),
            ],
          ),

        ],
      ),
    );
  }

}
