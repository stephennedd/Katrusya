import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../Themes/app_colors.dart';

class FormInput extends StatefulWidget {
  FormInput(
      {Key? key,
        required this.text,
        this.hasIcon = false,
        this.icon,
        this.type,
        this.isPassword = false,
        this.validatorText = "value",
        required this.textController,
        this.maxLines = 1,
        this.minLines = 1,
        this.isObscured = false
      })
      : super(key: key);
  final String text;
  bool hasIcon;
  String? icon;
  TextInputType? type;
  bool isPassword;
  String validatorText;
  TextEditingController textController;
  int maxLines;
  int minLines;
  bool isObscured;

  @override
  State<FormInput> createState() => _FormInputState();
}

class _FormInputState extends State<FormInput> {
  @override
  Widget build(BuildContext context) {
    return Container(
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
          ]),
      child: TextFormField(
        maxLines: widget.maxLines,
        minLines: widget.minLines,
        onChanged: (newValue) {
          widget.textController.text = newValue;
        },
        keyboardType: widget.type,
        obscureText: widget.isObscured,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter ${widget.validatorText}';
          }
          return null;
        },
        autovalidateMode: AutovalidateMode.onUserInteraction,
        decoration: InputDecoration(
            prefixIcon: Padding(
              padding: const EdgeInsets.only(right: 5),
              child: widget.hasIcon ? SvgPicture.asset(widget.icon!) : null,
            ),
            suffixIcon: widget.isPassword ? AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              child: IconButton(
                icon: widget.isObscured ? SvgPicture.asset("assets/icons/eye.svg", width: 25,) : SvgPicture.asset("assets/icons/eye-closed.svg", width: 25,) ,
                onPressed: () {
                  setState(() {
                    widget.isObscured = !widget.isObscured;
                  });
                },
                splashColor: Colors.transparent,
              ),
            ) : null,
            prefixIconConstraints:
                const BoxConstraints(maxWidth: 30, maxHeight: 30),
            border: InputBorder.none,
            hintText: widget.text,
            hintStyle: const TextStyle(
                fontFamily: 'Nexa-Trial',
                fontSize: 15,
                fontWeight: FontWeight.w400,
                color: Colors.grey)),
      ),
    );
  }
}
