import 'package:flutter/material.dart';
import '../Themes/app_colors.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  MyAppBar(
      {Key? key,
      required this.title,
      this.backgroundColor = appBarColor,
      this.hasAction = false,
      this.icon,
      this.onTap,
      this.hasBackButton = true,
      this.centerTitle = true,
      this.onBackPressed})
      : super(key: key);
  final String title;
  Color backgroundColor;
  bool hasAction;
  final icon;
  GestureTapCallback? onTap;
  bool centerTitle;
  bool hasBackButton;
  GestureTapCallback? onBackPressed;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      elevation: 0,
      backgroundColor: backgroundColor,
      leading: hasBackButton
          ? const BackButton(
              color: textColor
            )
          : null,
      centerTitle: centerTitle,
      title: Text(
        title,
        style: TextStyle(
            fontFamily: 'Nexa-Trial',
            fontSize: 24,
            color: backgroundColor == primaryDark ? Colors.white : textColor,
            fontWeight: FontWeight.w700),
      ),
      actions: hasAction
          ? <Widget>[
              IconButton(
                  icon: icon,
                  color:
                      backgroundColor == primaryDark ? Colors.white : textColor,
                  tooltip: 'Go to leaderboard',
                  onPressed: onTap)
            ]
          : null,
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
