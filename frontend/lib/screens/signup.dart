import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend/models/users/user_model.dart';
import 'package:frontend/screens/login.dart';
import 'package:frontend/widgets/app_bar_box.dart';
import 'package:frontend/widgets/text_input.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../Themes/app_colors.dart';
import '../controllers/users/user_controller.dart';
import '../widgets/button.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);
  static const String routeName = "/signup";

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();

  // define controller for each input field
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  UsersController usersController = Get.put(UsersController());

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
                      color: textColor),
                ),
                const Text(
                  "Enter your details",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: 'Nexa-Trial',
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      color: textColor),
                ),
                const SizedBox(
                  height: 20,
                ),
                Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        FormInput(
                            text: 'username',
                            icon: "assets/icons/user.svg",
                            type: TextInputType.text,
                            validatorText: "a username",
                            textController: usernameController),
                        const SizedBox(
                          height: 20,
                        ),
                        FormInput(
                          text: 'phone',
                          icon: "assets/icons/phone.svg",
                          type: TextInputType.phone,
                          validatorText: "a phone number",
                          textController: phoneController,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        FormInput(
                          text: 'email',
                          icon: "assets/icons/email.svg",
                          type: TextInputType.emailAddress,
                          validatorText: "an email address",
                          textController: emailController,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        //TODO The password should be possible to see
                        FormInput(
                          text: 'password',
                          icon: "assets/icons/password.svg",
                          type: TextInputType.text,
                          isPassword: true,
                          validatorText: "a password",
                          textController: passwordController,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                      ],
                    ))
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
              width: double.infinity,
              text: "sign up",
              color: primary,
              textColor: primaryDark,
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  // Done: add user to users in database
                  String username = usernameController.text;
                  String phone = phoneController.text;
                  String email = emailController.text;
                  String password = passwordController.text;
                  var response = await usersController.registerUser(
                      new UserModel(
                          username: username,
                          phone: phone,
                          email: email,
                          password: password));

                  // Navigator.pushNamed(context, LoginPage.routeName);

                  if (response.statusCode == 201) {
                    // successful login, navigate to the next page
                    Navigator.pushNamed(context, LoginPage.routeName);
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
                            title: Text('There is an error'),
                            content: Text(errorMessage),
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
              }),
          ],
        ),
      ),
    );
  }
}
