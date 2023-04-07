import 'package:flutter/material.dart';
import 'package:frontend/Themes/app_colors.dart';

class SettingsItem extends StatelessWidget {
  SettingsItem({Key? key, required this.itemText, this.onTap}) : super(key: key);
  String itemText;
  GestureTapCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
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
      ),
    );
  }
}
