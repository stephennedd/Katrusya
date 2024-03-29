import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:frontend/models/users/user_model.dart';
import 'package:frontend/screens/login.dart';
import 'package:frontend/widgets/text_input.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
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
  final GetStorage _getStorage = GetStorage();

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
                            key: const Key("usernameField"),
                            text: 'username',
                            icon: "assets/icons/user.svg",
                            type: TextInputType.text,
                            validatorText: "a username",
                            textController: usernameController),
                        const SizedBox(
                          height: 20,
                        ),
                        FormInput(
                          key: const Key("phoneField"),
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
                          key: const Key("emailField"),
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
                          key: const Key("passwordField"),
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
              key: const Key("signupButton"),
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
                        UserModel(
                            username: username,
                            phone: phone,
                            email: email,
                            password: password));

                    if (response.statusCode == 201) {
                      // successful login, navigate to the next page
                      Navigator.pushReplacement(context, MaterialPageRoute(
                          builder: (context) => const LoginPage())
                      );
                    } else {
                      // unsuccessful login, display error messages
                      var responseBody = json.decode(response.body);
                      String errorMessage = responseBody['message'];
                      // ScaffoldMessenger.of(context)
                      //     .showSnackBar(SnackBar(content: Text(errorMessage)));
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('There is an error'),
                              content: Text(errorMessage),
                              actions: [
                                ElevatedButton(
                                  child: const Text("OK"),
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
            const SizedBox(
              height: 10,
            ),
            ButtonSimple(
              text: "already have an account",
              color: appBarColor,
              onPressed: () {
                Navigator.pushReplacement(context, MaterialPageRoute(
                    builder: (context) => const LoginPage()));
              },
            )
          ],
        ),
      ),
    );
  }
}
