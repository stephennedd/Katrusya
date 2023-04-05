import 'package:flutter/material.dart';

class SettingsItem extends StatelessWidget {
  SettingsItem({Key? key, required this.itemText, this.textColor = Colors.black}) : super(key: key);
  String itemText;
  Color textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            itemText,
            style: TextStyle(
              fontFamily: 'Nexa-Trial',
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: textColor
            ),
          ),
          Icon(Icons.arrow_forward_ios_rounded)
        ],
      ),
    );
  }
}
