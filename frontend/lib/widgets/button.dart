import 'package:flutter/material.dart';

class ButtonSimple extends StatelessWidget {
  ButtonSimple({Key? key, required this.text, required this.color, this.textColor = Colors.black, this.onPressed}) : super(key: key);
  final String text;
  Color textColor;
  Color color;
  GestureTapCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return SizedBox(
      width: screenWidth,
      height: 45,
      child: ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(color),
            shape: MaterialStateProperty.all(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50)
                )
            ),
            elevation: MaterialStateProperty.all(0),
          ),
          onPressed: onPressed,
          child: Text(
            text,
            style: TextStyle(
                fontFamily: 'Nexa-Trial',
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: textColor
            ),
          )
      ),
    );
  }
}
