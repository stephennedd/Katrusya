import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend/Screens/root_app.dart';
import 'package:frontend/Themes/app_colors.dart';
import 'package:frontend/models/users/login_model.dart';
import 'package:frontend/screens/forgot_password.dart';
import 'package:frontend/screens/signinoptions/SignUp.dart';
import 'package:frontend/screens/signup.dart';
import 'package:frontend/storage/secure_storage.dart';
import 'package:frontend/widgets/button.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';

import '../controllers/users/user_controller.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);
  static const String routeName = "/login";

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  UsersController usersController = Get.put(UsersController());
  final GetStorage _getStorage = GetStorage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: buildAppbar(),
        body: buildBody(),
        backgroundColor: Colors.white,
        bottomNavigationBar: buildBottomNavBar());
  }

  AppBar buildAppbar() {
    return AppBar(
      automaticallyImplyLeading: false,
      elevation: 0,
      backgroundColor: appBarColor,
      centerTitle: true,
      title: const Text(
        "Katrusya",
        style: TextStyle(
            fontFamily: 'Nexa-Trial',
            fontSize: 26,
            color: textColor,
            fontWeight: FontWeight.w700),
      ),
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
                      padding: const EdgeInsets.only(left: 10, bottom: 3),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: appBarColor,
                          boxShadow: [
                            BoxShadow(
                                color: shadowColor.withOpacity(.1),
                                spreadRadius: .5,
                                blurRadius: .5,
                                offset: const Offset(0, 0))
                          ]),
                      child: TextFormField(
                        onChanged: (value) => {emailController.text = value},
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter an email';
                          //} else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                          } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}\s*$')
                              .hasMatch(value)) {
                            return 'Please enter a valid email address';
                          }
                          return null;
                        },
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: InputDecoration(
                            prefixIcon: Padding(
                              padding: const EdgeInsets.only(right: 5),
                              child: SvgPicture.asset("assets/icons/email.svg"),
                            ),
                            prefixIconConstraints: const BoxConstraints(
                                maxWidth: 30, maxHeight: 30),
                            border: InputBorder.none,
                            hintText: "email",
                            hintStyle: const TextStyle(
                                fontFamily: 'Nexa-Trial',
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                                color: Colors.grey)),
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
                                offset: const Offset(0, 0))
                          ]),
                      child: TextFormField(
                        onChanged: (value) => {passwordController.text = value},
                        obscureText: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
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
                            prefixIconConstraints: const BoxConstraints(
                                maxHeight: 30, maxWidth: 30),
                            border: InputBorder.none,
                            hintText: "password",
                            hintStyle: const TextStyle(
                                fontFamily: 'Nexa-Trial',
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                                color: Colors.grey)),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                            onPressed: () {
                              Navigator.pushNamed(
                                  context, ForgotPage.routeName);
                            },
                            child: const Text(
                              "forgot your password",
                              style: TextStyle(
                                  fontFamily: 'Nexa-Trial',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: primaryDark),
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
              width: double.infinity,
              text: "login",
              color: primary,
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  String email = emailController.text.removeAllWhitespace;
                  String password = passwordController.text.removeAllWhitespace;

                  var response = await usersController.loginUser(
                      new LoginModel(email: email, password: password));
                  if (response.statusCode == 201) {
                    // successful login, navigate to the next page

                    var responseLoggedInUser = response.body;
                    var loggedInUser = json.decode(responseLoggedInUser);

                    _getStorage.write("userId", loggedInUser["data"]["id"]);
                    await SecureStorage.setAccessToken(
                        loggedInUser["data"]["accessToken"]);
                    // print(loggedInUser["data"]["accessToken"]);
                    print(loggedInUser["data"]);

                    var token = await SecureStorage.getAccessToken();
                    _getStorage.write(
                        "username", loggedInUser["data"]["username"]);

                    DateTime date =
                    DateTime.parse(loggedInUser["data"]["created_at"]);
                    String formattedDate = DateFormat('d MMMM, y').format(date);
                    _getStorage.write("createdAt", formattedDate);
                    // _getStorage.write("phone", loggedInUser["data"]["phone"]);

                    usersController.isUserLoggedIn.value = true;
                    usersController.balanceOfTokens.value =
                    loggedInUser["data"]["balance_of_tokens"];
                    usersController.userRoles.value =
                    loggedInUser["data"]["roles"];
                    usersController.phone.value = loggedInUser["data"]["phone"];
                    usersController.email.value = loggedInUser["data"]["email"];

                    await usersController
                        .getUserFavoriteCourses(loggedInUser["data"]["id"]);

                    await usersController
                        .getUserCourses(loggedInUser["data"]["id"]);
                    //Navigator.pop(context);
                    Navigator.pushReplacementNamed(context, RootApp.routeName);
                  } else {
                    // unsuccessful login, display error message
                    var responseBody = json.decode(response.body);
                    String errorMessage = responseBody['message'];
                    // ScaffoldMessenger.of(context)
                    //     .showSnackBar(SnackBar(content: Text(errorMessage)));
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text(errorMessage),
                            content: Text("Invalid email or password."),
                            actions: [
                              ElevatedButton(
                                child: Text("OK"),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              )
                            ],
                          );
                        });
                  }
                }
              },
            ),
            SizedBox(
              height: 30,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    "or",
                    style: TextStyle(
                        fontFamily: 'Nexa-Trial',
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                        color: textColor),
                  ),
                ],
              ),
            ),
            ButtonSimple(
              width: double.infinity,
              text: "create an account",
              color: primaryDark,
              textColor: Colors.white,
              onPressed: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SignupPage(),
                    ));
              },
            ),
          ],
        ),
      ),
    );
  }
}
