import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../Themes/app_colors.dart';

class FormInput extends StatelessWidget {
  FormInput({Key? key, required this.text, required this.icon, this.type, this.isPassword = false, this.validatorText = "value"}) : super(key: key);
  final String text;
  String icon;
  TextInputType? type;
  bool isPassword;
  String validatorText;

  @override
  Widget build(BuildContext context) {
    return Container(
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
        keyboardType: type,
        obscureText: isPassword,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter $validatorText';
          }
          return null;
        },
        autovalidateMode: AutovalidateMode.onUserInteraction,
        decoration: InputDecoration(
            prefixIcon: Padding(
              padding: const EdgeInsets.only(right: 5),
              child: SvgPicture.asset(
                  icon
              ),
            ),
            prefixIconConstraints: const BoxConstraints(
                maxWidth: 30,
                maxHeight: 30
            ),
            border: InputBorder.none,
            hintText: text,
            hintStyle: const TextStyle(
                fontFamily: 'Nexa-Trial',
                fontSize: 15,
                fontWeight: FontWeight.w400,
                color: Colors.grey
            )
        ),
      ),
    );
  }
}
